require 'util'

for fuelOrder, fuelIngredient in pairs ({
  {"raw-wood", 100},
  {"coal", 50},
  {"solid-fuel", 50},
  {"rocket-fuel", 10},
  {"nuclear-fuel", 1},
}) do

  data:extend({
    {
      type = "recipe",
      name = "trainassembly-trainfuel-" .. fuelIngredient[1],
      expensive = nil,
      normal =
      {
        enabled = true,
        energy_required = 5,
        ingredients =
        {
          util.table.deepcopy(fuelIngredient),
        },
        result = "trainassembly-trainfuel",
      },
      order = "a-"..fuelOrder,
    }
  })
end
