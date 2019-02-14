require "util"

local trainTech = util.table.deepcopy(data.raw["technology"]["railway"])

trainTech.name = "trainassembly-automated-train-assembling"
trainTech.effects = {}
trainTech.localised_name = {"technology-name.trainTech"}
trainTech.localised_description = {"technology-description.trainTech"}
trainTech.prerequisites = {"railway", "engine", "logistics-2"}

data:extend{ -- add train technology to tech tree
  trainTech,
}

for _, trainRecipe in pairs ({
  "locomotive",
  "cargo-wagon",
}) do
  table.insert(trainTech.effects,
  {
    type = "unlock-recipe",
    recipe = trainRecipe,
  })
  table.insert(trainTech.effects,
  {
    type = "unlock-recipe",
    recipe = trainRecipe .. "-fluid[" .. trainRecipe .. "]",
  })
end

for techName, techPrototype in pairs(data.raw["technology"]) do
  if techPrototype.effects then
    for techEffectIndex, techEffect in pairs(techPrototype.effects) do
      if techEffect.type == "unlock-recipe" then
        for _, wagonName in pairs({
          "fluid-wagon",
          "artillery-wagon",
        }) do
          if techEffect.recipe == wagonName then
            table.insert(data.raw["technology"][techName].effects, techEffectIndex + 1,
            {
              type = "unlock-recipe",
              recipe = wagonName .. "-fluid[" .. wagonName .. "]",
            })
          end
        end
      end
    end
  end
end

if data.raw["technology"]["railway"].prerequisites then
  for prerequisitesIndex, prerequisite in pairs(data.raw["technology"]["railway"].prerequisites) do
    if prerequisite == "engine" then
      data.raw["technology"]["railway"].prerequisites[prerequisitesIndex] = nil
    else
      if prerequisite == "logistics-2" then
        data.raw["technology"]["railway"].prerequisites[prerequisitesIndex] = "logistics"
      end
    end
  end
end

for _, prerequisitesName in pairs{
  "automation-2",
  "steel-processing",
} do
  table.insert(data.raw["technology"]["railway"].prerequisites, prerequisitesName)
end

if data.raw["technology"]["railway"].effects then
  for effectIndex, effect in pairs(data.raw["technology"]["railway"].effects) do
    if effect.type == "unlock-recipe" and effect.recipe == "cargo-wagon" then
      data.raw["technology"]["railway"].effects[effectIndex] = nil -- this removes that single unlock
    end
  end

else
  data.raw["technology"]["railway"].effects = {}
end

for _, recipeName in pairs{
  "trainassembly",
} do
  table.insert(data.raw["technology"]["trainassembly-automated-train-assembling"].effects,
  {
    type = "unlock-recipe",
    recipe = recipeName,
  })
end
