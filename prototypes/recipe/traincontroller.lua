data:extend{
  {
    type = "recipe",
    name = "traincontroller",
    normal =
    {
      enabled = false,
      energy_required = 1,
      ingredients =
      {
        {"rail-signal", 1},
        {"decider-combinator", 3},
        {"arithmetic-combinator", 1},
        {"programmable-speaker", 2},
      },
      results =
      {
        {
          type    = "item",
          name    = "traincontroller",
          amount  = 1,
        },
      },
    },
    expensive = nil,
  }
}
