require 'util'

-- We want to create different fuel recipes to create the fuel to initialy fuel the train.
-- We make a fuel for each of the next items:
for fuelOrder, fuelIngredient in pairs ({
  {"raw-wood", 100},
  {"coal", 50},
  {"solid-fuel", 50},
  {"rocket-fuel", 10},
  {"nuclear-fuel", 1},
}) do

  -- For this item we create a fuel recipe
  data:extend({
    {
      type = "recipe",
      name = "trainassembly-trainfuel-" .. fuelIngredient[1],
      localised_name = {"recipe-name.trainfuel", "trainassemblyfuel", fuelIngredient[1]},
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
        result = "trainassembly-trainfuel",
      },

      -- We have to add a order string to the recipe becose we have multiple
      -- recipes resulting in the same item.
      order = "a-"..fuelOrder,
    }
  })
end
