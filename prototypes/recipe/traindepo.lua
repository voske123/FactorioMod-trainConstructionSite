data:extend{
  {
    type = "recipe",
    name = "traindepo",
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
          name    = "traindepo",
          amount  = 1,
        },
      },
    },
  }
}
