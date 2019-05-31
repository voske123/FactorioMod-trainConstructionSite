data:extend{
  {
    type = "recipe",
    name = "traindepot",
    normal =
    {
      enabled = false,
      energy_required = 1,
      ingredients =
      {
        {"train-stop", 1},
        {"small-lamp", 3},
        {"programmable-speaker", 1},
      },
      expensive = nil,
      results =
      {
        {
          type    = "item",
          name    = "traindepot",
          amount  = 1,
        },
      },
    },
  }
}
