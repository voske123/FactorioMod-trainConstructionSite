-------------------------------------------------------------------------------
-- removing trainfuel from the electric trains --------------------------------
-------------------------------------------------------------------------------
require "modding-interface"
local trainfuel = "trainassembly-recipefuel"

if mods["Realistic_Electric_Trains"] then
  trainConstructionSite.remote.addElectricTrain("locomotive", "ret-electric-locomotive"    )
  trainConstructionSite.remote.addElectricTrain("locomotive", "ret-electric-locomotive-mk2")
  trainConstructionSite.remote.addElectricTrain("locomotive", "ret-modular-locomotive"     )
end

if mods["Electronic_Locomotives"] then
  trainConstructionSite.remote.addElectricTrain("locomotive", "Electronic-Standard-Locomotive")
  trainConstructionSite.remote.addElectricTrain("locomotive", "Electronic-Cargo-Locomotive"   )
end

if mods["Electronic_Angels_Locomotives"] then
  if mods["angelsaddons-crawlertrain"] then
    local loconame = "electronic-crawler-locomotive"
    local locowagonname = "electronic-crawler-locomotive-wagon"

    for i = 1, angelsmods.addons.crawlertrain.tier_amount do
      if i == 1 then
        trainConstructionSite.remote.addElectricTrain("locomotive", loconame)
        trainConstructionSite.remote.addElectricTrain("locomotive", locowagonname)
      else
        trainConstructionSite.remote.addElectricTrain("locomotive", loconame.."-"..i)
        trainConstructionSite.remote.addElectricTrain("locomotive", locowagonname.."-"..i)
      end
    end
  end

  if mods["angelsaddons-petrotrain"] then
    local loconame = "electronic-petro-locomotive-1"

    for i = 1, angelsmods.addons.petrotrain.tier_amount do
      if i == 1 then
        trainConstructionSite.remote.addElectricTrain("locomotive", loconame)
      else
        trainConstructionSite.remote.addElectricTrain("locomotive", loconame.."-"..i)
      end
    end
  end

  if mods["angelsaddons-smeltingtrain"] then
    local loconame = "electronic-smelting-locomotive-1"
    local locowagonname = "electronic-smelting-locomotive-tender"

    for i = 1, angelsmods.addons.smeltingtrain.tier_amount do
      if i == 1 then
        trainConstructionSite.remote.addElectricTrain("locomotive", loconame)
        trainConstructionSite.remote.addElectricTrain("locomotive", locowagonname)
      else
        trainConstructionSite.remote.addElectricTrain("locomotive", loconame.."-"..i)
        trainConstructionSite.remote.addElectricTrain("locomotive", locowagonname.."-"..i)
      end
    end
  end
end

if mods["Electronic_Battle_Locomotives"] then
  trainConstructionSite.remote.addElectricTrain("locomotive", "Electronic-Battle-Locomotive-1")
  trainConstructionSite.remote.addElectricTrain("locomotive", "Electronic-Battle-Locomotive-2")
  trainConstructionSite.remote.addElectricTrain("locomotive", "Electronic-Battle-Locomotive-3")
end

for trainType,trainData in pairs(trainConstructionSite.remoteData.electricTrains or {}) do
  for trainName,_ in pairs(trainData or {}) do
    LSlib.recipe.removeIngredient(trainName.."-fluid["..trainType.."]", trainfuel)
  end
end

-------------------------------------------------------------------------------
-- Other changes --------------------------------------------------------------
-------------------------------------------------------------------------------
local trainOrdering = require("prototypes.modded-trains-ordening")
if mods["FARL"] then
    LSlib.technology.removePrerequisite("rail-signals", "trainassembly-automated-train-assembling")
    LSlib.technology.moveRecipeUnlock("rail-signals", "trainassembly-automated-train-assembling", "farl")
    LSlib.technology.addRecipeUnlock("trainassembly-automated-train-assembling", "farl-fluid[locomotive]")
end

if mods["TrainOverhaul"] then
  LSlib.technology.addRecipeUnlock("nuclear-locomotive", "nuclear-locomotive-fluid[locomotive]")
end

if mods["MultipleUnitTrainControl"] then
  for locomotive,_ in pairs(data.raw["locomotive"]) do
    if string.sub(locomotive, -3) == "-mu" then
      local recipe = data.raw["recipe"][locomotive]
      if recipe then recipe.allow_as_intermediate = false end

      local item = data.raw["item"][locomotive] or data.raw["item-with-entity-data"][locomotive]
      if item then LSlib.item.setHidden(item.type, locomotive) end
    end
  end
end

if mods["angelsindustries"] then
  -- industries overhaul changes the order and subgroup of the vanilla trains
  data.raw["item-with-entity-data"]["locomotive"].order = trainOrdering["locomotive"]["locomotive"]
  data.raw["item-with-entity-data"]["locomotive"].subgroup = "transport"
  data.raw["item-with-entity-data"]["cargo-wagon"].order = trainOrdering["cargo-wagon"]["cargo-wagon"]
  data.raw["item-with-entity-data"]["cargo-wagon"].subgroup = "transport"
  data.raw["item-with-entity-data"]["fluid-wagon"].order = trainOrdering["fluid-wagon"]["fluid-wagon"]
  data.raw["item-with-entity-data"]["fluid-wagon"].subgroup = "transport"
  data.raw["item-with-entity-data"]["artillery-wagon"].order = trainOrdering["artillery-wagon"]["artillery-wagon"]
  data.raw["item-with-entity-data"]["artillery-wagon"].subgroup = "transport"

  if settings.startup["angels-enable-tech"].value then
    LSlib.technology.removeIngredient("trainfuel-wood-pellets", "datacore-processing-1")
    LSlib.technology.removeIngredient("trainfuel-coal-crushed", "datacore-processing-1")
    LSlib.technology.removeIngredient("trainfuel-solid-coke", "datacore-processing-1")
    LSlib.technology.removeIngredient("trainfuel-solid-carbon", "datacore-processing-1")
    LSlib.technology.removeIngredient("trainfuel-wood-charcoal", "datacore-processing-1")
    LSlib.technology.removeIngredient("trainfuel-rocket-booster", "datacore-processing-1")
    LSlib.technology.removeIngredient("trainfuel-wood-bricks", "datacore-processing-1")
    LSlib.technology.removeIngredient("trainfuel-pellet-coke", "datacore-processing-1")
    LSlib.technology.addIngredient("trainfuel-rocket-booster", 1, "datacore-logistic-1")
  end
end
