data:extend(
  {
    {
      type = "tips-and-tricks-item",
      name = "traincontroller",
      tag = "[item=traincontroller]",
      localised_name = {"item-name.traincontroller", {"item-name.trainassembly"}},
      localised_description = {"",
        {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.traincontroller-1-h"}},
        {"tips-and-tricks-item-description.traincontroller-1-1"},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traincontroller-1-2"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.traincontroller-2-h"}}},
        {"tips-and-tricks-item-description.traincontroller-2-1"},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traincontroller-2-2"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traincontroller-2-3"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traincontroller-2-4"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.traincontroller-3-h"}}},
        {"tips-and-tricks-item-description.traincontroller-3-1"},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traincontroller-3-2"}},
      },
      category = "trains",
      indent = 2,
      order = "cx-tcs[trainbuilder]-c",
      trigger =
      {
        type = "research",
        technology = "trainassembly-automated-train-assembling"
      },
      dependencies = {"trainassembly"},
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
