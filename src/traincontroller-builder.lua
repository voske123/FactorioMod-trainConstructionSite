require 'util'
require("__LSlib__/LSlib")

-- Create class
Traincontroller.Builder = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Traincontroller.Builder:onInit()
  if not global.TC_data.Builder then
    global.TC_data.Builder = self:initGlobalData()
  end
end



function Traincontroller.Builder:onLoad()
  -- sync the on tick event
  if global.TC_data.Builder["onTickActive"] then
    self:activateOnTick()
  else
    self:deactivateOnTick()
  end
end



-- called when a mod setting changed
function Traincontroller.Builder:onSettingChanged(event)
  -- check if the tickrate has changed
  if event.setting_type == "runtime-global" and event.setting == "trainController-tickRate" then
    -- we need to update the on_nth_tick event (step 2), but we fist need to
    -- disable the old one if it was active (step 1), and if it was active,
    -- we have to reactivate it afther updating the settings (step 3)
    local onTickWasActive = global.TC_data.Builder["onTickActive"]

    -- STEP 1: disable the old active on_tick
    if onTickWasActive then
      self:deactivateOnTick()
    end

    -- STEP 2: update the settings
    global.TC_data.Builder["onTickDelay"] = settings.global[event.setting].value

    -- STEP 3: reactivate the on_tick with new settings
    if onTickWasActive then
      self:activateOnTick()
    end

  end
end



-- Initiation of the global data
function Traincontroller.Builder:initGlobalData()
  local Builder = {
    ["version"] = 1, -- version of the global data
    ["onTickActive"] = false, -- if the on_tick event is active or not
    ["onTickDelay"] = settings.global["trainController-tickRate"].value,

    ["builderStates"] = { -- states in the builder process
      ["initialState"] = 1, -- what state the controller is in when it is placed down

      ["dispatching" ] = 1, -- waiting till previous train clears the train block
      ["building"    ] = 2, -- waiting on resources, building each component
      ["idle"        ] = 3, -- wait until a depot request a train
      ["dispatch"    ] = 4, -- assembling the train components together and let the train drive off
    },
  }

  return util.table.deepcopy(Builder)
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Traincontroller.Builder:getBuildTrain(trainBuilderIndex)
  -- this function returns the build train, or nil if none found
  local trainBuilder = Trainassembly:getTrainBuilder(trainBuilderIndex)
  if not trainBuilder then return nil end

  -- STEP 1: Connect all the wagons together
  --         The whole train is already connected, so no need to do this manual

  -- STEP 2: Find one entity that is part of this train
  local machineLocation = trainBuilder[1] -- we know this one is always used (train with length 1)
  if not machineLocation then return nil end

  local trainEntity = Trainassembly:getCreatedEntity(machineLocation.surfaceIndex, machineLocation.position)
  if not (trainEntity and trainEntity.valid) then return nil end

  -- STEP 3: Find the train this trainEntity is part of
  local train = trainEntity.train
  if not (train and train.valid) then return nil end

  -- STEP 4: Before returning this train, make sure this is the whole train! (becose of step 1)
  if not (#train.carriages == #trainBuilder) then
    game.print("ERROR: The build train is not the fully build train, please report this to the mod author!")
    return nil
  end

  -- STEP 5: Now we can return this train
  return train
end



function Traincontroller.Builder:getControllerStatus(trainController)
  local position         = trainController.position
  return global.TC_data["trainControllers"][trainController.surface.index][position.y][position.x]["controllerStatus"]
end



--------------------------------------------------------------------------------
-- Behaviour functions
--------------------------------------------------------------------------------
function Traincontroller.Builder:updateController(surfaceIndex, position)
  -- This function will check the update for a single controller
  --game.print("Updating controller @ ["..surfaceIndex..", "..position.x..", "..position.y.."]")
  local controllerData      = global.TC_data["trainControllers"][surfaceIndex][position.y][position.x]
  local controllerStates    = global.TC_data.Builder["builderStates"]
  local controllerStatus    = controllerData["controllerStatus"]
  local oldControllerStatus = controllerStatus
  local controllerEntity    = controllerData["entity"]
  local trainBuilderIndex   = controllerData["trainBuilderIndex"]


  if controllerStatus == controllerStates["dispatching"] then
    -- controller is waiting till previous train clears the train block
    if self:canBuildNextTrain(trainBuilderIndex, controllerEntity) then
      -- if we can build a new train, we move on to the next step
      --game.print("Start building a train of length: "..#Trainassembly:getTrainBuilder(trainBuilderIndex))
      controllerStatus = controllerStates["building"]
    end
  end


  if controllerStatus == controllerStates["building"] then
    -- controller is waiting on resources, building each component
    if self:buildNextTrain(trainBuilderIndex) then
      -- if the whole train is build, we can send it away
      --game.print("Finished building a train of length: "..#Trainassembly:getTrainBuilder(trainBuilderIndex))
      controllerStatus = controllerStates["idle"]
    end
  end


  if controllerStatus == controllerStates["idle"] then
    -- controller is waiting to send the train away
    if self:depotIsRequestingTrain(controllerEntity) then
      -- if a depot is requesting a train, we can send it away
      --game.print("Ready to dispatch a train of length: "..#Trainassembly:getTrainBuilder(trainBuilderIndex))
      controllerStatus = controllerStates["dispatch"]
    end
  end


  if controllerStatus == controllerStates["dispatch"] then
    -- assembling the train components together and let the train drive off
    if self:assembleNextTrain(trainBuilderIndex, controllerEntity.backer_name) then
      -- update all traincontrollers with this name
      local trainControllers = Traincontroller:getAllTrainControllers(controllerEntity.surface.index, controllerEntity.backer_name)
      for _,trainController in pairs(trainControllers) do
        Traincontroller.Gui:updateOpenedGuis(trainController, false)
      end
      --game.print("Leaving train of length: "..#Trainassembly:getTrainBuilder(trainBuilderIndex))
      controllerStatus = controllerStates["dispatching"]
    end
  end


  -- the controller could have been removed
  if global.TC_data["trainControllers"] and
     global.TC_data["trainControllers"][surfaceIndex] and
     global.TC_data["trainControllers"][surfaceIndex][position.y] and
     global.TC_data["trainControllers"][surfaceIndex][position.y][position.x] then

    -- save changes to the global data before any gui updates
    global.TC_data["trainControllers"][surfaceIndex][position.y][position.x]["controllerStatus"] = controllerStatus

    -- update the gui if needed
    if controllerStatus ~= oldControllerStatus then
      Traincontroller.Gui:updateOpenedGuis(controllerEntity)
    end
  end

end



function Traincontroller.Builder:canBuildNextTrain(trainBuilderIndex, trainBuilderController)
  -- We need to check for each builder if it can place a train there
  local trainBuilder = Trainassembly:getTrainBuilder(trainBuilderIndex)
  if not trainBuilder then return false end
  --game.print("checking if it can build a train with length: "..#trainBuilder)

  -- STEP 1: Check if the train block is emtpy with the rail signal
  --         index 2: rail signal on other side of the track
  --                  => checking trainblock where the builder is
  local signalEntity = Traincontroller:getTrainHiddenEntity(trainBuilderController, 2)
  if signalEntity.signal_state ~= defines.signal_state.open then return false end

  --         index 1: rail signal on this side of the track
  --                  => checking trainblock in front of the builder
  signalEntity = Traincontroller:getTrainHiddenEntity(trainBuilderController, 1)
  if signalEntity.signal_state ~= defines.signal_state.open then return false end

  --game.print("signal was green!")

  -- STEP 2: Check if each building can place the train
  for _, builderLocation in pairs(trainBuilder) do
    local machineEntity = Trainassembly:getMachineEntity(builderLocation["surfaceIndex"], builderLocation["position"])
    if machineEntity and machineEntity.valid then
      local machineRecipe = machineEntity.get_recipe()
      if not machineRecipe then
        Traincontroller:checkValidAftherChanges(machineEntity, nil)
        return false
      end
      local buildEntityName = LSlib.utils.string.split(machineRecipe.name, "[")[1]
      local buildEntityName = buildEntityName:sub(1, buildEntityName:len()-6)

      if not game.surfaces[builderLocation["surfaceIndex"]].can_place_entity{
        name             = buildEntityName,
        position         = builderLocation["position"],
        direction        = Trainassembly:getMachineDirection(machineEntity),
        force            = machineEntity.force,
        build_check_type = defines.build_check_type.manual
      } then
        -- If we cannot place it, we can't build a train yet
        return false
      end

    else -- This should never have an invalid machineEntity...
      return false
    end
  end

  return true -- if we can build everywhere, we return true eventualy
end



function Traincontroller.Builder:buildNextTrain(trainBuilderIndex)
  -- We know we can build a train, so we start building it now
  -- We need to check for each builder if it can place a train there
  local trainBuilder = Trainassembly:getTrainBuilder(trainBuilderIndex)
  if not trainBuilder then return false end

  local finishTrainBuild = true -- track if the train is fully build
  for _, builderLocation in pairs(trainBuilder) do
    -- iterate over each building
    local machineEntity = Trainassembly:getMachineEntity(builderLocation["surfaceIndex"], builderLocation["position"])
    if machineEntity and machineEntity.valid then
      -- get the building entity out of the name
      local machineRecipe = machineEntity.get_recipe()
      if not machineRecipe then
        Traincontroller:checkValidAftherChanges(machineEntity, nil)
        return false
      end
      local buildEntityName = LSlib.utils.string.split(machineRecipe.name, "[")[1]
      buildEntityName = buildEntityName:sub(1, buildEntityName:len()-6)

      -- get the maybe already existing entity
      local createdEntity = Trainassembly:getCreatedEntity(builderLocation["surfaceIndex"], builderLocation["position"])
      if createdEntity and (not createdEntity.valid) then
        createdEntity = nil -- if not valid
      end

      if not createdEntity then
        -- there was no entity, or the already existing entity got removed above this code

        -- first we need to check if the recipe has made a result
        local machineOutput = machineEntity.fluidbox[1]
        if machineOutput and machineOutput.amount >= 1 then
          local machineDirection = Trainassembly:getMachineDirection(machineEntity)

          -- the recipe made a result, now we can place it
          createdEntity = game.surfaces[builderLocation["surfaceIndex"]].create_entity{
            name               = buildEntityName,
            position           = builderLocation["position"],
            direction          = machineDirection,
            force              = machineEntity.force,
            snap_to_train_stop = false,
          }
          if createdEntity and (not LSlib.utils.table.areEqual(createdEntity.position, builderLocation["position"])) then
            -- it snapped to a train stop probably, so let us build it in reverse first
            createdEntity.destroy()
            createdEntity = game.surfaces[builderLocation["surfaceIndex"]].create_entity{
              name               = buildEntityName,
              position           = builderLocation["position"],
              direction          = LSlib.utils.directions.oposite(machineDirection),
              force              = machineEntity.force,
              snap_to_train_stop = false,
            }
            -- and afther creating it in reverse, we rotate it back
            if not (createdEntity and createdEntity.rotate()) then
              if createdEntity then
                createdEntity.destroy() -- for some reason it still didn't work
                createdEntity = nil
              end
            end
          end

          if createdEntity then
            -- now the entity is created, start saving this entity
            Trainassembly:setCreatedEntity(builderLocation["surfaceIndex"], builderLocation["position"], createdEntity)

            -- if this is a locomotive, we have to do some more stuff
            local buildEntityType = LSlib.utils.string.split(machineRecipe.name, "[")
            buildEntityType = buildEntityType[#buildEntityType]
            buildEntityType = buildEntityType:sub(1, buildEntityType:len()-1)
            if buildEntityType == "locomotive" then
              -- insert fuel if recipe had fuel
              for _,ingredient in pairs(machineRecipe.ingredients) do
                if ingredient.name == "trainassembly-recipefuel" then
                  createdEntity.get_fuel_inventory().insert{
                    name  = "trainassembly-trainfuel",
                    count = ingredient.amount,
                  }
                end
              end

              -- give it some color
              local createdEntityColor = Trainassembly:getMachineTint(machineEntity)
              createdEntity.color = {
                r = createdEntityColor.r,
                g = createdEntityColor.g,
                b = createdEntityColor.b,
                a = 127/255, -- hardcoded for vanilla trains
              }

            end

            -- now substract one result from the assembler
            machineOutput.amount = machineOutput.amount - 1
            machineEntity.fluidbox[1] = machineOutput.amount > 0 and machineOutput or nil

            -- now that we finised this one, we can raise the event for other mods
            script.raise_event(defines.events.script_raised_built, {
              entity = createdEntity
            })
          else
            -- if the entity could not be created, the build is not finished yet
            finishTrainBuild = false
          end
        else
          -- if the recipe did not create a result yet, the build is not finished yet
          finishTrainBuild = false
        end
        finishTrainBuild = false -- invalid result fluid, should never happen
      end
    end
  end

  return finishTrainBuild
end



function Traincontroller.Builder:depotIsRequestingTrain(controllerEntity)
  local controllerName         = controllerEntity.backer_name
  local controllerSurfaceIndex = controllerEntity.surface.index
  local depotForceName         = Traincontroller:getDepotForceName(controllerEntity.force.name)

  local depotRequestCount = Traindepot:getDepotRequestCount(depotForceName, controllerSurfaceIndex, controllerName)
  local depotTrainCount   = Traindepot:getNumberOfTrainsPathingToDepot(controllerSurfaceIndex, controllerName)

  return depotTrainCount < depotRequestCount
end



function Traincontroller.Builder:assembleNextTrain(trainBuilderIndex, depotName)
  -- The whole train is assembled, so now we can send it away

  -- STEP 1: Get the train that is created (not the individual carriages)
  local train = self:getBuildTrain(trainBuilderIndex)
  if not train then return false end

  -- STEP 2: Set the schedule for this train
  -- STEP 2a:Create the schedule
  local trainSchedule = { -- the train schedule
    -- https://lua-api.factorio.com/latest/Concepts.html#TrainSchedule
    current = 1, -- record the train is traveling too
    records = {
      -- the train schedule recods
      -- https://lua-api.factorio.com/latest/Concepts.html#TrainScheduleRecord

      -- First record: depot stop --
      {
        station         = depotName, -- name of the depot station
        wait_conditions = {
          -- wait conditions at this station
          -- https://lua-api.factorio.com/latest/Concepts.html#WaitCondition

          -- first wait condition
          {
            type         = "circuit",
            compare_type = "and", -- tells how this condition is to be compared with the preceding conditions
            ticks        = nil,   -- number of ticks to wait or of inactivity
            condition    = {
              -- condition when type is "item_count" or "circuit"
              -- https://lua-api.factorio.com/latest/Concepts.html#CircuitCondition
              comparator    = "<",
              first_signal  = nil, -- blank, no condition set
              second_signal = nil, -- if not set, it will compare to constant
              constant      = nil, -- if not set, will default to 0
            },
          }, -- end of first wait condition

        },
      }, -- end of first record

    },
  } -- end of trainSchedule

  -- STEP 2b:Add the schedule to the train
  train.schedule = trainSchedule

  -- STEP 3: Send the train away
  -- STEP 3a:Set it in automatic mode
  train.manual_mode = false

  -- STEP 3b:Check if the train has a path, if it has, it will drive away
  if not train.recalculate_path() then
    return false -- no pathing
  end

  -- STEP 4: Clear the train buildings to start making a new one
  for _, builderLocation in pairs(Trainassembly:getTrainBuilder(trainBuilderIndex)) do
    Trainassembly:setCreatedEntity(builderLocation["surfaceIndex"], builderLocation["position"], nil)
  end

  return true
end


--------------------------------------------------------------------------------
-- Event interface
--------------------------------------------------------------------------------
function Traincontroller.Builder:onTick(event)
  --game.print(game.tick)

  -- Extract the controller that needs to be updated
  local controller = global.TC_data["nextTrainControllerIterate"]
  local surfaceIndex = controller.surfaceIndex
  local position     = controller.position

  -- extract the next controller
  local nextController = util.table.deepcopy(
    global.TC_data["trainControllers"][surfaceIndex][position.y][position.x]["nextController"]
  )

  -- Update the controller
  self:updateController(surfaceIndex, position)

  -- Increment the nextController
  global.TC_data["nextTrainControllerIterate"] = nextController
end



function Traincontroller.Builder:activateOnTick()
  --game.print("on_tick activated")
  script.on_nth_tick(global.TC_data.Builder["onTickDelay"], function(event)
    self:onTick(event)
  end)
  global.TC_data.Builder["onTickActive"] = true
end



function Traincontroller.Builder:deactivateOnTick()
  --game.print("on_tick deactivated")
  script.on_nth_tick(global.TC_data.Builder["onTickDelay"], nil)
  global.TC_data.Builder["onTickActive"] = false
end
