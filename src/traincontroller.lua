require 'util'
require 'lib.util'
require 'lib.table'

-- Create class
Traincontroller = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Traincontroller:onInit()
  -- Init global data; data stored through the whole map
  if not global.TC_data then
    global.TC_data = self:initGlobalData()
  end
end



-- Initiation of the global data
function Traincontroller:initGlobalData()
  local TC_data = {
    ["version"] = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes

    ["trainControllers"] = {},       -- keep track of all controllers
    ["nextTrainControllerIterate"] = nil, -- next controller to iterate over
  }

  return util.table.deepcopy(TC_data)
end



-- Initialisation of the prototye data inside the global data
function Traincontroller:initPrototypeData()
  return
  {
    ["trainControllerName"] = "traincontroller", -- item and entity have same name
  }
end



--------------------------------------------------------------------------------
-- Setter functions to alter data into the data structure
--------------------------------------------------------------------------------
function Traincontroller:saveNewStructure(controllerEntity, trainBuiderIndex)
  -- With this function we save all the data we want about a traincontroller.
  -- This traincontroller will be used to iterate over all the trainbuilders,
  -- this means they will be added to a linked list, with other words, each
  -- entry knows what controller is before or afther itself.

  -- STEP 1: We can already store the wanted data in the structure
  -- STEP 1a:Make sure we can index it, meaning, check if the table already
  --         excists for the surface, if not, we make one. Afther that we also
  --         have to check if the surface table has a table we can index for
  --         the y-position, if not, we make one.
  local controllerSurface  = controllerEntity.surface
  local controllerPosition = controllerEntity.position
  if not global.TC_data["trainControllers"][controllerSurface.index] then
    global.TC_data["trainControllers"][controllerSurface.index] = {}
  end
  if not global.TC_data["trainControllers"][controllerSurface.index][controllerPosition.y] then
    global.TC_data["trainControllers"][controllerSurface.index][controllerPosition.y] = {}
  end

  -- STEP 1b:Now we know we can index (without crashing) to the position as:
  --         dataStructure[surfaceIndex][positionY][positionX]
  --         Now we can store our wanted data at this position
  global.TC_data["trainControllers"][controllerSurface.index][controllerPosition.y][controllerPosition.x] =
  {
    ["entity"]           = controllerEntity, -- the controller entity
    ["trainBuiderIndex"] = trainBuiderIndex, -- the trainbuilder it controls

    -- list data
    ["prevController"]   = nil, -- the previous controller
    ["nextController"]   = nil, -- the next controller
  }

  -- STEP 2: We need to add this controller to the chain of the linked list
  local thisController = {
    ["surfaceIndex"] = controllerSurface.index,
    ["position"]     = controllerPosition,
  }

  if not global.TC_data["nextTrainControllerIterate"] then
    -- STEP 2a: When it is the first one, it is easy to add, since its the first
    global.TC_data["nextTrainControllerIterate"] = thisController
    global.TC_data["trainControllers"][thisController["surfaceIndex"]][thisController["position"].y][thisController["position"].x]["prevController"] = util.table.deepcopy(thisController)
    global.TC_data["trainControllers"][thisController["surfaceIndex"]][thisController["position"].y][thisController["position"].x]["nextController"] = util.table.deepcopy(thisController)

    -- STEP 2b: start on_tick events becose we need to start iterating
    -- TODO
  else
    -- when we've added it to the list, we know there is at least one in front
    -- of us. This one has a prev set. We add it inbetween.

    -- STEP 2a: extract the previous and next controller
    local nextController = global.TC_data["nextTrainControllerIterate"]
    local prevController = global.TC_data["trainControllers"][nextController["surfaceIndex"]][nextController["position"].y][nextController["position"].x]["prevController"]

    -- STEP 2b: adapt the previous controller
    global.TC_data["trainControllers"][prevController["surfaceIndex"]][prevController["position"].y][prevController["position"].x]["nextController"] = util.table.deepcopy(thisController)
    global.TC_data["trainControllers"][thisController["surfaceIndex"]][thisController["position"].y][thisController["position"].x]["prevController"] = util.table.deepcopy(prevController)

    -- STEP 2c: adapt the next controller
    global.TC_data["trainControllers"][nextController["surfaceIndex"]][nextController["position"].y][nextController["position"].x]["prevController"] = util.table.deepcopy(thisController)
    global.TC_data["trainControllers"][thisController["surfaceIndex"]][thisController["position"].y][thisController["position"].x]["nextController"] = util.table.deepcopy(nextController)

    -- STEP 2d: make sure the next iteration doesn't skip this new controller
    if lib.table.areEqual(global.TC_data["nextTrainControllerIterate"], nextController) then
      global.TC_data["nextTrainControllerIterate"] = util.table.deepcopy(thisController)
    end
  end

  --game.print(serpent.block(global.TC_data["trainControllers"]))
end



function Traincontroller:deleteController(controllerEntity)
  -- STEP 1: make sure we can index the table
  local controllerSurface  = controllerEntity.surface
  local controllerPosition = controllerEntity.position
  if not global.TC_data["trainControllers"][controllerSurface.index] then
    return
  end
  if not global.TC_data["trainControllers"][controllerSurface.index][controllerPosition.y] then
    return
  end

  -- STEP 2: remove this controller from the list
  local thisController = {
    ["surfaceIndex"] = controllerSurface.index,
    ["position"]     = controllerPosition,
  }

  -- STEP 2a: extract the previous and next controller
  local prevController = global.TC_data["trainControllers"][controllerSurface.index][controllerPosition.y][controllerPosition.x]["prevController"]
  local nextController = global.TC_data["trainControllers"][controllerSurface.index][controllerPosition.y][controllerPosition.x]["nextController"]

  -- STEP 2b: adapt the prevController
  global.TC_data["trainControllers"][prevController["surfaceIndex"]][prevController["position"].y][prevController["position"].x]["nextController"] = util.table.deepcopy(nextController)

  -- STEP 2c: adapt the next controller
  global.TC_data["trainControllers"][nextController["surfaceIndex"]][nextController["position"].y][nextController["position"].x]["prevController"] = util.table.deepcopy(prevController)

  -- STEP 2d: make sure the next iteration does skip this old controller
  if lib.table.areEqual(global.TC_data["nextTrainControllerIterate"], thisController) then
    -- Make sure the next controller isn't this controller, then there are no controllers.
    if lib.table.areEqual(thisController, nextController) then
      global.TC_data["nextTrainControllerIterate"] = nil
      -- TODO: stop on_tick
    else
      global.TC_data["nextTrainControllerIterate"] = util.table.deepcopy(nextController)
    end
  end

  -- STEP 2e: Delete this controller
  global.TC_data["trainControllers"][controllerSurface.index][controllerPosition.y][controllerPosition.x] = nil

  if lib.table.isEmpty(global.TC_data["trainControllers"][controllerSurface.index][controllerPosition.y]) then
    global.TC_data["trainControllers"][controllerSurface.index][controllerPosition.y] = nil
  end
  if lib.table.isEmpty(global.TC_data["trainControllers"][controllerSurface.index]) then
    global.TC_data["trainControllers"][controllerSurface.index] = nil
  end

  --game.print(serpent.block(global.TC_data["trainControllers"]))
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Traincontroller:getControllerItemName()
  return global.TC_data.prototypeData.trainControllerName
end



function Traincontroller:getControllerEntityName()
  return global.TC_data.prototypeData.trainControllerName
end



function Traincontroller:getTrainController(trainBuilderIndex)
  for surfaceIndex,_ in pairs(global.TC_data["trainControllers"]) do
    for positionY,_ in pairs(global.TC_data["trainControllers"][surfaceIndex]) do
      for positionX,_ in pairs(global.TC_data["trainControllers"][surfaceIndex][positionY]) do
        local trainController = global.TC_data["trainControllers"][surfaceIndex][positionY][positionX]

        if trainController["trainBuiderIndex"] == trainBuilderIndex then
          return trainController["entity"]
        end

      end
    end
  end

  return nil
end



function Traincontroller:checkValidAftherChanges(alteredEntity, playerIndex)
  -- A valid trainbuilder got altered. This happens when a building gets rotated
  -- or when a recipe got changed. We have to check if all recipes are set and
  -- if the builder has a validly placed locomotive still.

  if alteredEntity and alteredEntity.valid and alteredEntity.name == Trainassembly:getMachineEntityName() then
    local trainBuilderIndex = Trainassembly:getTrainBuilderIndex(alteredEntity)
    local trainController = self:getTrainController(trainBuilderIndex)
    if trainController then

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
          local droppedItem = trainController.surface.create_entity{
            name = "item-on-ground",
            stack = {
              name = self:getControllerItemName(),
              count = 1,
            },
            position = trainController.position,
            force = trainController.force,
            fast_replace = true,
            spill = false, -- delete excess items (only if fast_replace = true)
          }
          droppedItem.to_be_looted = true
          droppedItem.order_deconstruction(trainController.force)
        end

        -- Delete it from the data structure
        self:deleteController(trainController)
        
        -- Destroy the placed item
        trainController.destroy()
        return false
      end

      -- We know it is already validly placed, so we can check the trainbuilder
      -- and only have to check if it still has a locomotive facing the correct
      -- direction
      local hasValidLocomotive = false
      local hasAllRecipesSet = true
      for _, builderLocation in pairs(Trainassembly:getTrainBuilder(trainBuilderIndex)) do
        local machineEntity = Trainassembly:getMachineEntity(builderLocation["surfaceIndex"], builderLocation["position"])
        if machineEntity and machineEntity.valid and machineEntity.direction == trainController.direction then

          -- Step 1: Check if the recipe is set for each building, if not, this
          --         controller has become invalid, we don't have to look further
          local machineRecipe = machineEntity.get_recipe()
          if not machineRecipe then
            return notValid{"traincontroller-message.noBuilderRecipeFound", {"item-name.trainassembly"}}
          end

          -- Step 2: If this controller doesn't have a valid locomotive yet, we
          --         still have to check if this one might be a valid locomotive
          if not hasValidLocomotive then
            local builderType = lib.util.stringSplit(machineRecipe.name, "[")
            builderType = builderType[#builderType]
            builderType = builderType:sub(1, builderType:len()-1)
            if builderType == "locomotive" then
              hasValidLocomotive = true
            end
          end

        end
      end

      if not hasValidLocomotive then
        return notValid{"traincontroller-message.noValidLocomotiveFound",
          --[[1]]{"item-name.trainassembly"},
          --[[2]]"__ENTITY__locomotive__",
          --[[3]]{"item-name.traincontroller", {"item-name.trainassembly"}},
        }
      end

      return true
    end

    return false -- return false if no traincontroller found
  end

  return true -- return true if alteredEntity is not valid
end


function Traincontroller:checkValidPlacement(createdEntity, playerIndex)
  -- Checks the correct placement of the traincontroller, if not validly placed,
  -- it will inform the player with the corresponding message and return the
  -- traincontroller to the player. If no player is found, it will drop the
  -- traincontroller on the ground where the traincontroller was placed.

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
      local droppedItem = createdEntity.surface.create_entity{
        name = "item-on-ground",
        stack = {
          name = self:getControllerItemName(),
          count = 1,
        },
        position = createdEntity.position,
        force = createdEntity.force,
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

  -- STEP 1: Look for a trainassembler, if there is no trainassembler found,
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
  local entityPosition = createdEntity.position
  local entitySurface = createdEntity.surface
  local entitySurfaceIndex = entitySurface.index

  local builderEntity = entitySurface.find_entities_filtered{
    name     = Trainassembly:getMachineEntityName(),
    --type     = createdEntity.type,
    force    = createdEntity.force,
    area     = {
      { entityPosition.x + 3.5*entitySearchDirection.x - 1.5*entitySearchDirection.y , entityPosition.y + 3.5*entitySearchDirection.y + 1.5*entitySearchDirection.x },
      { entityPosition.x + 5.5*entitySearchDirection.x - 2.5*entitySearchDirection.y , entityPosition.y + 5.5*entitySearchDirection.y + 2.5*entitySearchDirection.x },
    },
    limit    = 1,
  }[1]

  if not (builderEntity and builderEntity.valid) then
    return notValid{"traincontroller-message.noTrainbuilderFound", {"item-name.trainassembly"}}
  end

  -- STEP 2: Find the trainbuilder that this trainassembler is part of
  local builderIndex = Trainassembly:getTrainBuilderIndex(builderEntity)
  -- STEP 2a: If there is no trainbuilder found, the controller is placed wrong.
  if not builderIndex then
    return notValid{"traincontroller-message.invalidTrainbuilderFound", {"item-name.trainassembly"}}
  end
  -- STEP 2b: If there is one, we need to make sure it isn't controlled yet.
  if self:getTrainController(builderIndex) then
    return notValid{"traincontroller-message.isAlreadyControlled",
      --[[1]]{"item-name.trainassembly"},
      --[[2]]{"item-name.traincontroller", {"item-name.trainassembly"}},
    }
  end

  -- STEP 3: Make sure the trainbuilder has all recipes set, and at least
  --         one of the recipes must be a locomotive that is facing it the
  --         direction the train is supposed to leave.
  local hasValidLocomotive = false
  for _, builderLocation in pairs(Trainassembly:getTrainBuilder(builderIndex)) do
    local machineEntity = Trainassembly:getMachineEntity(builderLocation["surfaceIndex"], builderLocation["position"])
    if machineEntity and machineEntity.valid and machineEntity.direction == entityDirection then
      local machineRecipe = machineEntity.get_recipe()
      if not machineRecipe then
        return notValid{"traincontroller-message.noBuilderRecipeFound", {"item-name.trainassembly"}}
      end

      local builderType = lib.util.stringSplit(machineRecipe.name, "[")
      builderType = builderType[#builderType]
      builderType = builderType:sub(1, builderType:len()-1)
      if builderType == "locomotive" then
        hasValidLocomotive = true
        break
      end
    end
  end

  if not hasValidLocomotive then
    return notValid{"traincontroller-message.noValidLocomotiveFound",
      --[[1]]{"item-name.trainassembly"},
      --[[2]]"__ENTITY__locomotive__",
      --[[3]]{"item-name.traincontroller", {"item-name.trainassembly"}},
    }
  end

  -- STEP 4: If all previous checks succeeded, it means it is validly placed.
  return true, builderIndex
end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player builds a new entity
function Traincontroller:onBuildEntity(createdEntity, playerIndex)
  -- The player created a new entity, the player can only place the controller
  -- If he configured the trainbuilder correctly. Otherwise we delete it again
  -- and inform the player what went wrong.
  --
  -- Player experience: The player activated the trainbuilder if its valid.
  if createdEntity and createdEntity.valid and createdEntity.name == self:getControllerEntityName() then
    -- it is the correct entity, now check if its correctly placed
    local validPlacement, trainBuiderIndex = self:checkValidPlacement(createdEntity, playerIndex)
    if validPlacement then -- It is valid, now we have to add the entity to the list
      self:saveNewStructure(createdEntity, trainBuiderIndex)
    end
  end
end



-- When a player/robot removes the building
function Traincontroller:onRemoveEntity(removedEntity)
  -- In some way the building got removed. This results in that the builder is
  -- removed. This also means we have to delete the train that was in this spot.
  --
  -- Player experience: Everything with the trainAssembler gets removed
  if removedEntity and removedEntity.valid and removedEntity.name == self:getControllerEntityName() then
    -- STEP 1: Update the data structure
    self:deleteController(removedEntity)
    -- TODO
  end
end



-- When a player rotates an entity
function Traincontroller:onPlayerRotatedEntity(rotatedEntity, playerIndex)
  -- The player rotated the machine entity, we need to make sure the controller
  -- is still valid.
  if rotatedEntity and rotatedEntity.valid and rotatedEntity.name == Trainassembly:getMachineEntityName() then
    Traincontroller:checkValidAftherChanges(rotatedEntity, playerIndex)
  end
end



-- When a player copy pastes a recipe
function Traincontroller:onPlayerChangedRecipe(pastedEntity, playerIndex)
  -- The player pasted a recipe in a machine entity, we need to make sure the
  -- controller is still valid.
  if pastedEntity and pastedEntity.valid and pastedEntity.name == Trainassembly:getMachineEntityName() then
    Traincontroller:checkValidAftherChanges(pastedEntity, playerIndex)
  end
end



-- when a trainbuilder gets altered (buildings added/deleted buildings)
function Traincontroller:onTrainbuilderAltered(trainBuilderIndex)
  -- if there is a traincontroller, we drop it on the floor
  local trainController = self:getTrainController(trainBuilderIndex)
  if trainController then
    -- delete from structure
    self:deleteController(trainController)

    -- drop the controller on the ground
    local droppedItem = trainController.surface.create_entity{
      name = "item-on-ground",
      stack = {
        name = self:getControllerItemName(),
        count = 1,
      },
      position = trainController.position,
      force = trainController.force,
      fast_replace = true,
      spill = false, -- delete excess items (only if fast_replace = true)
    }
    droppedItem.to_be_looted = true
    droppedItem.order_deconstruction(trainController.force)
    trainController.destroy()
  end
end
