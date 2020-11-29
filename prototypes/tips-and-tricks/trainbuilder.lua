data:extend(
  {
    {
      type = "tips-and-tricks-item",
      name = "trainassembly",
      tag = "[item=trainassembly]",
      localised_name = {"item-name.trainassembly"},
      localised_description = {"",
        {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.trainassembly-1-h"}},
        {"tips-and-tricks-item-description.trainassembly-1-1"},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.trainassembly-2-h"}}},
        {"tips-and-tricks-item-description.trainassembly-2-1"},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.trainassembly-2-2"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.trainassembly-2-3"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.trainassembly-3-h"}}},
        {"tips-and-tricks-item-description.trainassembly-3-1"},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.trainassembly-3-2"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.trainassembly-3-3"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.trainassembly-3-4"}},
      },
      category = "trains",
      indent = 2,
      order = "cx-tcs[trainbuilder]-b",
      trigger =
      {
        type = "research",
        technology = "trainassembly-automated-train-assembling"
      },
      dependencies = {"traindepot"},
      --tutorial = "trains-advanced-signals",
      --simulation = {
      --  init =
      --  [[
      --
      --    --TODO
      --
      --  ]]
      --}
    }   
  }
)
