require 'util'
require "LSlib/lib"

-- Create class
Traindepot = {}
require 'src.traindepot-gui'

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Traindepot:onInit()
  -- Init global data; data stored through the whole map
  if not global.TD_data then
    global.TD_data = self:initGlobalData()
  end
  self.Gui:onInit()
end



-- Initiation of the global data
function Traindepot:initGlobalData()
  local TD_data = {
    ["version"]       = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes

    ["depotNames"]  = {},  -- keep track of all depot names
  }

  return util.table.deepcopy(TD_data)
end



-- Initialisation of the prototye data inside the global data
function Traindepot:initPrototypeData()
  return
  {
    ["traindepotName"] = "traindepot", -- item and entity have same name
  }
end



--------------------------------------------------------------------------------
-- Setter functions to alter data into the data structure
--------------------------------------------------------------------------------
function Traindepot:saveNewStructure(depotEntity)
  -- With this function we save all the data we want about a traindepot

  -- STEP 1: Save the station name to the list (used in the UI)
  -- STEP 1a:Make sure we can index it (same as step 1a)
  local depotForceName = depotEntity.force.name
  if not global.TD_data["depotNames"][depotForceName] then
    global.TD_data["depotNames"][depotForceName] = {}
  end
  local depotSurfaceIndex = depotEntity.surface.index
  if not global.TD_data["depotNames"][depotForceName][depotSurfaceIndex] then
    global.TD_data["depotNames"][depotForceName][depotSurfaceIndex] = {}
  end

  -- STEP 1b:Now we know we can index (without crashing) to the position as:
  --         dataStructure[forceName][surfaceIndex]
  --         Now we can store the depotName here
  local stationName = depotEntity.backer_name
  local stationAmount = global.TD_data["depotNames"][depotForceName][depotSurfaceIndex][stationName] or 0
  global.TD_data["depotNames"][depotForceName][depotSurfaceIndex][stationName] = stationAmount + 1
end



function Traindepot:deleteBuilding(depotEntity)
  local depotForceName = depotEntity.force.name
  local depotSurfaceIndex = depotEntity.surface.index

  local stationName = depotEntity.backer_name
  local stationAmount = global.TD_data["depotNames"][depotForceName][depotSurfaceIndex][stationName]

  if stationAmount then
    if stationAmount > 1 then
      global.TD_data["depotNames"][depotForceName][depotSurfaceIndex][stationName] = stationAmount - 1
    else
      global.TD_data["depotNames"][depotForceName][depotSurfaceIndex][stationName] = nil

      if LSlib.utils.table.isEmpty(global.TD_data["depotNames"][depotForceName][depotSurfaceIndex]) then
        global.TD_data["depotNames"][depotForceName][depotSurfaceIndex] = nil

        if LSlib.utils.table.isEmpty(global.TD_data["depotNames"][depotForceName]) then
          global.TD_data["depotNames"][depotForceName] = nil
        end
      end
    end

  end
end



function Traindepot:renameBuilding(depotEntity, oldName)
  local stationName = depotEntity.backer_name
  if oldName ~= stationName then -- checking to make sure it is actualy changed

    local depotForceName = depotEntity.force.name
    local depotSurfaceIndex = depotEntity.surface.index

    -- remove the old one
    local stationAmount = global.TD_data["depotNames"][depotForceName][depotSurfaceIndex][oldName]
    if stationAmount then
      if stationAmount > 1 then
        global.TD_data["depotNames"][depotForceName][depotSurfaceIndex][oldName] = stationAmount - 1
      else
        global.TD_data["depotNames"][depotForceName][depotSurfaceIndex][oldName] = nil
        -- no need to delete empty tables, since we'll be adding one to it again
      end
    end

    -- add the new one
    stationAmount = global.TD_data["depotNames"][depotForceName][depotSurfaceIndex][stationName] or 0
    global.TD_data["depotNames"][depotForceName][depotSurfaceIndex][stationName] = stationAmount + 1
  end
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Traindepot:hasDepotEntities(depotForceName, depotSurfaceIndex)
  -- returns true if at least one depot has been build on the force on that surface
  if global.TD_data["depotNames"][depotForceName] then
    if global.TD_data["depotNames"][depotForceName][depotSurfaceIndex] then
      return not LSlib.utils.table.isEmpty(global.TD_data["depotNames"][depotForceName][depotSurfaceIndex])
    end
  end
  return false
end



function Traindepot:getDepotEntityName()
  return global.TD_data["prototypeData"]["traindepotName"]
end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player builds a new entity
function Traindepot:onBuildEntity(createdEntity)
  if createdEntity.name == self:getDepotEntityName() then
    self:saveNewStructure(createdEntity)

    -- after structure is saved, we rename it, this will trigger Traindepot:onRenameEntity as well
    createdEntity.backer_name = "Unused Traindepot"
  end
end



-- When a player/robot removes the building
function Traindepot:onRemoveEntity(removedEntity)
  if removedEntity.name == self:getDepotEntityName() then
    self:deleteBuilding(removedEntity)
  end
end



-- When a player/script renames an entity
function Traindepot:onRenameEntity(renamedEntity, oldName)
  if renamedEntity.name == self:getDepotEntityName() then
    self:renameBuilding(renamedEntity, oldName)
  end
end
