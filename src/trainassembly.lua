require 'util'
require "lib.utilities"
-- Create class
Trainassembly = {}

-- Initiation of the class
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

    ["prototypeData"] = -- data storing info about the prototypes
    {
      ["itemName"] = "trainassembly",                -- the item
      ["placeableName"] = "trainassembly-placeable", -- locomotive entity
      ["machineName"] = "trainassembly-machine",     -- assembling entity
    },

    ["trainBuilders"] = {}, -- keep track of all builders containing builderEntities
    ["nextTrainBuilderIndex"] = 1, -- keep track of the next available index of the trainBuilders
  }

  return util.table.deepcopy(TA_data)
end



function Trainassembly:getPlaceableEntityName()
  return global.TA_data.prototypeData.placeableName
end
function Trainassembly:getMachineEntityName()
  return global.TA_data.prototypeData.machineName
end



function Trainassembly:onPlayerBuildEntity(createdEntity)
  -- The player created a new entity, the player can only place the placeable item.
  -- So we have to check if the player placed this entity, if so, we remove it.
  -- We manualy have to build a machine entity on the same spot.
  --
  -- Player experience: The player thinks he builded an assembling machine on top of rails.
  if createdEntity and createdEntity.valid and createdEntity.name == self:getPlaceableEntityName() then
    -- we know the createdEntity is the placable entity.

    -- step 1: temporary store where the locomotive was placed and by who
    local entitySurface  = createdEntity.surface   -- surface it was build on
    local entityPosition = createdEntity.position  -- position it was placed
    local entityDirecton = orientationTo4WayDirection(createdEntity.orientation) -- the orientation it was placed in
    local entityForce    = createdEntity.force

    -- step 2: delete the locomotive
    createdEntity.destroy()

    -- step 3: place the assembling machine on the same spot (saved in step 1)
    local machine = entitySurface.create_entity({
      name      = self:getMachineEntityName(),
      position  = entityPosition,
      direction = entityDirecton,
      force     = entityForce,
    })

  end
end
