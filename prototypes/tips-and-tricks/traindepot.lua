data:extend(
  {
    {
      type = "tips-and-tricks-item",
      name = "traindepot",
      localised_name = {"item-name.traindepot"},
      localised_description = {"",
        "TODO"
      },
      tag = "[item=trainassembly]",
      category = "trains",
      indent = 2,
      order = "cx-tcs[trainbuilder]",
      trigger =
      {
        type = "research",
        technology = "automated-rail-transportation"
      },
      dependencies = {"train-stops"},
      --tutorial = "trains-advanced-signals",
      --simulation = simulations.rail_signals_advanced
    },
  }
)