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


data:extend(
{
  {
    type = "technology",
    name = "trainfuel-solid-fuel",
    localised_name = {"technology-name.trainfuel-solid-fuel"},
    icon_size = 128,
    icon = "__trainConstructionSite__/graphics/placeholders/2x2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trainassembly-trainfuel-solid-fuel",
      },
    },
    prerequisites = {"railway", "oil-processing", "trainassembly-trainTechnology"},
    unit =
    {
      count = 75,
      ingredients = util.table.deepcopy(data.raw["technology"]["military-2"].unit.ingredients),
      time = 5,
    },
    order = "c-g-a-b",
  },
  {
    type = "technology",
    name = "trainfuel-rocket-fuel",
    localised_name = {"technology-name.trainfuel-solid-fuel"},
    icon_size = 128,
    icon = "__trainConstructionSite__/graphics/placeholders/2x2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trainassembly-trainfuel-rocket-fuel",
      },
    },
    prerequisites = {"trainfuel-solid-fuel", "rocket-silo"},
    unit =
    {
      count = 75,
      ingredients = util.table.deepcopy(data.raw["technology"]["automation-3"].unit.ingredients),

      time = 30,
    },
    order = "c-g-a-c",
  },
  {
    type = "technology",
    name = "trainfuel-nuclear-fuel",
    localised_name = {"technology-name.trainfuel-nuclear-fuel"},
    icon_size = 128,
    icon = "__trainConstructionSite__/graphics/placeholders/2x2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trainassembly-trainfuel-nuclear-fuel",
      },
    },
    prerequisites = {"trainfuel-rocket-fuel", "kovarex-enrichment-process"},
    unit =
    {
      count = 500,
      ingredients = util.table.deepcopy(data.raw["technology"]["kovarex-enrichment-process"].unit.ingredients),
      time = 60,
    },
    order = "c-g-a-d",
  },
})
