
--making the cargo wagon technology and unlocking the wagon parts and fluid

local trainTechCargo = util.table.deepcopy(data.raw["technology"]["fluid-wagon"])

trainTechCargo.name = "trainassembly-cargo-wagon"
trainTechCargo.localised_name = {"technology-name.trainassembly-cargo-wagon"}
trainTechCargo.localised_description = {"technology-description.trainassembly-cargo-wagon"}

trainTechCargo.icon = "__trainConstructionSite__/graphics/technology/cargo-wagon.png"
trainTechCargo.icon_size = 128

trainTechCargo.prerequisites = {"trainassembly-automated-train-assembling", "logistics-2"}
if data.raw["technology"]["railway"].prerequisites then -- replace logistics-2 from railway in logistics-1
  for prerequisitesIndex, prerequisite in pairs(data.raw["technology"]["railway"].prerequisites) do
    if prerequisite == "logistics-2" then
      data.raw["technology"]["railway"].prerequisites[prerequisitesIndex] = "logistics"
    end
  end
end

trainTechCargo.effects = {}
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



--making the artillery wagon technology and unlocking the wagon parts and fluid

local trainTechArty = util.table.deepcopy(data.raw["technology"]["artillery"])

trainTechArty.name = "trainassembly-artillery-wagon"
trainTechArty.localised_name = {"technology-name.trainassembly-artillery-wagon"}
trainTechArty.localised_description = {"technology-description.trainassembly-artillery-wagon"}

trainTechArty.icon = "__trainConstructionSite__/graphics/technology/artillery-wagon_-_scaled.png"
trainTechArty.icon_size = 256

trainTechArty.prerequisites = {"trainassembly-cargo-wagon", "artillery"}

trainTechArty.effects = {}
for _, trainRecipe in pairs ({
  "artillery-wagon",
}) do
  table.insert(trainTechArty.effects,
  {
    type = "unlock-recipe",
    recipe = trainRecipe,
  })
  table.insert(trainTechArty.effects,
  {
    type = "unlock-recipe",
    recipe = trainRecipe .. "-fluid[" .. trainRecipe .. "]",
  })
end



--making the locomotive fuel tech

for _, trainRecipe in pairs ({
  "locomotive",
}) do
  table.insert(data.raw["technology"]["trainassembly-automated-train-assembling"].effects,
  {
    type = "unlock-recipe",
    recipe = trainRecipe .. "-fluid[" .. trainRecipe .. "]",
  })
end


--Unlocking locomotive manual build in the railway techtree

for _, trainRecipe in pairs ({
  "locomotive-manual-build",
}) do
  table.insert(data.raw["technology"]["railway"].effects,
  {
    type = "unlock-recipe",
    recipe = trainRecipe,
  })
end



--making the fluid tech for fluid wagon

for techName, techPrototype in pairs(data.raw["technology"]) do
  if techPrototype.effects then
    for techEffectIndex, techEffect in pairs(techPrototype.effects) do
      if techEffect.type == "unlock-recipe" then
        for _, wagonName in pairs({
          "fluid-wagon",
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



if data.raw["technology"]["artillery"].effects then
  for effectIndex, effect in pairs(data.raw["technology"]["artillery"].effects) do
    if effect.type == "unlock-recipe" and effect.recipe == "artillery-wagon" then
      data.raw["technology"]["artillery"].effects[effectIndex] = nil -- this removes that single unlock
    end
  end
end



if data.raw["technology"]["fluid-wagon"].prerequisites then
  for prerequisitesIndex, prerequisite in pairs(data.raw["technology"]["fluid-wagon"].prerequisites) do
    if prerequisite == "railway" then
      data.raw["technology"]["fluid-wagon"].prerequisites[prerequisitesIndex] = "trainassembly-cargo-wagon"
    end
  end
end



data:extend{ -- add train technology to tech tree
  trainTechCargo,
  trainTechArty,
}
