require "util"



for _, recipeName in pairs{
  "trainassembly-trainfuel-raw-wood",
} do
  table.insert(data.raw["technology"]["trainassembly-automated-train-assembling"].effects,
  {
    type = "unlock-recipe",
    recipe = recipeName,
  })
end



data:extend{ -- add fuel recipe to tech tree
  {
    type = "technology",
    name = "trainfuel-2",
    localised_name = {"technology-name.trainfuel", "trainassemblyfuel", "coal"},
    icon_size = 128,
    icon = "__trainConstructionSite__/graphics/placeholders/2x2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trainassembly-trainfuel-coal",
      },
    },
    prerequisites =
    {
      "trainassembly-automated-train-assembling",
    },
    unit =
    {
      count = 75,
      ingredients = util.table.deepcopy(data.raw["technology"]["railway"].unit.ingredients),
      time = 10,
    },
    order = "c-g-a-b",
  },
  {
    type = "technology",
    name = "trainfuel-3",
    localised_name = {"technology-name.trainfuel", "trainassemblyfuel", "solid-fuel"},
    icon_size = 128,
    icon = "__trainConstructionSite__/graphics/placeholders/2x2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trainassembly-trainfuel-solid-fuel",
      },
    },
    prerequisites =
    {
      "trainfuel-2",
      "oil-processing",
    },
    unit =
    {
      count = 100,
      ingredients = util.table.deepcopy(data.raw["technology"]["oil-processing"].unit.ingredients),
      time = 10,
    },
    order = "c-g-a-c",
  },
  {
    type = "technology",
    name = "trainfuel-4",
    localised_name = {"technology-name.trainfuel", "trainassemblyfuel", "rocket-fuel"},
    icon_size = 128,
    icon = "__trainConstructionSite__/graphics/placeholders/2x2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trainassembly-trainfuel-rocket-fuel",
      },
    },
    prerequisites =
    {
      "trainfuel-3",
      "rocket-silo",
    },
    unit =
    {
      count = 75,
      ingredients = util.table.deepcopy(data.raw["technology"]["automation-3"].unit.ingredients),

      time = 30,
    },
    order = "c-g-a-d",
  },
  {
    type = "technology",
    name = "trainfuel-5",
    localised_name = {"technology-name.trainfuel", "trainassemblyfuel", "nuclear-fuel"},
    icon_size = 128,
    icon = "__trainConstructionSite__/graphics/placeholders/2x2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trainassembly-trainfuel-nuclear-fuel",
      },
    },
    prerequisites =
    {
      "trainfuel-4",
      "kovarex-enrichment-process",
    },
    unit =
    {
      count = 500,
      ingredients = util.table.deepcopy(data.raw["technology"]["kovarex-enrichment-process"].unit.ingredients),
      time = 60,
    },
    order = "c-g-a-e",
  },
}
