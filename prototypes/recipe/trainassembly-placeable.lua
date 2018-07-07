data:extend({
  {
    type = "recipe",
    name = "trainassembly",
    category = "trainassembling",
    normal =
    {
      enabled = true,
      energy_required = 30,
      ingredients =
      {
        {"fast-inserter", 10},
        {"assembling-machine-2", 2},
        {"rail", 50},
        {"electronic-circuit", 10}
      },
      expensive = nil,
      results =
      {
        {
          type    = "item",
          name    = "trainassembly",
          amount  = 1,
        },
      },
    },
  }
})
