require("__LSlib__/LSlib")

trainConstructionSite = trainConstructionSite or {}
trainConstructionSite.remote = trainConstructionSite.remote or {}
trainConstructionSite.remoteData = trainConstructionSite.remoteData or {}

trainConstructionSite.remote.addElectricTrain = function(entityType, entityName)
  -- Register a train to not use fuel. This means it won't add fuel when creating the trains
  -- The main usage for this will probably be electric trains...
  --
  -- Arguments:
  --     - entityType: type of the entity (for example "locomotive")
  --     - entityName: name of the entity (for example "electric-locomotive")
  --
  -- Timing:
  --     - Registering a train needs to be done before __trainConstructionSite__/data-final-fixes.lua
  --
  -- Example:
  --     - trainConstructionSite.remote.addElectricTrain("locomotive", "electric-locomotive")

  trainConstructionSite.remoteData.electricTrains =
    trainConstructionSite.remoteData.electricTrains or {}
  trainConstructionSite.remoteData.electricTrains[entityType] =
    trainConstructionSite.remoteData.electricTrains[entityType] or {}

  trainConstructionSite.remoteData.electricTrains[entityType][entityName] = true
end
