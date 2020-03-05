require 'util'
require("__LSlib__/LSlib")

-- Create class
trainAssemblyController = {}
require 'src.trainassembly-controller-builder'
require 'src.trainassembly-controller-gui'

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function trainAssemblyController:onInit()
  -- Init global data; data stored through the whole map
  if not global.TC_data then
    global.TC_data = self:initGlobalData()
  end
  self:createControllerForces()
  self.Builder:onInit()
  self.Gui    :onInit()
end



function trainAssemblyController:onLoad()
  -- Sync global state on multiplayer, make sure event handlers are set correctly
  self.Builder:onLoad()
end



function trainAssemblyController:onSettingChanged(event)
  -- called when a mod setting changed
  self.Builder:onSettingChanged(event)
end



-- Initiation of the global data
function trainAssemblyController:initGlobalData()
  local TC_data = {
    ["version"                   ]       = 1, -- version of the global data
    ["prototypeData"             ] = self:initPrototypeData(), -- data storing info about the prototypes

    ["trainAssemblyControllerForces"     ] = {},  -- keep track of the created forces
    ["trainAssemblyControllerNamesCount" ] = {},  -- keep track of the depos the controllers are using

    ["trainAssemblyControllers"          ] = {},  -- keep track of all controllers
    ["nexttrainAssemblyControllerIterate"] = nil, -- next controller to iterate over
  }

  return util.table.deepcopy(TC_data)
end



-- Initialisation of the prototye data inside the global data
function trainAssemblyController:initPrototypeData()
  return
  {
    ["trainAssemblyControllerName"       ] = "trainAssemblyController",        -- item and entity have same name
    ["trainAssemblyControllerSignalName" ] = "trainAssemblyController-signal", -- hidden signals
    ["trainAssemblyControllerMapviewName"] = "trainAssemblyController-mapview",-- simple entity

    ["trainAssemblyControllerForce"      ] = "-trainAssemblyControllerForce",  -- force for the trainAssemblyControllers
  }
end



-- Create force for trainAssemblyControllers
function trainAssemblyController:createControllerForces()
  local forcesToCreate = {}

   -- get a list for all the forces to create
  for forceName,_ in pairs(game.forces) do
    if forceName ~= "enemy" and forceName ~= "neutral" then
      table.insert(forcesToCreate, forceName)
    end
  end

   -- create all the forces
  for _,forceName in pairs(forcesToCreate) do
    -- create the force and set it friendly
    local friendlyForceName = self:getControllerForceName(forceName)
    if not game.forces[friendlyForceName] then
      game.create_force(friendlyForceName)
          .set_friend(forceName, true)
      --game.forces[forceName].set_friend(friendlyForceName, true)
    end

    -- save the created force in the data structure
    global.TC_data["trainAssemblyControllerForces"][friendlyForceName] = forceName
  end
end



--------------------------------------------------------------------------------
-- Setter functions to alter data into the data structure
--------------------------------------------------------------------------------
function trainAssemblyController:saveNewStructure(controllerEntity, trainBuilderIndex)
  -- With this function we save all the data we want about a trainAssemblyController.
  -- This trainAssemblyController will be used to iterate over all the trainbuilders,
  -- this means they will be added to a linked list, with other words, each
  -- entry knows what controller is before or afther itself.

  -- STEP 1: We can already store the wanted data in the structure
  -- STEP 1a:Make sure we can index it, meaning, check if the table already
  --         excists for the surface, if not, we make one. Afther that we also
  --         have to check if the surface table has a table we can index for
  --         the y-position, if not, we make one.
  local controllerSurface  = controllerEntity.surface
  local controllerPosition = controllerEntity.position
  if not global.TC_data["trainAssemblyControllers"][controllerSurface.index] then
    global.TC_data["trainAssemblyControllers"][controllerSurface.index] = {}
  end
  if not global.TC_data["trainAssemblyControllers"][controllerSurface.index][controllerPosition.y] then
    global.TC_data["trainAssemblyControllers"][controllerSurface.index][controllerPosition.y] = {}
  end

  -- STEP 1b:Now we know we can index (without crashing) to the position as:
  --         dataStructure[surfaceIndex][positionY][positionX]
  --         Now we can store our wanted data at this position
  global.TC_data["trainAssemblyControllers"][controllerSurface.index][controllerPosition.y][controllerPosition.x] =
  {
    ["entity"]           = controllerEntity, -- the controller entity
    ["entity-hidden"]    = {}, -- the hidden entities

    ["trainBuilderIndex"] = trainBuilderIndex, -- the trainbuilder it controls
    ["controllerStatus"] = global.TC_data.Builder["builderStates"]["initialState"], -- status

    -- list data
    ["prevController"]   = nil, -- the previous controller
    ["nextController"]   = nil, -- the next controller
  }

  -- STEP 2: We need to add this controller to the chain of the linked list
  local thisController = {
    ["surfaceIndex"] = controllerSurface.index,
    ["position"]     = controllerPosition,
  }

  if not global.TC_data["nexttrainAssemblyControllerIterate"] then
    -- STEP 2a: When it is the first one, it is easy to add, since its the first
    global.TC_data["nexttrainAssemblyControllerIterate"] = thisController
    global.TC_data["trainAssemblyControllers"][thisController["surfaceIndex"]][thisController["position"].y][thisController["position"].x]["prevController"] = util.table.deepcopy(thisController)
    global.TC_data["trainAssemblyControllers"][thisController["surfaceIndex"]][thisController["position"].y][thisController["position"].x]["nextController"] = util.table.deepcopy(thisController)

    -- STEP 2b: start on_tick events becose we need to start iterating
    self.Builder:activateOnTick()
  else
    -- when we've added it to the list, we know there is at least one in front
    -- of us. This one has a prev set. We add it inbetween.

    -- STEP 2a: extract the previous and next controller
    local nextController = global.TC_data["nexttrainAssemblyControllerIterate"]
    local prevController = global.TC_data["trainAssemblyControllers"][nextController["surfaceIndex"]][nextController["position"].y][nextController["position"].x]["prevController"]

    -- STEP 2b: adapt the previous controller
    global.TC_data["trainAssemblyControllers"][prevController["surfaceIndex"]][prevController["position"].y][prevController["position"].x]["nextController"] = util.table.deepcopy(thisController)
    global.TC_data["trainAssemblyControllers"][thisController["surfaceIndex"]][thisController["position"].y][thisController["position"].x]["prevController"] = util.table.deepcopy(prevController)

    -- STEP 2c: adapt the next controller
    global.TC_data["trainAssemblyControllers"][nextController["surfaceIndex"]][nextController["position"].y][nextController["position"].x]["prevController"] = util.table.deepcopy(thisController)
    global.TC_data["trainAssemblyControllers"][thisController["surfaceIndex"]][thisController["position"].y][thisController["position"].x]["nextController"] = util.table.deepcopy(nextController)

    -- STEP 2d: make sure the next iteration doesn't skip this new controller
    if LSlib.utils.table.areEqual(global.TC_data["nexttrainAssemblyControllerIterate"], nextController) then
      global.TC_data["nexttrainAssemblyControllerIterate"] = util.table.deepcopy(thisController)
    end
  end

  -- STEP 3: Configure the controller
  -- STEP 3a:Create hidden entities (2 rail signals)
  local hiddenEntities = global.TC_data["trainAssemblyControllers"][controllerSurface.index][controllerPosition.y][controllerPosition.x]["entity-hidden"]
  for hiddenEntityIndex,hiddenEntityData in pairs(self:getHiddenEntityData(controllerPosition, controllerEntity.direction)) do
    hiddenEntities[hiddenEntityIndex] = controllerSurface.create_entity{
      name      = hiddenEntityData.name,
      position  = hiddenEntityData.position,
      direction = hiddenEntityData.direction,
      force     = controllerEntity.force
    }
  end

  -- STEP 3b:The controller needs to be on another (friendly) force. This way
  --         the controller wont show up on the train menu.
  local controllerForceName = self:getControllerForceName(controllerEntity.force.name)
  controllerEntity.force = controllerForceName

  -- STEP 3c:The controller needs to be disabled. This way the trains won't path
  --         to this stop. To get this behaviour, we connect it to the logistics
  --         network and make sure it has a disabled condition
  self:setTrainstopControlBehaviour(controllerEntity)

  --game.print(serpent.block(global.TC_data["trainAssemblyControllers"]))

  -- STEP 3c:Keep track how many controllers are connected to a depot
  if not global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName] then
    global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName] = {}
  end
  if not global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurface.index] then
    global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurface.index] = {}
  end

  local stationName = controllerEntity.backer_name
  local stationAmount = global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurface.index][stationName] or 0
  global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurface.index][stationName] = stationAmount + 1
end



function trainAssemblyController:deleteController(controllerEntity)
  -- STEP 1a: make sure we can index the table
  --local controllerSurface = controllerEntity.surface
  local controllerSurfaceIndex = controllerEntity.surface.index
  local controllerPosition = controllerEntity.position
  if not global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex] then
    return
  end
  if not global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex][controllerPosition.y] then
    return
  end
  if not global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex][controllerPosition.y][controllerPosition.x] then
    return
  end

  -- STEP 1b: destroy the hidden entities
  for _, entity in pairs(global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex][controllerPosition.y][controllerPosition.x]["entity-hidden"] or {}) do
    entity.destroy()
  end

  -- STEP 2: remove this controller from the list
  local thisController = {
    ["surfaceIndex"] = controllerSurfaceIndex,
    ["position"]     = controllerPosition,
  }

  -- STEP 2a: extract the previous and next controller
  local prevController = global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex][controllerPosition.y][controllerPosition.x]["prevController"]
  local nextController = global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex][controllerPosition.y][controllerPosition.x]["nextController"]

  -- STEP 2b: adapt the prevController
  global.TC_data["trainAssemblyControllers"][prevController["surfaceIndex"]][prevController["position"].y][prevController["position"].x]["nextController"] = util.table.deepcopy(nextController)

  -- STEP 2c: adapt the next controller
  global.TC_data["trainAssemblyControllers"][nextController["surfaceIndex"]][nextController["position"].y][nextController["position"].x]["prevController"] = util.table.deepcopy(prevController)

  -- STEP 2d: make sure the next iteration does skip this old controller
  if LSlib.utils.table.areEqual(global.TC_data["nexttrainAssemblyControllerIterate"], thisController) then
    -- Make sure the next controller isn't this controller, then there are no controllers.
    if LSlib.utils.table.areEqual(thisController, nextController) then
      global.TC_data["nexttrainAssemblyControllerIterate"] = nil
      -- this is the last one, no need to keep iterating on_tick
      self.Builder:deactivateOnTick()
    else
      global.TC_data["nexttrainAssemblyControllerIterate"] = util.table.deepcopy(nextController)
    end
  end

  -- STEP 2e: Delete this controller
  global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex][controllerPosition.y][controllerPosition.x] = nil

  if LSlib.utils.table.isEmpty(global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex][controllerPosition.y]) then
    global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex][controllerPosition.y] = nil
  end
  if LSlib.utils.table.isEmpty(global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex]) then
    global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex] = nil
  end
  --game.print(serpent.block(global.TC_data["trainAssemblyControllers"]))


  -- STEP 3: remove this controller from the depot list
  local controllerForceName = controllerEntity.force.name

  local stationName = controllerEntity.backer_name
  local stationAmount = global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex][stationName]

  if stationAmount then
    if stationAmount > 1 then
      global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex][stationName] = stationAmount - 1
    else
      global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex][stationName] = nil

      if LSlib.utils.table.isEmpty(global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex]) then
        global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex] = nil

        if LSlib.utils.table.isEmpty(global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName]) then
          global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName] = nil
        end
      end
    end
  end

  -- Update the UI
  controllerEntity.health = 0 -- set health to 0, otherwise it's not working
  self.Gui:updateOpenedGuis(controllerEntity)
end



function trainAssemblyController:setTrainstopControlBehaviour(trainStopEntity)
  local stationBehaviour = trainStopEntity.get_or_create_control_behavior()
  -- https://lua-api.factorio.com/latest/LuaControlBehavior.html#LuaTrainStopControlBehavior
  stationBehaviour.send_to_train               = false -- sending signals to the train
  stationBehaviour.read_from_train             = false -- reading train content from the train
  stationBehaviour.read_stopped_train          = false -- read train id from the train
  stationBehaviour.enable_disable              = false -- open/close train station with circuit network
  stationBehaviour.connect_to_logistic_network = true  -- open/close train station with logistic network

  -- enable/disable condition for circuit network
  stationBehaviour.circuit_condition = {
    -- https://lua-api.factorio.com/latest/LuaControlBehavior.html#LuaGenericOnOffControlBehavior.circuit_condition
    condition = {
      comparator    = "<",
      first_signal  = nil, -- blank, no condition set
      second_signal = nil, -- if not set, it will compare to constant
      constant      = nil, -- if not set, will default to 0
    }
  }

  -- make sure it is disconnected from the logistics network
  stationBehaviour.logistic_condition = {
    -- https://lua-api.factorio.com/latest/LuaControlBehavior.html#LuaGenericOnOffControlBehavior.logistic_condition
    condition = {
      comparator    = "<",
      first_signal  = nil, -- blank, no condition set
      second_signal = nil, -- if not set, it will compare to constant
      constant      = nil, -- if not set, will default to 0
    }
  }
end



function trainAssemblyController:setDefaultMachineTints(builderIndex)
  -- set the default machine tints depending on the recipe
  for _, builderLocation in pairs(Trainassembly:getTrainBuilder(builderIndex)) do
    local builderEntity = Trainassembly:getMachineEntity(builderLocation["surfaceIndex"], builderLocation["position"])
    if builderEntity and builderEntity.valid then
      local builderRecipe = builderEntity.get_recipe()
      if builderRecipe then
        local buildEntityName = LSlib.utils.string.split(builderRecipe.name, "[")[1]
        buildEntityName = buildEntityName:sub(1, buildEntityName:len()-6)

        Trainassembly:setMachineTint(builderEntity, Trainassembly:getTrainTint(buildEntityName))
      end
    end
  end
end



function trainAssemblyController:deleteBuildTrain(builderIndex)
  -- delete the whole created train from a builder
  for _, builderLocation in pairs(Trainassembly:getTrainBuilder(builderIndex)) do
    Trainassembly:deleteCreatedTrainEntity(builderLocation["surfaceIndex"], builderLocation["position"])
  end
end



function trainAssemblyController:renameBuilding(controllerEntity, oldName)
  local stationName = controllerEntity.backer_name
  if oldName ~= stationName then -- checking to make sure it is actualy changed

    local controllerForceName = controllerEntity.force.name
    local controllerSurfaceIndex = controllerEntity.surface.index

    -- remove the old one
    local stationAmount = global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex][oldName]
    if stationAmount then
      if stationAmount > 1 then
        global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex][oldName] = stationAmount - 1
      else
        global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex][oldName] = nil
        -- no need to delete empty tables, since we'll be adding one to it again
      end
    end

    -- add the new one
    stationAmount = global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex][stationName] or 0
    global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex][stationName] = stationAmount + 1

    -- update the ui
    Traindepot.Gui:updateOpenedGuis(oldName)
    self.Gui:updateOpenedGuis(controllerEntity)
  end
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function trainAssemblyController:getControllerItemName()
  return global.TC_data.prototypeData.trainAssemblyControllerName
end



function trainAssemblyController:getControllerEntityName()
  return global.TC_data.prototypeData.trainAssemblyControllerName
end



function trainAssemblyController:getControllerMapviewEntityName()
  return global.TC_data.prototypeData.trainAssemblyControllerMapviewName
end



function trainAssemblyController:getControllerSignalEntityName()
  return global.TC_data.prototypeData.trainAssemblyControllerSignalName
end



function trainAssemblyController:getControllerForceName(depotForceName)
  return depotForceName .. global.TC_data.prototypeData.trainAssemblyControllerForce
end



function trainAssemblyController:getDepotForceName(controllerForceName)
  return controllerForceName:sub(1, - (global.TC_data.prototypeData.trainAssemblyControllerForce:len() + 1))
end



function trainAssemblyController:gettrainAssemblyController(trainBuilderIndex)
  for surfaceIndex,_ in pairs(global.TC_data["trainAssemblyControllers"]) do
    for positionY,_ in pairs(global.TC_data["trainAssemblyControllers"][surfaceIndex]) do
      for positionX,_ in pairs(global.TC_data["trainAssemblyControllers"][surfaceIndex][positionY]) do
        local trainAssemblyController = global.TC_data["trainAssemblyControllers"][surfaceIndex][positionY][positionX]

        if trainAssemblyController["trainBuilderIndex"] == trainBuilderIndex then
          return trainAssemblyController["entity"]
        end

      end
    end
  end

  return nil
end



function trainAssemblyController:getControllerEntity(controllerSurfaceIndex, controllerPosition)
  if global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex]                                            and
     global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex][controllerPosition.y]                      and
     global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex][controllerPosition.y][controllerPosition.x] then
    return global.TC_data["trainAssemblyControllers"][controllerSurfaceIndex][controllerPosition.y][controllerPosition.x]["entity"]
  else
    return nil
  end
end



function trainAssemblyController:getAlltrainAssemblyControllers(surfaceIndex, controllerName)
  if not global.TC_data["trainAssemblyControllers"][surfaceIndex] then return {} end

  local entities = {}
  local entityIndex = 1
  for posY,posYdata in pairs(global.TC_data["trainAssemblyControllers"][surfaceIndex]) do
    for posX,trainAssemblyController in pairs(posYdata) do
      local entity = trainAssemblyController["entity"]
      if entity.backer_name == controllerName then
        entities[entityIndex] = entity
        entityIndex = entityIndex + 1
      end
    end
  end

  return entities
end



function trainAssemblyController:getTrainBuilderIndex(trainAssemblyController)
  local surfaceIndex = trainAssemblyController.surface.index
  local position     = trainAssemblyController.position

  -- STEP 1: make sure we can index the datastructure
  if not global.TC_data["trainAssemblyControllers"][surfaceIndex] then
    return nil
  end
  if not global.TC_data["trainAssemblyControllers"][surfaceIndex][position.y] then
    return nil
  end
  if not global.TC_data["trainAssemblyControllers"][surfaceIndex][position.y][position.x] then
    return nil
  end

  -- STEP 2: return the tainBuilderIndex
  return global.TC_data["trainAssemblyControllers"][surfaceIndex][position.y][position.x]["trainBuilderIndex"]
end



function trainAssemblyController:hasTrainBuilderEntities(controllerForceName, controllerSurfaceIndex)
  -- returns true if at least one depot has been build on the force on that surface
  if global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName]                         and
     global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex] then
    return not LSlib.utils.table.isEmpty(global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex])
  end
  return false
end



function trainAssemblyController:getTrainBuilderNames(controllerForceName, controllerSurfaceIndex)
  if self:hasTrainBuilderEntities(controllerForceName, controllerSurfaceIndex) then
    return global.TC_data["trainAssemblyControllerNamesCount"][controllerForceName][controllerSurfaceIndex]
  else
    return {}
  end
end



function trainAssemblyController:getTrainBuilderCount(controllerForceName, controllerSurfaceIndex, controllerName)
  return self:getTrainBuilderNames(controllerForceName, controllerSurfaceIndex)[controllerName] or 0
end



function trainAssemblyController:getTrainHiddenEntity(controllerEntity, hiddenEntityIndex)
  return global.TC_data["trainAssemblyControllers"][controllerEntity.surface.index][controllerEntity.position.y][controllerEntity.position.x]["entity-hidden"][hiddenEntityIndex]
end



function trainAssemblyController:getHiddenEntityData(position, direction)
  -- create a list for all hidden entities that needs to be created

  -- STEP 1: Get the orientation offset depending on the orientation
  local signalOffsetX = 0
  local signalOffsetY = 0
  local mapviewOffsetX = 0
  local mapviewOffsetY = 0

  if direction == defines.direction.north then
    signalOffsetX = -1
    --signalOffsetY = 0
    --mapviewOffsetX = 0
    --mapviewOffsetY = 0
  elseif direction == defines.direction.east then
    --signalOffsetX = 0
    signalOffsetY = -1
    --mapviewOffsetX = 0
    --mapviewOffsetY = 0
  elseif direction == defines.direction.south then
    signalOffsetX = 1
    --signalOffsetY = 0
    --mapviewOffsetX = 0
    --mapviewOffsetY = 0
  elseif direction == defines.direction.west then
    --signalOffsetX = 0
    signalOffsetY = 1
    --mapviewOffsetX = 0
    --mapviewOffsetY = 0
  end

  -- STEP 2: Return the list with hidden entities
  return {
    [1] = { -- signal on the same side of the track
      name     = self:getControllerSignalEntityName(),
      position = {
        x = position.x + signalOffsetX * 1,
        y = position.y + signalOffsetY * 1,
      },
      direction = LSlib.utils.directions.oposite(direction),
    },
    [2] = { -- signal on the other side of the track
      name     = self:getControllerSignalEntityName(),
      position = {
        x = position.x + signalOffsetX * 3,
        y = position.y + signalOffsetY * 3,
      },
      direction = direction,
    },
    [3] = { -- simple entity to show on map
      name      = self:getControllerMapviewEntityName(),
      position = position, --[[{
        x = position.x + mapviewOffsetX,
        y = position.y + mapviewOffsetY,
      },]]
      direction = direction,
    }
  }
end



function trainAssemblyController:checkValidAftherChanges(alteredEntity, playerIndex)
  -- A valid trainbuilder got altered. This happens when a building gets rotated
  -- or when a recipe got changed. We have to check if all recipes are set and
  -- if the builder has a validly placed locomotive still.

  if alteredEntity and alteredEntity.valid and alteredEntity.name == Trainassembly:getMachineEntityName() then
    local trainBuilderIndex = Trainassembly:getTrainBuilderIndex(alteredEntity)
    local trainAssemblyController = self:gettrainAssemblyController(trainBuilderIndex)
    if trainAssemblyController then

      local notValid = function(localisedMessage)
        -- Try return the item to the player (or drop it)
        if playerIndex then -- return if possible
          local player = game.players[playerIndex]
          player.print(localisedMessage)
          player.insert{
            name = self:getControllerItemName(),
            count = 1,
          }
        else -- drop it otherwise
          local droppedItem = trainAssemblyController.surface.create_entity{
            name = "item-on-ground",
            stack = {
              name = self:getControllerItemName(),
              count = 1,
            },
            position = trainAssemblyController.position,
            force = global.TC_data["trainAssemblyControllerForces"][trainAssemblyController.force.name] or trainAssemblyController.force,
            fast_replace = true,
            spill = false, -- delete excess items (only if fast_replace = true)
          }
          droppedItem.to_be_looted = true
          droppedItem.order_deconstruction(trainAssemblyController.force)
        end

        -- remove the created train
        self:deleteBuildTrain(trainBuilderIndex)

        -- Delete it from the data structure
        self:deleteController(trainAssemblyController)

        -- Destroy the placed item
        trainAssemblyController.destroy{raise_destroy = true}
        return false
      end

      -- We know it is already validly placed, so we can check the trainbuilder
      -- and only have to check if it still has a locomotive facing the correct
      -- direction
      local hasValidLocomotive = false
      local hasAllRecipesSet = true
      for _, builderLocation in pairs(Trainassembly:getTrainBuilder(trainBuilderIndex)) do
        local machineEntity = Trainassembly:getMachineEntity(builderLocation["surfaceIndex"], builderLocation["position"])
        if machineEntity and machineEntity.valid and machineEntity.direction == trainAssemblyController.direction then

          -- Step 1: Check if the recipe is set for each building, if not, this
          --         controller has become invalid, we don't have to look further
          local machineRecipe = machineEntity.get_recipe()
          if not machineRecipe then
            return notValid{"trainAssemblyController-message.noBuilderRecipeFound", {"item-name.trainassembly"}}
          end

          -- Step 2: If this controller doesn't have a valid locomotive yet, we
          --         still have to check if this one might be a valid locomotive
          if not hasValidLocomotive then
            local builderType = LSlib.utils.string.split(machineRecipe.name, "[")
            builderType = builderType[#builderType]
            builderType = builderType:sub(1, builderType:len()-1)
            if builderType == "locomotive" then
              hasValidLocomotive = true
            end
          end

        end
      end

      if not hasValidLocomotive then
        return notValid{"trainAssemblyController-message.noValidLocomotiveFound",
          --[[1]]{"item-name.trainassembly"},
          --[[2]]"__ENTITY__locomotive__",
          --[[3]]{"item-name.trainAssemblyController", {"item-name.trainassembly"}},
        }
      end

      self.Gui:updateOpenedGuis(trainAssemblyController)
      return true
    end

    return false -- return false if no trainAssemblyController found
  end

  return true -- return true if alteredEntity is not valid
end


function trainAssemblyController:checkValidPlacement(createdEntity, playerIndex)
  -- Checks the correct placement of the trainAssemblyController, if not validly placed,
  -- it will inform the player with the corresponding message and return the
  -- trainAssemblyController to the player. If no player is found, it will drop the
  -- trainAssemblyController on the ground where the trainAssemblyController was placed.

  -- this is the actual force of the player, not the friendly force
  local createdEntityForceName = global.TC_data["trainAssemblyControllerForces"][createdEntity.force.name] or createdEntity.force.name
  local entityPosition = createdEntity.position

  local notValid = function(localisedMessage)
    -- Try return the item to the player (or drop it)
    if playerIndex then -- return if possible
      local player = game.players[playerIndex]
      --player.print(localisedMessage)
      player.create_local_flying_text{
        text = localisedMessage,
        position = entityPosition,
      }
      player.insert{
        name = self:getControllerItemName(),
        count = 1,
      }
    else -- drop it otherwise
      local droppedItem = createdEntity.surface.create_entity{
        name = "item-on-ground",
        stack = {
          name = self:getControllerItemName(),
          count = 1,
        },
        position = createdEntity.position,
        force = createdEntityForceName,
        fast_replace = true,
        spill = false, -- delete excess items (only if fast_replace = true)
      }
      droppedItem.to_be_looted = true
      droppedItem.order_deconstruction(createdEntity.force)
    end

    -- Destroy the placed item
    createdEntity.destroy()
    return false, -1
  end

  -- STEP 1: Check if at least one train depot has been placed, if not, the
  --         trainbuilder can't let trains drive off.
  if not Traindepot:hasDepotEntities(createdEntityForceName, createdEntity.surface.index) then
    return notValid{"trainAssemblyController-message.noTraindepotFound",
      --[[1]]{"item-name.trainAssemblyController", {"item-name.trainassembly"}},
      --[[2]]{"item-name.traindepot"},
    }
  end

  -- STEP 2: Look for a trainassembler, if there is no trainassembler found,
  --         the controller is placed wrong
  local entityDirection = createdEntity.direction -- direction to look for a trainbuilder
  local entitySearchDirection = {x=0,y=0}

  if entityDirection == defines.direction.west then
    entitySearchDirection.x = 1
  elseif entityDirection == defines.direction.east then
    entitySearchDirection.x = -1
  elseif entityDirection == defines.direction.north then
    entitySearchDirection.y = 1
  elseif entityDirection == defines.direction.south then
    entitySearchDirection.y = -1
  end
  local entitySurface = createdEntity.surface
  local entitySurfaceIndex = entitySurface.index

  local builderEntity = entitySurface.find_entities_filtered{
    name     = Trainassembly:getMachineEntityName(),
    --type     = createdEntity.type,
    force    = createdEntityForceName,
    area     = {
      { entityPosition.x + 3.5*entitySearchDirection.x - 1.5*entitySearchDirection.y , entityPosition.y + 3.5*entitySearchDirection.y + 1.5*entitySearchDirection.x },
      { entityPosition.x + 5.5*entitySearchDirection.x - 2.5*entitySearchDirection.y , entityPosition.y + 5.5*entitySearchDirection.y + 2.5*entitySearchDirection.x },
    },
    limit    = 1,
  }[1]

  if not (builderEntity and builderEntity.valid) then
    return notValid{"trainAssemblyController-message.noTrainbuilderFound", {"item-name.trainassembly"}}
  end

  -- STEP 3: Find the trainbuilder that this trainassembler is part of
  local builderIndex = Trainassembly:getTrainBuilderIndex(builderEntity)
  -- STEP 3a: If there is no trainbuilder found, the controller is placed wrong.
  if not builderIndex then
    return notValid{"trainAssemblyController-message.invalidTrainbuilderFound", {"item-name.trainassembly"}}
  end
  -- STEP 3b: If there is one, we need to make sure it isn't controlled yet.
  if self:gettrainAssemblyController(builderIndex) then
    return notValid{"trainAssemblyController-message.isAlreadyControlled",
      --[[1]]{"item-name.trainassembly"},
      --[[2]]{"item-name.trainAssemblyController", {"item-name.trainassembly"}},
    }
  end

  -- STEP 4: Make sure the trainbuilder has all recipes set, and at least
  --         one of the recipes must be a locomotive that is facing it the
  --         direction the train is supposed to leave.
  local hasValidLocomotive = false
  for _, builderLocation in pairs(Trainassembly:getTrainBuilder(builderIndex)) do
    local machineEntity = Trainassembly:getMachineEntity(builderLocation["surfaceIndex"], builderLocation["position"])
    if machineEntity and machineEntity.valid then
      -- check the recipe of each machineEntity
      local machineRecipe = machineEntity.get_recipe()
      if not machineRecipe then
        return notValid{"trainAssemblyController-message.noBuilderRecipeFound", {"item-name.trainassembly"}}
      end

      if (not hasValidLocomotive) and (machineEntity.direction == entityDirection) then
        -- check the direction of the locomotive
        local builderType = LSlib.utils.string.split(machineRecipe.name, "[")
        builderType = builderType[#builderType]
        builderType = builderType:sub(1, builderType:len()-1)
        if builderType == "locomotive" then
          hasValidLocomotive = true
        end
      end
    else
      return notValid("ERROR: Invalid building! Report this please.")
    end
  end

  if not hasValidLocomotive then
    return notValid{"trainAssemblyController-message.noValidLocomotiveFound",
      --[[1]]{"item-name.trainassembly"},
      --[[2]]"__ENTITY__locomotive__",
      --[[3]]{"item-name.trainAssemblyController", {"item-name.trainassembly"}},
    }
  end

  -- STEP 5: If all previous checks succeeded, it means it is validly placed.
  return true, builderIndex
end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player builds a new entity
function trainAssemblyController:onBuildEntity(createdEntity, playerIndex)
  -- The player created a new entity, the player can only place the controller
  -- If he configured the trainbuilder correctly. Otherwise we delete it again
  -- and inform the player what went wrong.
  --
  -- Player experience: The player activated the trainbuilder if its valid.
  if createdEntity.valid and createdEntity.name == self:getControllerEntityName() then
    -- it is the correct entity, now check if its correctly placed
    local validPlacement, trainBuilderIndex = self:checkValidPlacement(createdEntity, playerIndex)
    if validPlacement then -- It is valid, now we have to add the entity to the list
      self:saveNewStructure(createdEntity, trainBuilderIndex)
      self:setDefaultMachineTints(trainBuilderIndex)

      -- after structure is saved, we rename it, this will trigger trainAssemblyController:onRenameEntity as well
      createdEntity.backer_name = "Unused Trainbuilder"
    end
  end
end



-- When a player/robot removes the building
function trainAssemblyController:onRemoveEntity(removedEntity)
  -- In some way the building got removed. This results in that the builder is
  -- removed. This also means we have to delete the train that was in this spot.
  --
  -- Player experience: Everything with the trainAssembler gets removed
  if removedEntity.name == self:getControllerEntityName() then
    -- STEP 1: remove the created train
    local trainBuilderIndex = self:getTrainBuilderIndex(removedEntity)
    if trainBuilderIndex then
      self:deleteBuildTrain(trainBuilderIndex)
    end

    -- STEP 2: Update the data structure
    self:deleteController(removedEntity)
  end
end



-- When a player rotates an entity
function trainAssemblyController:onPlayerRotatedEntity(rotatedEntity, playerIndex)
  -- The player rotated the machine entity, we need to make sure the controller
  -- is still valid.
  if rotatedEntity.name == Trainassembly:getMachineEntityName() then
    self:checkValidAftherChanges(rotatedEntity, playerIndex)
  end
end



-- When a player copy pastes a recipe
function trainAssemblyController:onPlayerChangedSettings(pastedEntity, playerIndex)
  -- The player pasted a recipe in a machine entity, we need to make sure the
  -- controller is still valid.
  if pastedEntity and pastedEntity.valid then
    if pastedEntity.name == Trainassembly:getMachineEntityName() then
      self:checkValidAftherChanges(pastedEntity, playerIndex)

    elseif pastedEntity.name == self:getControllerEntityName() then
      self:setTrainstopControlBehaviour(pastedEntity)

    end
  end
end



-- When a player/script renames an entity
function trainAssemblyController:onRenameEntity(renamedEntity, oldName)
  if renamedEntity.name == self:getControllerEntityName() and self:getControllerEntity(renamedEntity.surface.index, renamedEntity.position) then
    self:renameBuilding(renamedEntity, oldName)
  end
end



-- when a trainbuilder gets altered (buildings added/deleted buildings)
function trainAssemblyController:onTrainbuilderAltered(trainBuilderIndex)
  -- if there is a trainAssemblyController, we drop it on the floor
  local trainAssemblyController = self:gettrainAssemblyController(trainBuilderIndex)
  if trainAssemblyController then
    -- remove the created train
    self:deleteBuildTrain(trainBuilderIndex)

    -- delete from structure
    self:deleteController(trainAssemblyController)

    -- drop the controller on the ground
    local droppedItem = trainAssemblyController.surface.create_entity{
      name = "item-on-ground",
      stack = {
        name = self:getControllerItemName(),
        count = 1,
      },
      position = trainAssemblyController.position,
      force = global.TC_data["trainAssemblyControllerForces"][trainAssemblyController.force.name] or trainAssemblyController.force,
      fast_replace = true,
      spill = false, -- delete excess items (only if fast_replace = true)
    }
    droppedItem.to_be_looted = true
    droppedItem.order_deconstruction(trainAssemblyController.force)
    trainAssemblyController.destroy{raise_destroy = true}
  end
end
