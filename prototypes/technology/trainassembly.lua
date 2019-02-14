require "util"

local trainTechBuilder = util.table.deepcopy(data.raw["technology"]["railway"])

trainTechBuilder.name = "trainassembly-automated-train-assembling"
trainTechBuilder.effects = {}
trainTechBuilder.localised_name = {"technology-name.trainTechBuilder"}
trainTechBuilder.localised_description = {"technology-description.trainTechBuilder"}
trainTechBuilder.prerequisites = {"railway", "engine", "logistics-2"}

data:extend{ -- add train technology to tech tree
  trainTechBuilder,
}

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
