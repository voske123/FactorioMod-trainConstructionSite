require "util"



local trainTechCargo = util.table.deepcopy(data.raw["technology"]["railway"])

trainTechCargo.name = "trainassembly-cargo-wagon"
trainTechCargo.effects = {}
trainTechCargo.localised_name = {"technology-name.trainassembly-cargo-wagon"}
trainTechCargo.localised_description = {"technology-description.trainassembly-cargo-wagon"}
trainTechCargo.prerequisites = {"trainassembly-automated-train-assembling"}

data:extend{ -- add train technology to tech tree
  trainTechCargo,
}



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
