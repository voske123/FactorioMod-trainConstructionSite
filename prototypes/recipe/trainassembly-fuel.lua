require 'util'

local function createRecipeIcons(itemPrototypeName)
  local function getItemIcons(itemPrototypeName, layerScale, layerShift)
    local itemIcon = data.raw["item"][itemPrototypeName].icon

    if itemIcon then
      return { -- icons table
        { -- single layer
          ["icon"     ] = itemIcon,
          ["icon_size"] = data.raw["item"][itemPrototypeName].icon_size,
          ["scale"    ] = layerScale,
          ["shift"    ] = layerShift,
        }
      }
    else

      local itemIconSize = data.raw["item"][itemPrototypeName].icon_size

      local itemIcons = {}
      for iconLayerIndex, iconLayer in pairs(data.raw["item"][itemPrototypeName].icons) do
        itemIcons[iconLayerIndex] = {
          ["icon"     ] = iconLayer.icon,
          ["icon_size"] = iconLayer.icon_size or itemIconSize, -- itemIconSize if not icon_size specified in layer
          ["tint"     ] = iconLayer.tint,
          ["scale"    ] = (iconLayer.scale or 1) * layerScale,
          ["shift"    ] = {
            (iconLayer.shift or {0, 0})[1] * layerShift[1],
            (iconLayer.shift or {0, 0})[2] * layerShift[2],
          },
        }
      end
      return itemIcons

    end
  end

  local recipeIcons = util.table.deepcopy(getItemIcons("trainassembly-recipefuel", 1, {0,0}))
  local recipeIconsLength = #recipeIcons

  for layerIndex,layerData in pairs(getItemIcons(itemPrototypeName, 0.48, {9, -9})) do
    recipeIcons[recipeIconsLength + layerIndex] = layerData
  end
  return recipeIcons
end

-- We want to create different fuel recipes to create the fuel to initialy fuel the train.
-- We make a fuel for each of the next items:
for fuelOrder, fuelIngredient in pairs ({
  {"raw-wood", 100  },
  {"coal", 50       },
  {"solid-fuel", 50 },
  {"rocket-fuel", 10},
  {"nuclear-fuel", 1},
}) do

  -- For this item we create a fuel recipe
  data:extend{
    {
      type = "recipe",
      name = "trainassembly-trainfuel-" .. fuelIngredient[1],
      localised_name = {"recipe-name.trainfuel", "trainassemblyfuel", fuelIngredient[1]},
      icons = createRecipeIcons(fuelIngredient[1]),
      category = "advanced-crafting",
      expensive = nil,
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

      -- We have to add a order string to the recipe becose we have multiple
      -- recipes resulting in the same item.
      order = "a-"..fuelOrder,
    }
  }
end
