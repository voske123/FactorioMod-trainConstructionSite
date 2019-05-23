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
    ["version"        ] = 1, -- version of the global data
    ["prototypeData"  ] = self:initPrototypeData(), -- data storing info about the prototypes

    ["depots"         ] = {},  -- keep track of all depots and there entity data
    ["depotStatistics"] = {},  -- keep track of all depot names and statistics about them
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
  local depotForceName    = depotEntity.force.name
  local depotSurfaceIndex = depotEntity.surface.index
  local depotPosition     = depotEntity.position
  local depotName         = depotEntity.backer_name

  -- STEP 1: Save the depot entity
  -- STEP 1a:Make sure we can index it, meaning, check if the table already
  --         excists for the surface, if not, we make one. Afther that we also
  --         have to check if the surface table has a table we can index for
  --         the y-position, if not, we make one.
  if not global.TD_data["depots"][depotSurfaceIndex] then
    global.TD_data["depots"][depotSurfaceIndex] = {}
  end
  if not global.TD_data["depots"][depotSurfaceIndex][depotPosition.y] then
    global.TD_data["depots"][depotSurfaceIndex][depotPosition.y] = {}
  end

  -- STEP 1b:Now we know we can index (without crashing) to the position as:
  --         dataStructure[surfaceIndex][positionY][positionX]
  --         Now we can store our wanted data at this position
  global.TD_data["depots"][depotSurfaceIndex][depotPosition.y][depotPosition.x] = {
    ["entity"] = depotEntity, -- the controller entity
  }

  -- STEP 2: Save the station name to the list of statistics
  self:setStationAmount(depotForceName, depotSurfaceIndex, depotName, self:getDepotStationCount(depotForceName, depotSurfaceIndex, depotName) + 1)
end



function Traindepot:deleteBuilding(depotEntity)
  -- With this function we remove all the saved data about the traindepot
  local depotForceName    = depotEntity.force.name
  local depotSurfaceIndex = depotEntity.surface.index
  local depotPosition     = depotEntity.position
  local depotName         = depotEntity.backer_name

  -- STEP 1: Delete the building
  if global.TD_data["depots"][depotSurfaceIndex][depotPosition.y][depotPosition.x] then
    global.TD_data["depots"][depotSurfaceIndex][depotPosition.y][depotPosition.x] = nil

    if LSlib.utils.table.isEmpty(global.TD_data["depots"][depotSurfaceIndex][depotPosition.y]) then
      global.TD_data["depots"][depotSurfaceIndex][depotPosition.y] = nil

      if LSlib.utils.table.isEmpty(global.TD_data["depots"][depotSurfaceIndex]) then
        global.TD_data["depots"][depotSurfaceIndex] = nil
      end
    end
  end

  -- STEP2: Update the statistics
  self:setStationAmount(depotForceName, depotSurfaceIndex, depotName, self:getDepotStationCount(depotForceName, depotSurfaceIndex, depotName) - 1)

  -- STEP3: Update the UI
  self.Gui:updateOpenedGuis(depotName)
end



function Traindepot:renameBuilding(depotEntity, oldName)
  local depotName = depotEntity.backer_name
  if oldName ~= depotName then -- checking to make sure it is actualy changed

    local depotForceName = depotEntity.force.name
    local depotSurfaceIndex = depotEntity.surface.index

    -- remove the old one
    self:setStationAmount(depotForceName, depotSurfaceIndex, oldName,
      self:getDepotStationCount(depotForceName, depotSurfaceIndex, oldName) - 1)

    -- add the new one
    self:setStationAmount(depotForceName, depotSurfaceIndex, depotName,
      self:getDepotStationCount(depotForceName, depotSurfaceIndex, depotName) + 1)

    -- update the UI's
    self.Gui:updateOpenedGuis(depotName)
  end
end



function Traindepot:setStationAmount(depotForceName, depotSurfaceIndex, depotName, newStationAmount)
  if newStationAmount > 0 then
    -- Make sure we can index it
    if not global.TD_data["depotStatistics"][depotForceName] then
      global.TD_data["depotStatistics"][depotForceName] = {}
    end
    if not global.TD_data["depotStatistics"][depotForceName][depotSurfaceIndex] then
      global.TD_data["depotStatistics"][depotForceName][depotSurfaceIndex] = {}
    end

    -- set the new data
    local depotData = global.TD_data["depotStatistics"][depotForceName][depotSurfaceIndex][depotName] or {}
    depotData["stationAmount"] = newStationAmount

    -- make sure the other data is within limits
    if (not depotData["requestAmount"]) or depotData["requestAmount"] < 0 then
      depotData["requestAmount"] = 1
    end
    if depotData["requestAmount"] > newStationAmount then
      depotData["requestAmount"] = newStationAmount
    end

    -- update the data
    global.TD_data["depotStatistics"][depotForceName][depotSurfaceIndex][depotName] = depotData

  else -- newStationAmount is 0, remove it
    global.TD_data["depotStatistics"][depotForceName][depotSurfaceIndex][depotName] = nil

    if LSlib.utils.table.isEmpty(global.TD_data["depotStatistics"][depotForceName][depotSurfaceIndex]) then
      global.TD_data["depotStatistics"][depotForceName][depotSurfaceIndex] = nil

      if LSlib.utils.table.isEmpty(global.TD_data["depotStatistics"][depotForceName]) then
        global.TD_data["depotStatistics"][depotForceName] = nil
      end
    end

  end
end

function Traindepot:setDepotRequestCount(depotForceName, depotSurfaceIndex, depotName, newStationRequestAmount)
  local depotData = self:getDepotData(depotForceName, depotSurfaceIndex)[depotName]
  if not depotData then return end

  if newStationRequestAmount > depotData["stationAmount"] then
    depotData["requestAmount"] = depotData["stationAmount"]
  elseif newStationRequestAmount < 0 then
    depotData["requestAmount"] = 0
  else
    depotData["requestAmount"] = newStationRequestAmount
  end

  -- update the data
  global.TD_data["depotStatistics"][depotForceName][depotSurfaceIndex][depotName] = depotData
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Traindepot:getDepotEntityName()
  return global.TD_data["prototypeData"]["traindepotName"]
end



function Traindepot:getDepotItemName()
  return global.TD_data["prototypeData"]["traindepotName"]
end



function Traindepot:hasDepotEntities(depotForceName, depotSurfaceIndex)
  -- returns true if at least one depot has been build on the force on that surface
  if global.TD_data["depotStatistics"][depotForceName]                    and
     global.TD_data["depotStatistics"][depotForceName][depotSurfaceIndex] then
    return not LSlib.utils.table.isEmpty(global.TD_data["depotStatistics"][depotForceName][depotSurfaceIndex])
  end
  return false
end



function Traindepot:getDepotData(depotForceName, depotSurfaceIndex)
  if self:hasDepotEntities(depotForceName, depotSurfaceIndex) then
    return global.TD_data["depotStatistics"][depotForceName][depotSurfaceIndex]
  else
    return {}
  end
end



function Traindepot:getDepotStationCount(depotForceName, depotSurfaceIndex, depotName)
  return (self:getDepotData(depotForceName, depotSurfaceIndex)[depotName] or {})["stationAmount"] or 0
end



function Traindepot:getDepotRequestCount(depotForceName, depotSurfaceIndex, depotName)
  return (self:getDepotData(depotForceName, depotSurfaceIndex)[depotName] or {})["requestAmount"] or 0
end



function Traindepot:getAllTrainsPathingToDepot(depotSurfaceIndex, depotName)
  -- index all depots on this surface, we need to find one depot with the given name
  for depotPositionY,depotPositionList in pairs(global.TD_data["depots"][depotSurfaceIndex]) do
    for depotPositionX,depotEntityData in pairs(depotPositionList) do

      -- check if a depot has the correct name
      if depotEntityData.entity.backer_name == depotName then
        return depotEntityData.entity.get_train_stop_trains()
      end

    end
  end

  -- none found, just return nil
  return nil
end


function Traindepot:getNumberOfTrainsPathingToDepot(depotSurfaceIndex, depotName)
  -- obtain a list with all the trains
  local depotTrains = self:getAllTrainsPathingToDepot(depotSurfaceIndex, depotName) or {}

  -- check schedule of each train
  local trainAmountPathingToDepot = 0
  for _,trainWithDepotSchedule in pairs(depotTrains) do
    local trainSchedule = trainWithDepotSchedule.schedule
    local currentActiveSchedule = trainSchedule.records[trainSchedule.current]
    if currentActiveSchedule.station == depotName then
      trainAmountPathingToDepot = trainAmountPathingToDepot + 1
    end
  end

  return trainAmountPathingToDepot
end



function Traindepot:getNumberOfTrainsStoppedInDepot(depotSurfaceIndex, depotName)
  -- returns amount of stations that are currently occupied
  local amount = 0
  for depotPositionY,depotPositionList in pairs(global.TD_data["depots"][depotSurfaceIndex]) do
    for depotPositionX,depotEntityData in pairs(depotPositionList) do
      local depotEntity = depotEntityData.entity
      if depotEntity.backer_name == depotName and depotEntity.get_stopped_train() then
        amount = amount + 1
      end
    end
  end
  return amount
end



function Traindepot:getTrainBuilderCount(depotForceName, depotSurfaceIndex, depotName)
  local controllerForceName = Traincontroller:getControllerForceName(depotForceName)
  return Traincontroller:getTrainBuilderCount(controllerForceName, depotSurfaceIndex, depotName)
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
