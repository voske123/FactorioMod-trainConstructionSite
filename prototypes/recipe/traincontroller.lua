data:extend({
  {
    type = "recipe",
    name = "traincontroller",
    normal =
    {
      enabled = true,
      energy_required = 1,
      ingredients =
      {
        {"train-stop", 1},
        {"decider-combinator", 3},
        {"iron-chest", 1}
      },
      expensive = nil,
      results =
      {
        {
          type    = "item",
          name    = "traincontroller",
          amount  = 1,
        },
      },
    },
  }
})
