-------------------------------------------------------------------------------
-- removing trainfuel from the electric trains --------------------------------
-------------------------------------------------------------------------------
require "modding-interface"
local trainfuel = "trainassembly-recipefuel"
local itemOrder = require("prototypes/modded-trains-ordening")

if mods["Realistic_Electric_Trains"] then
  trainConstructionSite.remote.addElectricTrain("locomotive", "ret-electric-locomotive"    )
  trainConstructionSite.remote.addElectricTrain("locomotive", "ret-electric-locomotive-mk2")
  trainConstructionSite.remote.addElectricTrain("locomotive", "ret-modular-locomotive"     )
end

if mods["Electronic_Locomotives"] then
  trainConstructionSite.remote.addElectricTrain("locomotive", "Electronic-Standard-Locomotive")
  trainConstructionSite.remote.addElectricTrain("locomotive", "Electronic-Cargo-Locomotive"   )
end

if mods["Electronic_Factorio_Extended_Locomotives"] then
  trainConstructionSite.remote.addElectricTrain("locomotive", "electronic-locomotive-mk2")
  trainConstructionSite.remote.addElectricTrain("locomotive", "electronic-locomotive-mk3")
end

if mods["Electronic_Angels_Locomotives"] then
  if mods["angelsaddons-crawlertrain"] or (mods["angelsaddons-mobility"] and angelsmods.addons.mobility.crawlertrain.enabled) then
    local loconame = "electronic-crawler-locomotive"
    local locowagonname = "electronic-crawler-locomotive-wagon"

    local tier_amount = (mods["angelsaddons-crawlertrain"] and angelsmods.addons.crawlertrain.tier_amount) or
                        (mods["angelsaddons-mobility"] and angelsmods.addons.mobility.crawlertrain.tier_amount)
    for i = 1, tier_amount do
      if i == 1 then
        trainConstructionSite.remote.addElectricTrain("locomotive", loconame)
        trainConstructionSite.remote.addElectricTrain("locomotive", locowagonname)
      else
        trainConstructionSite.remote.addElectricTrain("locomotive", loconame.."-"..i)
        trainConstructionSite.remote.addElectricTrain("locomotive", locowagonname.."-"..i)
      end
    end
  end

  if mods["angelsaddons-petrotrain"] or (mods["angelsaddons-mobility"] and angelsmods.addons.mobility.petrotrain.enabled) then
    local loconame = "electronic-petro-locomotive-1"

    local tier_amount = (mods["angelsaddons-petrotrain"] and angelsmods.addons.petrotrain.tier_amount) or
                        (mods["angelsaddons-mobility"] and angelsmods.addons.mobility.petrotrain.tier_amount)
    for i = 1, tier_amount do
      if i == 1 then
        trainConstructionSite.remote.addElectricTrain("locomotive", loconame)
      else
        trainConstructionSite.remote.addElectricTrain("locomotive", loconame.."-"..i)
      end
    end
  end

  if mods["angelsaddons-smeltingtrain"] or (mods["angelsaddons-mobility"] and angelsmods.addons.mobility.smeltingtrain.enabled) then
    local loconame = "electronic-smelting-locomotive-1"
    local locowagonname = "electronic-smelting-locomotive-tender"

    local tier_amount = (mods["angelsaddons-smeltingtrain"] and angelsmods.addons.smeltingtrain.tier_amount) or
                        (mods["angelsaddons-mobility"] and angelsmods.addons.mobility.smeltingtrain.tier_amount)
    for i = 1, tier_amount do
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

if mods["ElectricTrain"] then
  trainConstructionSite.remote.addElectricTrain("locomotive", "et-electric-locomotive-1")
  trainConstructionSite.remote.addElectricTrain("locomotive", "et-electric-locomotive-2")
  trainConstructionSite.remote.addElectricTrain("locomotive", "et-electric-locomotive-3")
end

if mods["pyhightech"] then
  trainConstructionSite.remote.addCustomFuelTrain("locomotive", "ht-locomotive", "nexelit-battery")
end

for trainType,trainData in pairs(trainConstructionSite.remoteData.electricTrains or {}) do
  for trainName,_ in pairs(trainData or {}) do
    LSlib.recipe.removeIngredient(trainName.."-fluid["..trainType.."]", trainfuel)
  end
end

for trainType,trainData in pairs(trainConstructionSite.remoteData.customFuelTrains or {}) do
  for trainName,customFuelName in pairs(trainData or {}) do
    LSlib.recipe.removeIngredient(trainName.."-fluid["..trainType.."]", trainfuel)
    LSlib.recipe.addIngredient(trainName.."-fluid["..trainType.."]", customFuelName)
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
  -- industires overhaul changes the location of the base game subgroup
  data.raw["item-subgroup"]["transport"].group = "transport-logistics"
  data.raw["item-subgroup"]["transport"].order = "d"

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

if mods["Krastorio2"] then
  -- nuclear locomotive technology is not available in data update stage, custom fixing it here
  LSlib.technology.addRecipeUnlock("kr-nuclear-locomotive", "kr-nuclear-locomotive-fluid[locomotive]")
  LSlib.recipe.disable("kr-nuclear-locomotive-fluid[locomotive]")
end

if mods["space-exploration"] then
  -- space exploration moves the base game locomotives around... fixing it here
  for _, trainData in pairs{
    {"locomotive", "locomotive"},
    {"cargo-wagon", "cargo-wagon"},
    {"fluid-wagon", "fluid-wagon"},
    {"artillery-wagon", "artillery-wagon"}
  } do
    if itemOrder[trainData[1] or ""] and itemOrder[trainData[1] or ""][trainData[2] or ""] then
      LSlib.item.setSubgroup("item-with-entity-data", trainData[2] or "", "transport")
      LSlib.item.setOrderstring("item-with-entity-data", trainData[2] or "", itemOrder[trainData[1] or ""][trainData[2] or ""])
    end
  end

  -- space exploration moves rail stuff around... fixing it here
  LSlib.item.setSubgroup("rail-planner", "rail", "transport-railway")
  LSlib.item.setOrderstring("rail-planner", "rail", "a[rail]-a[stone]")
  LSlib.item.setSubgroup("rail-planner", "se-space-rail", "transport-railway")
  LSlib.item.setOrderstring("rail-planner", "se-space-rail", "a[rail]-b[space]")

  LSlib.item.setSubgroup("item", "train-stop", "transport-railway")
  LSlib.item.setOrderstring("item", "train-stop", "b[stop]-a[regular]")

  LSlib.item.setSubgroup("item", "rail-signal", "transport-railway")
  LSlib.item.setOrderstring("item", "rail-signal", "c[signal]-a[rail]")
  LSlib.item.setSubgroup("item", "rail-chain-signal", "transport-railway")
  LSlib.item.setOrderstring("item", "rail-chain-signal", "c[signal]-b[chain]")
end

  -- Cargo ships change the order to fit in Transport Logistics instead of Logistics

if mods ["cargo-ships"] then
  local subgroup = data.raw["item-subgroup"]["water_transport"]
  if subgroup then
    subgroup.group = "transport-logistics"
    subgroup.order = "i[water]"
  end
end
