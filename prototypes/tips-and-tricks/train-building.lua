data:extend(
  {
    {
      type = "tips-and-tricks-item",
      name = "TCS-train-building",
      tag = "[item=locomotive]",
      localised_name = {"tips-and-tricks-item-name.TCS-train-building"},
      localised_description = {"",
        {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.TCS-introduction-1-h"}},
        {"tips-and-tricks-item-description.TCS-introduction-1-1", {"tips-and-tricks-item-description.TCS-introduction-1-1-a"}},--todo 1-1-b
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.TCS-introduction-1-2"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.TCS-introduction-1-3"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.TCS-introduction-1-4"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.TCS-introduction-1-5"}},
      },
      category = "trains",
      indent = 2,
      order = "bx-tcs[introduction]",
      trigger =
      {
        type = "build-entity",
        entity = "straight-rail",
        count = 3
      },
      dependencies = {"rail-building"},
      --tutorial = "trains-advanced-signals",
      simulation = {
        init =
        [[
          --todo
        ]]
      }
    }   
  }
)
