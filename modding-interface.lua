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

trainConstructionSite.remote.addCustomFuelTrain = function(entityType, entityName, customFuelName)
  -- Register a train to use a specific type of fuel, instead of trainfuel. This
  -- The main usage for this is modded trains that take only a specific type of fuel.
  --
  -- Arguments:
  --     - entityType: type of the entity (for example "locomotive")
  --     - entityName: name of the entity (for example "ht-locomotive")
  --     - customFuelName: name of the entity (for example "nexelit-battery")
  --
  -- Timing:
  --     - Registering a train needs to be done before __trainConstructionSite__/data-final-fixes.lua
  --
  -- Example:
  --     - trainConstructionSite.remote.addCustomFuelTrain("locomotive", "ht-locomotive", "nexelit-battery")

  trainConstructionSite.remoteData.customFuelTrains =
    trainConstructionSite.remoteData.customFuelTrains or {}
  trainConstructionSite.remoteData.customFuelTrains[entityType] =
    trainConstructionSite.remoteData.customFuelTrains[entityType] or {}

  trainConstructionSite.remoteData.customFuelTrains[entityType][entityName] = customFuelName
end