require "util"



local trainTechCargo = util.table.deepcopy(data.raw["technology"]["railway"])

trainTechCargo.name = "trainassembly-cargo-wagon"
trainTechCargo.effects = {}
trainTechCargo.localised_name = {"technology-name.trainassembly-cargo-wagon"}
trainTechCargo.localised_description = {"technology-description.trainassembly-cargo-wagon"}
trainTechCargo.prerequisites = {"trainassembly-automated-train-assembling"}




for _, trainRecipe in pairs ({
  "cargo-wagon",
}) do
  table.insert(trainTechCargo.effects,
  {
    type = "unlock-recipe",
    recipe = trainRecipe,
  })
  table.insert(trainTechCargo.effects,
  {
    type = "unlock-recipe",
    recipe = trainRecipe .. "-fluid[" .. trainRecipe .. "]",
  })
end



for _, trainRecipe in pairs ({
  "locomotive",
}) do
  table.insert(data.raw["technology"]["trainassembly-automated-train-assembling"].effects,
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



if data.raw["technology"]["railway"].effects then
  for effectIndex, effect in pairs(data.raw["technology"]["railway"].effects) do
    if effect.type == "unlock-recipe" and effect.recipe == "cargo-wagon" then
      data.raw["technology"]["railway"].effects[effectIndex] = nil -- this removes that single unlock
    end
  end
end



--if data.raw["technology"]["fluid-wagon"].prerequisites then
--  for prerequisitesIndex, prerequisite in pairs(data.raw["technology"]["fluid-wagon"].prerequisites) do
--    if prerequisite == "railway" then
--      data.raw["technology"]["railway"].prerequisites[prerequisitesIndex] = "trainassembly-cargo-wagon"
--    end
--  end
--end



data:extend{ -- add train technology to tech tree
  trainTechCargo,
}
