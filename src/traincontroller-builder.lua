require 'util'
require 'lib.util'
require 'lib.table'
require 'lib.directions'

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
      ["idle"]       = 1, -- waiting till previous train clears the train block
      ["building"]   = 2, -- waiting on resources, building each component
      ["connecting"] = 3, -- assembling the train components together and let the train drive off
    },
  }

  return util.table.deepcopy(Builder)
end



--------------------------------------------------------------------------------
-- Behaviour functions
--------------------------------------------------------------------------------
function Traincontroller.Builder:updateController(surfaceIndex, position)
  -- This function will check the update for a single controller
  --game.print("Updating controller @ ["..surfaceIndex..", "..position.x..", "..position.y.."]")
  local controllerData    = global.TC_data["trainControllers"][surfaceIndex][position.y][position.x]
  local controllerStates  = global.TC_data.Builder["builderStates"]
  local controllerStatus  = controllerData["controllerStatus"]
  local trainBuilderIndex = controllerData["trainBuiderIndex"]


  if controllerStatus == controllerStates["idle"] then
    -- controller is waiting till previous train clears the train block
    if self:canBuildNextTrain(trainBuilderIndex) then
      -- if we can build a new train, we move on to the next step
      game.print("Start building a train of length: "..#Trainassembly:getTrainBuilder(trainBuilderIndex))
      controllerStatus = controllerStates["building"]
    end
  end


  if controllerStatus == controllerStates["building"] then
    -- controller is waiting on resources, building each component
    if self:buildNextTrain(trainBuilderIndex) then
      -- if the whole train is build, we can send it away
      game.print("Finished building a train of length: "..#Trainassembly:getTrainBuilder(trainBuilderIndex))
      controllerStatus = controllerStates["connecting"]
    end
  end


  if controllerStatus == controllerStates["connecting"] then
    -- assembling the train components together and let the train drive off
    if  self:assembleNextTrain(trainBuilderIndex) then
      game.print("Leaving train of length: "..#Trainassembly:getTrainBuilder(trainBuilderIndex))
      controllerStatus = controllerStates["idle"]
    end
  end


  -- save changes to the global data
  global.TC_data["trainControllers"][surfaceIndex][position.y][position.x]["controllerStatus"] = controllerStatus
end



function Traincontroller.Builder:canBuildNextTrain(trainBuilderIndex)
  -- We need to check for each builder if it can place a train there
  local trainBuilder = Trainassembly:getTrainBuilder(trainBuilderIndex)
  if not trainBuilder then return false end
  --game.print("checking if it can build a train with length: "..#trainBuilder)

  for _, builderLocation in pairs(trainBuilder) do
    local machineEntity = Trainassembly:getMachineEntity(builderLocation["surfaceIndex"], builderLocation["position"])
    if machineEntity and machineEntity.valid then
      local machineRecipe = machineEntity.get_recipe()
      local buildEntityName = lib.util.stringSplit(machineRecipe.name, "[")[1]
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
      local buildEntityName = lib.util.stringSplit(machineRecipe.name, "[")[1]
      local buildEntityName = buildEntityName:sub(1, buildEntityName:len()-6)

      -- get the maybe already existing entity
      local createdEntity = Trainassembly:getCreatedEntity(builderLocation["surfaceIndex"], builderLocation["position"])
      local machineDirection = Trainassembly:getMachineDirection(machineEntity)
      if createdEntity and createdEntity.valid then
        -- there is already an entity, make sure its still correct, otherwise, update it

        if not lib.directions.orientationTo4WayDirection(createdEntity.orientation) == machineDirection then
          -- it is oriented wrong, let's make sure it has the correct orientation
          createdEntity.rotate() -- only 2 rotations possible, so rotating it will fix it
        end

        -- TODO : check if the entity is the correct entity
      else
        createdEntity = nil -- if not valid
      end

      if not createdEntity then
        -- there was no entity, or the already existing entity got removed above this code

        -- first we need to check if the recipe has made a result
        local machineOutput = machineEntity.fluidbox[1]
        if machineOutput and machineOutput.amount >= 1 then
          -- the recipe made a result, now we can place it
          createdEntity = game.surfaces[builderLocation["surfaceIndex"]].create_entity{
            name             = buildEntityName,
            position         = builderLocation["position"],
            direction        = machineDirection,
            force            = machineEntity.force
          }
          if createdEntity and (not lib.table.areEqual(createdEntity.position, builderLocation["position"])) then
            -- it snapped to a train stop probably, so let us build it in reverse first
            createdEntity.destroy()
            createdEntity = game.surfaces[builderLocation["surfaceIndex"]].create_entity{
              name             = buildEntityName,
              position         = builderLocation["position"],
              direction        = lib.directions.oposite(machineDirection),
              force            = machineEntity.force
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

            -- if this is a locomotive, we have to insert fuel
            local buildEntityType = lib.util.stringSplit(machineRecipe.name, "[")
            buildEntityType = buildEntityType[#buildEntityType]
            buildEntityType = buildEntityType:sub(1, buildEntityType:len()-1)
            if buildEntityType == "locomotive" then
              fuelInventory = createdEntity.get_fuel_inventory().insert{
                name="trainassembly-trainfuel",
                count=1,
              }
            end

            -- now substract one result from the assembler
            machineOutput.amount = machineOutput.amount - 1
            machineEntity.fluidbox[1] = machineOutput
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



function Traincontroller.Builder:assembleNextTrain(trainBuilderIndex)


  
  return false
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

  -- Update the controller
  self:updateController(surfaceIndex, position)

  -- Increment the nextController
  global.TC_data["nextTrainControllerIterate"] = util.table.deepcopy(
    global.TC_data["trainControllers"][surfaceIndex][position.y][position.x]["nextController"]
  )
end



function Traincontroller.Builder:activateOnTick()
  -- only need to activate it if its deactivated
  if not global.TC_data.Builder["onTickActive"] then
    --game.print("on_tick activated")
    script.on_nth_tick(global.TC_data.Builder["onTickDelay"], function(event)
      self:onTick(event)
    end)
    global.TC_data.Builder["onTickActive"] = true
  end
end



function Traincontroller.Builder:deactivateOnTick()
  -- only need to deactivate it if its not active
  if global.TC_data.Builder["onTickActive"] then
    --game.print("on_tick deactivated")
    script.on_nth_tick(global.TC_data.Builder["onTickDelay"], nil)
    global.TC_data.Builder["onTickActive"] = false
  end
end
