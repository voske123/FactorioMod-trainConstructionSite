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
      simulation = {
        init =
        [[
          global.player = game.create_test_player{name = "Voske_123"}
          global.player.character.color = {70, 192, 181}
          global.player.teleport({0.5, 6.5})
          global.player.character.orientation = 0.5
          game.camera_alt_info = true
          --game.camera_position = {3, 0}
          game.camera_player = global.player 
          game.camera_zoom = 0.8
          game.camera_player_cursor_position = global.player.position

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

          surface.create_entity{name = "straight-rail", position = {-50, 1}, direction = 2}
          surface.create_entity{name = "traindepot", position = {-50, -1}, direction = 2}
          
  
          state_1 = function()
            global.player.cursor_stack.set_stack({name = "traincontroller", count = 1})
            game.camera_player_cursor_direction = defines.direction.east
            script.on_nth_tick(1, function()
              if game.move_cursor{position = {10, 1}} then 
                state_2()
              end
            end)
          end

          state_2 = function()
          end

          state_1()



        ]]
      }
    }   
  }
)
