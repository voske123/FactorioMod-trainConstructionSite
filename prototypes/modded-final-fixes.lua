-- removing trainfuel from the electric trains
require "modding-interface"
local trainfuel = "trainassembly-recipefuel"

if mods["Realistic_Electric_Trains"] then
  trainConstructionSite.remote.addElectricTrain("locomotive", "ret-electric-locomotive"    )
  trainConstructionSite.remote.addElectricTrain("locomotive", "ret-electric-locomotive-mk2")
  trainConstructionSite.remote.addElectricTrain("locomotive", "ret-modular-locomotive"     )
end

if mods["Electronic_Locomotives"] then
  trainConstructionSite.remote.addElectricTrain("locomotive", "Senpais-Electric-Train"      )
  trainConstructionSite.remote.addElectricTrain("locomotive", "Senpais-Electric-Train-Heavy")
end

if mods["Electronic_Battle_Locomotives"] then
  trainConstructionSite.remote.addElectricTrain("locomotive", "Elec-Battle-Loco-1")
  trainConstructionSite.remote.addElectricTrain("locomotive", "Elec-Battle-Loco-2")
  trainConstructionSite.remote.addElectricTrain("locomotive", "Elec-Battle-Loco-3")
end

for trainType,trainData in pairs(trainConstructionSite.remoteData.electricTrains or {}) do
  for trainName,_ in pairs(trainData or {}) do
    LSlib.recipe.removeIngredient(trainName.."-fluid["..trainType.."]", trainfuel)
  end
end

-- Other changes
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
