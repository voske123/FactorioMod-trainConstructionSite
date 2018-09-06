require 'util'
require "lib.directions"
require "lib.table"

-- Create class
Trainassembly = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Trainassembly:onInit()
  -- Init global data; data stored through the whole map
  if not global.TA_data then
    global.TA_data = self:initGlobalData()
  end
end



-- Initiation of the global data
function Trainassembly:initGlobalData()
  local TA_data = {
    ["version"] = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes

    ["trainAssemblers"] = {}, -- keep track of all assembling machines

    ["trainBuilders"] = {},    -- keep track of all builders that contain one or more trainAssemblers
    ["nextTrainBuilderIndex"] = 1,
  }

  return util.table.deepcopy(TA_data)
end



-- Initialisation of the prototye data inside the global data
function Trainassembly:initPrototypeData()
  return
  {
    ["itemName"]      = "trainassembly",                -- the item
    ["placeableName"] = "trainassembly-placeable",      -- locomotive entity
    ["machineName"]   = "trainassembly-machine",        -- assembling entity
  }
end



--------------------------------------------------------------------------------
-- Setter functions to insert data into the data structure
--------------------------------------------------------------------------------
-- Save a new trainassembly to our data structure
function Trainassembly:saveNewStructure(machineEntity)
  -- With this function we save all the data we want about a trainassembly.
  -- To index all machines we need a (unique) way of storing all the data,
  -- here we chose to index it by its location, since only 1 building can
  -- be standing in 1 place. So we index it by surface and position.

  -- STEP 1: This step should be obsolite, we need to check if the entity is
  --         valid, if not, the surface and position it was placed on will
  --         be invalid as well.
  if not (machineEntity and machineEntity.valid) then
    return nil
  end
  local machineSurface  = machineEntity.surface
  local machinePosition = machineEntity.position

  -- STEP 2: Save the assembler in the trainAssemblers datastructure
  -- STEP 2a:Make sure we can index it, meaning, check if the table already
  --         excists for the surface, if not, we make one. Afther that we also
  --         have to check if the surface table has a table we can index for
  --         the y-position, if not, we make one.
  if not global.TA_data["trainAssemblers"][machineSurface.index] then
    global.TA_data["trainAssemblers"][machineSurface.index] = {}
  end
  if not global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y] then
    global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y] = {}
  end

  -- STEP 2b:Now we know we can index (without crashing) to the position as:
  --         dataStructure[surfaceIndex][positionY][positionX]
  --         Now we can store our wanted data at this position
  global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x] =
  {
    ["entity"]            = machineEntity,           -- the entity
    ["direction"]         = machineEntity.direction, -- the direction its facing
    ["trainBuilderIndex"] = nil,                     -- the trainBuilder it belongs to (see further down)
  }

  -- STEP 3: Check if this assembler is linked to another assemblers to make
  --         single but bigger trains
  -- STEP 3a:Check for entities around this one. We know we only have to look
  --         in the same direction as its facing, as that is the directon the
  --         train will be build in
  local trainAssemblerNW, trainAssemblerSE
  if machineEntity.direction == defines.direction.north or machineEntity.direction == defines.direction.south then
    -- machine is placed vertical, look vertical (y-axis)
    -- north
    trainAssemblerNW = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x, y = machinePosition.y - 7 },
      limit    = 1,
    }
    -- south
    trainAssemblerSE = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x, y = machinePosition.y + 7 },
      limit    = 1,
    }
  else
    -- machine is placed horizontal, look horizontal (x-axis)
    -- west
    trainAssemblerNW = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x - 7, y = machinePosition.y },
      limit    = 1,
    }
    -- east
    trainAssemblerSE = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x + 7, y = machinePosition.y },
      limit    = 1,
    }
  end

  -- find_entities_filtered returns a list, we want only the entity,
  -- so we get it out of the table. Also make sure it is valid
  if not lib.table.isEmpty(trainAssemblerNW) then
    trainAssemblerNW = trainAssemblerNW[1]
    if not trainAssemblerNW.valid then
      trainAssemblerNW = nil
    end
  else
    trainAssemblerNW = nil
  end
  if not lib.table.isEmpty(trainAssemblerSE) then
    trainAssemblerSE = trainAssemblerSE[1]
    if not trainAssemblerSE.valid then
      trainAssemblerSE = nil
    end
  else
    trainAssemblerSE = nil
  end

  -- STEP 3b:We found some entities now (maybe), but we still have to check if
  --         they are validly placed. If they aren't valid, we discard them too
  --         Validly placed item: - has same or oposite direction
  if trainAssemblerNW and trainAssemblerNW.valid then
    -- Check if its facing the same or oposite direction, if not, discard.
    if not (trainAssemblerNW.direction == machineEntity.direction
            or trainAssemblerNW.direction == lib.directions.oposite(machineEntity.direction) ) then
      trainAssemblerNW = nil
    end
  end
  if trainAssemblerSE and trainAssemblerSE.valid then
    -- Check if its facing the same or oposite direction, if not, discard.
    if not (trainAssemblerSE.direction == machineEntity.direction
            or trainAssemblerSE.direction == lib.directions.oposite(machineEntity.direction) ) then
      trainAssemblerSE = nil
    end
  end

  -- STEP 3c:We found valid entities (maybe), either way, we have to add this
  --         assembling machine to a trainBuilder
  if (not trainAssemblerNW) and (not trainAssemblerSE) then
    -- OPTION 3c.1: there is no neighbour detected, we create a new one
    local trainBuiderIndex = global.TA_data["nextTrainBuilderIndex"]

    -- add reference to the trainassembly
    global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x]["trainBuilderIndex"] = trainBuiderIndex

    -- and add the new trainBuilder with a single trainAssembler reference
    global.TA_data["trainBuilders"][trainBuiderIndex] =
    {
      {
        ["surfaceIndex"] = machineSurface.index,
        ["position"]     = { x = machinePosition.x, y = machinePosition.y },
      },
    }

    -- new trainbuilder added, now increment the nextIndex
    global.TA_data["nextTrainBuilderIndex"] = trainBuiderIndex + 1

  else -- there is one or more neighbours
    if (trainAssemblerNW and (not trainAssemblerSE)) then
      -- OPTION 3c.2a: There is only one neighbour detected.
      --               Only the northwest one was detected, we add it to his
      --               trainbuilder.
      local trainBuiderIndex = global.TA_data["trainAssemblers"][trainAssemblerNW.surface.index][trainAssemblerNW.position.y][trainAssemblerNW.position.x]["trainBuilderIndex"]

      -- add reference to the trainBuilder in the trainassembly
      global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x]["trainBuilderIndex"] = trainBuiderIndex

      -- and add this trainAssembler reference to the existing trainBuilder
      table.insert(global.TA_data["trainBuilders"][trainBuiderIndex], {
        ["surfaceIndex"] = machineSurface.index,
        ["position"]     = { x = machinePosition.x, y = machinePosition.y },
      })

    elseif (trainAssemblerSE and (not trainAssemblerNW)) then
      -- OPTION 3c.2b: There is only one neighbour detected.
      --               Only the southeast one was detected, we add it to his
      --               trainbuilder.
      local trainBuiderIndex = global.TA_data["trainAssemblers"][trainAssemblerSE.surface.index][trainAssemblerSE.position.y][trainAssemblerSE.position.x]["trainBuilderIndex"]

      -- add reference to the trainBuilder in the trainassembly
      global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x]["trainBuilderIndex"] = trainBuiderIndex

      -- and add this trainAssembler reference to the existing trainBuilder
      table.insert(global.TA_data["trainBuilders"][trainBuiderIndex], {
        ["surfaceIndex"] = machineSurface.index,
        ["position"]     = { x = machinePosition.x, y = machinePosition.y },
      })

    else
      -- OPTION 3c.3: Both neighbours are detected
      --              First we need to merge the two existing trainBuilders
      --              together. Let's merge the SE one inside the NW one
      local trainBuiderIndexNW = global.TA_data["trainAssemblers"][trainAssemblerNW.surface.index][trainAssemblerNW.position.y][trainAssemblerNW.position.x]["trainBuilderIndex"]
      local trainBuiderIndexSE = global.TA_data["trainAssemblers"][trainAssemblerSE.surface.index][trainAssemblerSE.position.y][trainAssemblerSE.position.x]["trainBuilderIndex"]

      for trainAssemblerIndex, trainAssemblerRef in pairs(global.TA_data["trainBuilders"][trainBuiderIndexSE]) do
        -- Move the reference into the other trainBuilder
        table.insert(global.TA_data["trainBuilders"][trainBuiderIndexNW], util.table.deepcopy(trainAssemblerRef))
      end

      -- Now all the assemblers of the SE one are in the NW one, we can now delete
      -- the whole SE trainbuilder. If we delete it, we have a 'hole' in our list
      -- to fix that, we move the last one in this spot * fixed XD *. But if this
      -- is already the last one, we don't have this issue. And when we move the're
      -- is a possibility we moved the NW over. We've also deleted a trainbuiler,
      -- so we'll have to update our nextIndex - 1.
      local lastIndex = global.TA_data["nextTrainBuilderIndex"] - 1

      -- check if its the last one, if not the last one we fill the hole of the SE one
      if (trainBuiderIndexSE ~= lastIndex) then
        -- copy the last one over to the hole and adapt all the references to the
        -- trianBuilder of all the trainAssemblers we moved
        global.TA_data["trainBuilders"][trainBuiderIndexSE] = util.table.deepcopy(global.TA_data["trainBuilders"][lastIndex])
        for _, trainAssemblerRef in pairs(global.TA_data["trainBuilders"][trainBuiderIndexSE]) do
          global.TA_data["trainAssemblers"][trainAssemblerRef.surfaceIndex][trainAssemblerRef.position.y][trainAssemblerRef.position.x]["trainBuilderIndex"] = trainBuiderIndexSE
        end

        -- it could be the other one we moved
        if trainBuiderIndexNW == lastIndex then
          trainBuiderIndexNW = trainBuiderIndexSE
        end
      end

      -- delete the reference of the last index
      global.TA_data["trainBuilders"][lastIndex] = nil
      global.TA_data["nextTrainBuilderIndex"] = lastIndex

      -- and add this trainAssembler reference to that existing trainBuilder
      table.insert(global.TA_data["trainBuilders"][trainBuiderIndexNW], {
        ["surfaceIndex"] = machineSurface.index,
        ["position"]     = { x = machinePosition.x, y = machinePosition.y },
      })

      -- now we finaly merged them both together and added the new assembler, now
      -- we can start updating the reference in the trainassembly to the trainbuilders
      --global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x]["trainBuilderIndex"] = trainBuiderIndexNW
      for _, trainAssemblerRef in pairs(global.TA_data["trainBuilders"][trainBuiderIndexNW]) do
        global.TA_data["trainAssemblers"][trainAssemblerRef.surfaceIndex][trainAssemblerRef.position.y][trainAssemblerRef.position.x]["trainBuilderIndex"] = trainBuiderIndexNW
      end
    end
  end
end

function Trainassembly:deleteBuilding(machineEntity)

  --Step 1: check if the machineEntity is valid.
  if not (machineEntity and machineEntity.valid) then
    return nil
  end
  local machineSurface  = machineEntity.surface
  local machinePosition = machineEntity.position

  --Step 2a: check what direction it is facing (vertical or horizontal)
  local trainAssemblerNW, trainAssemblerSE
  if machineEntity.direction == defines.direction.north or machineEntity.direction == defines.direction.south then
    -- machine is placed vertical, look vertical (y-axis)
    -- north
    trainAssemblerNW = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x, y = machinePosition.y - 7 },
      limit    = 1,
    }
    -- south
    trainAssemblerSE = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x, y = machinePosition.y + 7 },
      limit    = 1,
    }
  else
    -- machine is placed horizontal, look horizontal (x-axis)
    -- west
    trainAssemblerNW = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x - 7, y = machinePosition.y },
      limit    = 1,
    }
    -- east
    trainAssemblerSE = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x + 7, y = machinePosition.y },
      limit    = 1,
    }
  end

  -- find_entities_filtered returns a list, we want only the entity,
  -- so we get it out of the table. Also make sure it is valid
  if not lib.table.isEmpty(trainAssemblerNW) then
    trainAssemblerNW = trainAssemblerNW[1]
    if not trainAssemblerNW.valid then
      trainAssemblerNW = nil
    end
  else
    trainAssemblerNW = nil
  end
  if not lib.table.isEmpty(trainAssemblerSE) then
    trainAssemblerSE = trainAssemblerSE[1]
    if not trainAssemblerSE.valid then
      trainAssemblerSE = nil
    end
  else
    trainAssemblerSE = nil
  end

  -- STEP 2b: We found some entities now (maybe), but we still have to check if
  --          they are validly placed. If they aren't valid, we discard them too
  --          Validly placed item: - has same or oposite direction
  if trainAssemblerNW and trainAssemblerNW.valid then
    -- Check if its facing the same or oposite direction, if not, discard.
    if not (trainAssemblerNW.direction == machineEntity.direction
            or trainAssemblerNW.direction == lib.directions.oposite(machineEntity.direction) ) then
      trainAssemblerNW = nil
    end
  end
  if trainAssemblerSE and trainAssemblerSE.valid then
    -- Check if its facing the same or oposite direction, if not, discard.
    if not (trainAssemblerSE.direction == machineEntity.direction
            or trainAssemblerSE.direction == lib.directions.oposite(machineEntity.direction) ) then
      trainAssemblerSE = nil
    end
  end

  -- STEP 2c: Now that we found the entities, we can start updating the trainBuilder
  if (not trainAssemblerNW) and (not trainAssemblerSE) then
    local trainBuilderIndex = global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x]["trainBuilderIndex"]

    global.TA_data["trainBuilders"][trainBuilderIndex] = nil
    local lastTrainBuilderIndex = global.TA_data["nextTrainBuilderIndex"] - 1

    if not (trainBuilderIndex == lastTrainBuilderIndex) then
      global.TA_data["trainBuilders"][trainBuilderIndex] = util.table.deepcopy(global.TA_data["trainBuilders"][lastTrainBuilderIndex])

      -- update all the trainAssemblers
      for _, location in pairs(global.TA_data["trainBuilders"][trainBuilderIndex]) do
        global.TA_data["trainAssemblers"][location["surfaceIndex"]][location["position"].y][location["position"].x]["trainBuilderIndex"] = trainBuilderIndex
      end
    end

    global.TA_data["nextTrainBuilderIndex"] = lastTrainBuilderIndex

  else -- there is one or more neighbours

    if (trainAssemblerNW and (not trainAssemblerSE)) or (trainAssemblerSE and (not trainAssemblerNW)) then -- only one neighbour

      local trainBuilderIndex = global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x]["trainBuilderIndex"]

      -- delete the assembler out of the trainbuilder
      for locationIndex, location in pairs(global.TA_data["trainBuilders"][trainBuilderIndex]) do
        if location["surfaceIndex"] == machineSurface.index and location["position"].y == machinePosition.y and location["position"].x == machinePosition.x then
          table.remove(global.TA_data["trainBuilders"][trainBuilderIndex], locationIndex)
          break
      end
    end

  else -- there are two neighbours

    local trainBuilderIndex  = global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x]["trainBuilderIndex"]
    local newTrainBuilderIndex = global.TA_data["nextTrainBuilderIndex"]
    global.TA_data["trainBuilders"][lastTrainBuilderIndex] = {}

    local builderIsVertical = false
    if trainAssemblerNW.direction == defines.direction.north then
      builderIsVertical = true
    end

    -- delete the assembler out of the trainbuilder
    for locationIndex, location in pairs(global.TA_data["trainBuilders"][trainBuilderIndex]) do
      if location["surfaceIndex"] == machineSurface.index and location["position"].y == machinePosition.y and location["position"].x == machinePosition.x then
        table.remove(global.TA_data["trainBuilders"][trainBuilderIndex], locationIndex)
        break
      end
    end

    for locationIndex, location in pairs(global.TA_data["trainbuilders"][trainbuilderIndex]) do
      local needToMove = false

      if builderIsVertical then
        if location["position"].y < machinePosition.y then
          needToMove = true
        end
      else
        if location["position"].x < machinePosition.x then
          needToMove = true
        end
      end

      if needToMove then --moving assemblers over to different builder
        table.insert(global.TA_data["trainBuilders"][lastTrainBuilderIndex], util.table.deepcopy(global.TA_data["trainbuilders"][trainBuilderIndex][locationIndex])) --copy over to different builder
        global.TA_data["trainbuilders"][trainBuiderIndex][locationIndex] = nil --delete the old one
        global.TA_data["trainAssemblers"][location["surfaceIndex"]][location["position"].y][location["position"].x]["trainBuilderIndex"] = newTrainBuilderIndex --adjusting trainbuilderindex in assembler
      end
    end

    global.TA_data["nextTrainBuilderIndex"] = newTrainBuilderIndex + 1
  end

  game.print(serpent.block(global.TA_data["trainBuilders"]))

  -- STEP 3: Deleting the trainAssembler
  global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x] = nil

  if lib.table.isEmpty(global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y]) then
    global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y] = nil

    if lib.table.isEmpty(global.TA_data["trainAssemblers"][machineSurface.index]) then
      global.TA_data["trainAssemblers"][machineSurface.index] = nil
    end
  end

end




function Trainassembly:updateMachineDirection(machineEntity)

  if not (machineEntity and machineEntity.valid) then
    return nil
  end
  local machineSurface  = machineEntity.surface
  if not global.TA_data["trainAssemblers"][machineSurface.index] then
    return nil
  end
  local machinePosition = machineEntity.position
  if not global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y] then
    return nil
  end
  if not global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x] then
    return nil
  end

  global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x]["direction"] = machineEntity.direction
end

--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Trainassembly:getPlaceableEntityName()
  return global.TA_data.prototypeData.placeableName
end



function Trainassembly:getMachineEntityName()
  return global.TA_data.prototypeData.machineName
end



function Trainassembly:getMachineDirection(machineEntity)
  -- STEP 1: If the machineEntity isn't valid, its position isn't valid either
  if not (machineEntity and machineEntity.valid) then
    return nil
  end

  -- STEP 2: If we don't have a trainBuilder saved on that surface, or not
  --         on that y position or on that x position, it means that we don't
  --         have a direction available for that machine.
  local machineSurface = machineEntity.surface
  if not global.TA_data["trainAssemblers"][machineSurface.index] then
    return nil
  end
  local machinePosition = machineEntity.position
  if not global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y] then
    return nil
  end
  if not global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x] then
    return nil
  end

  -- STEP 3: In step 2 we checked for an invalid data structure. So now we
  --         can return the direction the machine is/was facing.
  return global.TA_data["trainAssemblers"][machineSurface.index][machinePosition.y][machinePosition.x]["direction"]
end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player builds a new entity
function Trainassembly:onPlayerBuildEntity(createdEntity)
  -- The player created a new entity, the player can only place the placeable item.
  -- So we have to check if the player placed this entity, if so, we remove it.
  -- We manualy have to build a machine entity on the same spot.
  --
  -- Player experience: The player thinks he builded an assembling machine on top of rails.
  if createdEntity and createdEntity.valid and createdEntity.name == self:getPlaceableEntityName() then
    -- We know the createdEntity is the placeable entity, meaning the player wants
    -- to build a trainassembly on this spot

    -- STEP 1: temporary store where the locomotive was placed and by who (the force)
    local entitySurface  = createdEntity.surface   -- surface it was build on
    local entityPosition = createdEntity.position  -- position it was placed
    local entityDirecton = lib.directions.orientationTo4WayDirection(createdEntity.orientation) -- the orientation it was placed in
    local entityForce    = createdEntity.force

    -- STEP 2: delete the locomotive we've build since we're gonna replace it.
    createdEntity.destroy()

    -- STEP 3: place the assembling machine on the same spot (saved in step 1)
    local machineEntity = entitySurface.create_entity({
      name      = self:getMachineEntityName(),
      position  = entityPosition,
      direction = entityDirecton,
      force     = entityForce,
    })

    -- STEP 4: Save the newly made trainassembly to our data structure so we can keep track of it
    self:saveNewStructure(machineEntity)
  end
end

-- When a player/robot removes the building
function Trainassembly:onRemoveEntity(removedEntity)
  -- In some way the building got removed. This results in that the builder is
  -- removed. This also means we have to delete the train that was in this spot.
  --
  -- Player experience: Everything with the trainAssembler gets removed
  if removedEntity and removedEntity.valid and removedEntity.name == self:getMachineEntityName() then
    -- STEP 1: all the stuff that needs deletion

    -- STEP 4: Update the data structure
    self:deleteBuilding(removedEntity)
  end
end


-- When a player rotates an entity
function Trainassembly:onPlayerRotatedEntity(rotatedEntity)
  -- The player rotated the machine entity 90 degrees, the building can only be
  -- rotated on 180 degree angles. So we have to manualy rotate it another 90 degree.
  --
  -- Player experience: The player thinks he rotated the entity 180 degree
  if rotatedEntity and rotatedEntity.valid and rotatedEntity.name == self:getMachineEntityName() then
    local newDirection = lib.directions.oposite(self:getMachineDirection(rotatedEntity))

    rotatedEntity.direction = newDirection

    self:updateMachineDirection(rotatedEntity)

  end
end
