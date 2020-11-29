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
      simulation = {
        init =
        [[
          game.camera_position = {0.5, 0}
          game.camera_zoom = 1
          game.camera_alt_info = true

          local surface = game.surfaces[1]
          for x = -31, 31 ,2 do
            surface.create_entity{name = "straight-rail", position = {x, 1}, direction = 2}
          end

          surface.create_entity{name = "trainassembly-machine", position = {-10, 1}, direction = 6}.set_recipe("locomotive-fluid[locomotive]")
          surface.create_entity{name = "trainassembly-machine", position = {-3, 1},  direction = 6}.set_recipe("cargo-wagon-fluid[cargo-wagon]")
          surface.create_entity{name = "trainassembly-machine", position = {4, 1},   direction = 2}.set_recipe("cargo-wagon-fluid[cargo-wagon]")
          surface.create_entity{name = "trainassembly-machine", position = {11, 1},  direction = 2}.set_recipe("locomotive-fluid[locomotive]")

          for x = -13.5, 14.5,7 do
            surface.create_entity{name = "medium-electric-pole", position = {x, 3.5}}
            surface.create_entity{name = "medium-electric-pole", position = {x, -1.5}}
          end
        ]]
      }
    }   
  }
)
