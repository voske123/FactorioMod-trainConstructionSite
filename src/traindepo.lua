require 'util'
require "LSlib/lib"

-- Create class
Traindepo = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Traindepo:onInit()
  -- Init global data; data stored through the whole map
  if not global.TD_data then
    global.TD_data = self:initGlobalData()
  end
end



-- Initiation of the global data
function Traindepo:initGlobalData()
  local TD_data = {
    ["version"]       = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes

    ["depoNames"]  = {},  -- keep track of all depo names
  }

  return util.table.deepcopy(TD_data)
end



-- Initialisation of the prototye data inside the global data
function Traindepo:initPrototypeData()
  return
  {
    ["traindepoName"] = "traindepo", -- item and entity have same name
  }
end



--------------------------------------------------------------------------------
-- Setter functions to alter data into the data structure
--------------------------------------------------------------------------------
function Traindepo:saveNewStructure(depoEntity)
  -- With this function we save all the data we want about a traindepo

  -- STEP 1: Save the station name to the list (used in the UI)
  -- STEP 1a:Make sure we can index it (same as step 1a)
  local depoForceName = depoEntity.force.name
  if not global.TD_data["depoNames"][depoForceName] then
    global.TD_data["depoNames"][depoForceName] = {}
  end
  local depoSurfaceIndex = depoEntity.surface.index
  if not global.TD_data["depoNames"][depoForceName][depoSurfaceIndex] then
    global.TD_data["depoNames"][depoForceName][depoSurfaceIndex] = {}
  end

  -- STEP 1b:Now we know we can index (without crashing) to the position as:
  --         dataStructure[forceName][surfaceIndex]
  --         Now we can store the depoName here
  local stationName = depoEntity.backer_name
  local stationAmount = global.TD_data["depoNames"][depoForceName][depoSurfaceIndex][stationName] or 0
  global.TD_data["depoNames"][depoForceName][depoSurfaceIndex][stationName] = stationAmount + 1
end



function Traindepo:deleteBuilding(depoEntity)
  local depoForceName = depoEntity.force.name
  local depoSurfaceIndex = depoEntity.surface.index

  local stationName = depoEntity.backer_name
  local stationAmount = global.TD_data["depoNames"][depoForceName][depoSurfaceIndex][stationName]

  if stationAmount then
    if stationAmount > 1 then
      global.TD_data["depoNames"][depoForceName][depoSurfaceIndex][stationName] = stationAmount - 1
    else
      global.TD_data["depoNames"][depoForceName][depoSurfaceIndex][stationName] = nil

      if LSlib.utils.table.isEmpty(global.TD_data["depoNames"][depoForceName][depoSurfaceIndex]) then
        global.TD_data["depoNames"][depoForceName][depoSurfaceIndex] = nil

        if LSlib.utils.table.isEmpty(global.TD_data["depoNames"][depoForceName]) then
          global.TD_data["depoNames"][depoForceName] = nil
        end
      end
    end

  end
end



function Traindepo:renameBuilding(depoEntity, oldName)
  local stationName = depoEntity.backer_name
  if oldName ~= stationName then -- checking to make sure it is actualy changed

    local depoForceName = depoEntity.force.name
    local depoSurfaceIndex = depoEntity.surface.index

    -- remove the old one
    local stationAmount = global.TD_data["depoNames"][depoForceName][depoSurfaceIndex][oldName]
    if stationAmount then
      if stationAmount > 1 then
        global.TD_data["depoNames"][depoForceName][depoSurfaceIndex][oldName] = stationAmount - 1
      else
        global.TD_data["depoNames"][depoForceName][depoSurfaceIndex][oldName] = nil
        -- no need to delete empty tables, since we'll be adding one to it again
      end
    end

    -- add the new one
    stationAmount = global.TD_data["depoNames"][depoForceName][depoSurfaceIndex][stationName] or 0
    global.TD_data["depoNames"][depoForceName][depoSurfaceIndex][stationName] = stationAmount + 1
  end
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Traindepo:hasDepoEntities(depoForceName, depoSurfaceIndex)
  -- returns true if at least one depo has been build on the force on that surface
  if global.TD_data["depoNames"][depoForceName] then
    if global.TD_data["depoNames"][depoForceName][depoSurfaceIndex] then
      return not LSlib.utils.table.isEmpty(global.TD_data["depoNames"][depoForceName][depoSurfaceIndex])
    end
  end
  return false
end



function Traindepo:getDepoEntityName()
  return global.TD_data["prototypeData"]["traindepoName"]
end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player builds a new entity
function Traindepo:onBuildEntity(createdEntity)
  if createdEntity.name == self:getDepoEntityName() then
    self:saveNewStructure(createdEntity)
  end
end



-- When a player/robot removes the building
function Traindepo:onRemoveEntity(removedEntity)
  if removedEntity.name == self:getDepoEntityName() then
    self:deleteBuilding(removedEntity)
  end
end



function Traindepo:onRenameEntity(renamedEntity, oldName)
  if renamedEntity.name == self:getDepoEntityName() then
    self:renameBuilding(renamedEntity, oldName)
  end
end
