require("__LSlib__/LSlib")

local function createRecipeIcons(itemPrototypeName)
  local recipeIcons = LSlib.item.getIcons("item", "trainassembly-recipefuel")
  local recipeIconsLength = #recipeIcons -- number of layers to offset the existing layers

  local extraScale = recipeIcons[1].icon_size / LSlib.item.getIconSize("item", itemPrototypeName)[1]
  for layerIndex,layerData in pairs(LSlib.item.getIcons("item", itemPrototypeName, 0.4 * extraScale, {-20, 19})) do
    recipeIcons[recipeIconsLength + layerIndex] = layerData -- add layer to recipelayer
  end
  return recipeIcons
end

-- We want to create different fuel recipes to create the fuel to initialy fuel the train.
-- We make a fuel for each of the next items:
for fuelOrder, fuelIngredient in pairs{
  {"wood"        , 100},
  {"coal"        , 50 },
  {"solid-fuel"  , 50 },
  {"rocket-fuel" , 10 },
  {"nuclear-fuel", 1  },
} do

  -- For this item we create a fuel recipe
  data:extend{
    {
      type = "recipe",
      name = "trainassembly-trainfuel-" .. fuelIngredient[1],
      localised_name = {"recipe-name.trainfuel", "trainassemblyfuel", fuelIngredient[1]},
      icons     = createRecipeIcons(fuelIngredient[1]), -- create recipe icons with different layers
      icon      = nil, -- becose icons is present, no icon      required
      icon_size = nil, -- becose icons is present, no icon_size required

      category = "advanced-crafting",
      normal =
      {
        enabled = false,
        energy_required = 5,
        ingredients =
        {
          util.table.deepcopy(fuelIngredient),
        },
        result = "trainassembly-recipefuel",
      },
      expensive = nil, -- same as normal

      -- We have to add a order string to the recipe becose we have multiple
      -- recipes resulting in the same item.
      order = "a-"..fuelOrder,
    }
  }
end
