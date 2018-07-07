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
    ["trainBuiders"] = {},    -- keep track of all builders that contain one or more trainAssemblers
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
    ["entity"]    = machineEntity,
    ["direction"] = machineEntity.direction,
  }

  -- STEP 3: Check if this assembler is linked to another assemblers to make
  --         single but bigger trains
  -- STEP 3a:Check for entities around this one. We know we only have to look
  --         in the same direction as its facing, as that is the directon the
  --         train will be build in
  local trainAssemblerNorthWest, trainAssemblerSouthEast
  if machineEntity.direction == defines.direction.north or machineEntity.direction == defines.direction.south then
    -- machine is placed vertical, look vertical (y-axis)
    -- north
    trainAssemblerNorthWest = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x, y = machinePosition.y - 7 },
      limit    = 1,
    }
    -- south
    trainAssemblerSouthEast = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x, y = machinePosition.y + 7 },
      limit    = 1,
    }
  else
    -- machine is placed horizontal, look horizontal (x-axis)
    -- west
    trainAssemblerNorthWest = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x - 7, y = machinePosition.y },
      limit    = 1,
    }
    -- east
    trainAssemblerSouthEast = machineSurface.find_entities_filtered{
      name     = machineEntity.name,
      type     = machineEntity.type,
      force    = machineEntity.force,
      position = { x = machinePosition.x + 7, y = machinePosition.y },
      limit    = 1,
    }
  end

  -- find_entities_filtered returns a list, we want only the entity,
  --so we get it out of the table. Also make sure it is valid
  if not lib.table.isEmpty(trainAssemblerNorthWest) then
    trainAssemblerNorthWest = trainAssemblerNorthWest[1]
    if not trainAssemblerNorthWest.valid then
      trainAssemblerNorthWest = nil
    end
  else
    trainAssemblerNorthWest = nil
  end
  if not lib.table.isEmpty(trainAssemblerSouthEast) then
    trainAssemblerSouthEast = trainAssemblerSouthEast[1]
    if not trainAssemblerSouthEast.valid then
      trainAssemblerSouthEast = nil
    end
  else
    trainAssemblerSouthEast = nil
  end

  -- STEP 3b:We found some entities now (maybe), but we still have to check if
  --         they are validly placed. If they aren't valid, we discard them too
  --         Validly placed item: - has same or oposite direction
  if trainAssemblerNorthWest and trainAssemblerNorthWest.valid then
    -- Check if its facing the same or oposite direction, if not, discard.
    if not (trainAssemblerNorthWest.direction == machineEntity.direction
            or trainAssemblerNorthWest.direction == lib.directions.oposite(machineEntity.direction) ) then
      trainAssemblerNorthWest = nil
    end
  end
  if trainAssemblerSouthEast and trainAssemblerSouthEast.valid then
    -- Check if its facing the same or oposite direction, if not, discard.
    if not (trainAssemblerSouthEast.direction == machineEntity.direction
            or trainAssemblerSouthEast.direction == lib.directions.oposite(machineEntity.direction) ) then
      trainAssemblerSouthEast = nil
    end
  end

  if trainAssemblerNorthWest then game.print("found one on the north or west side") end
  if trainAssemblerSouthEast then game.print("found one on the south or east side") end

  -- TODO

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
