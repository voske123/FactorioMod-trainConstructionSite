require "util"

local trainTech = util.table.deepcopy(data.raw["technology"]["railway"])

  trainTech.name = "trainassembly-trainTechnology"
  trainTech.effects = {}
  trainTech.localised_name = {"technology-name.trainTech"}
  trainTech.localised_description = {"technology-description.trainTech"}

  data:extend({
    trainTech,
  })

for _, trainTechn in pairs ({
  "locomotive",
  "cargo-wagon",
}) do
  table.insert(data.raw["technology"][trainTech.name].effects,
  {
    type = "unlock-recipe",
    recipe = trainTechn,
  })
end



if data.raw["technology"]["railway"].effects then
  for effectIndex, effect in pairs(data.raw["technology"]["railway"].effects) do
    if effect.type == "unlock-recipe"
    and (effect.recipe == "locomotive" or effect.recipe == "cargo-wagon") then
      data.raw["technology"]["railway"].effects[effectIndex] = nil -- this removes that single unlock
    end
  end

else
  data.raw["technology"]["railway"].effects = {}
end

for _, fuelIngredient in pairs ({
  "raw-wood",
  "coal",
}) do
  table.insert(data.raw["technology"]["railway"].effects,
  {
    type = "unlock-recipe",
    recipe = "trainassembly-trainfuel-" .. fuelIngredient,
  })
end

table.insert(data.raw["technology"]["railway"].effects,
{
  type = "unlock-recipe",
  recipe = "trainassembly",
})
