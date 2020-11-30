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
          local area_size = 50
          game.surfaces[1].build_checkerboard({{-area_size, -area_size}, {area_size, area_size}})

          global.player = game.create_test_player{name = "Voske_123"}
          global.player.character.color = {70, 192, 181}
          global.player.teleport({0.5, 6.5})
          global.player.character.orientation = 0.5
          game.camera_alt_info = true
          game.camera_player = global.player 
          game.camera_zoom = 0.5
          game.camera_player_cursor_position = global.player.position

          local surface = game.surfaces[1]
          for x = -40, 40 ,2 do
            surface.create_entity{name = "straight-rail", position = {x, 1}, direction = 2}
          end

          
          surface.create_entity{name = "trainassembly-machine", position = {-17, 1}, direction = 6}.set_recipe("locomotive-fluid[locomotive]")
          surface.create_entity{name = "trainassembly-machine", position = {-10, 1},  direction = 6}.set_recipe("artillery-wagon-fluid[artillery-wagon]")
          surface.create_entity{name = "trainassembly-machine", position = {-3, 1},  direction = 6}.set_recipe("fluid-wagon-fluid[fluid-wagon]")
          surface.create_entity{name = "trainassembly-machine", position = {4, 1},   direction = 2}.set_recipe("cargo-wagon-fluid[cargo-wagon]")
          surface.create_entity{name = "trainassembly-machine", position = {11, 1},  direction = 2}.set_recipe("artillery-wagon-fluid[artillery-wagon]")
          surface.create_entity{name = "trainassembly-machine", position = {18, 1},  direction = 2}.set_recipe("locomotive-fluid[locomotive]")

          for x = -20.5, 21.5,7 do
            surface.create_entity{name = "medium-electric-pole", position = {x, 3.5}}
            surface.create_entity{name = "medium-electric-pole", position = {x, -1.5}}
          end

          surface.create_entity{name = "straight-rail", position = {-50, 1}, direction = 2}
          surface.create_entity{name = "traindepot", position = {-50, -1}, direction = 2}
          
          global.controller_entity = nil
          global.ui_renderer_id = nil

          state_1 = function()
            game.camera_player_cursor_direction = defines.direction.east
            local count = 60
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              global.player.cursor_stack.set_stack({name = "traincontroller", count = 1})
              if game.move_cursor{position = {26, 4.5}} then 
                state_2()
              end
            end)
          end

          state_2 = function()
            script.on_nth_tick(1,function()
              if game.move_cursor{position = {24.5, 3.5}} then
                state_3()
              end
            end)
          end

          state_3 = function()
            script.on_nth_tick(1,function()
              if game.move_cursor{position = {23, 3}} then
                state_4()
              end
            end)
          end

          state_4 = function()
            local count = 60
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              global.controller_entity = surface.create_entity{ name = global.player.cursor_stack.name, position = game.camera_player_cursor_position, direction = 2, force = "player"}
              global.player.cursor_stack.clear()
              state_5()
            end)
          end

          state_5 = function()
            local count = 60
            script.on_nth_tick(1,function()
              if count > 0 then count = count - 1 return end
              state_6()
            end)
          end
          
          state_6 = function()
            script.on_nth_tick(1, function()
              global.ui_renderer_id = rendering.draw_sprite{
                sprite = "tips-and-tricks-traincontroller-gui-1",
                target = global.player.character,
                surface = global.player.surface,
                target_offset = {0, -5},
              }
              state_7()
            end)
          end

          state_7 = function()
            local count = 60
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
                if game.move_cursor{position = {6, 7.5}} then
                  rendering.set_sprite(global.ui_renderer_id, "tips-and-tricks-traincontroller-gui-2")
                  state_8()
                end
            end)
          end

          state_8 = function()
            local count = 60
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              rendering.set_sprite(global.ui_renderer_id, "tips-and-tricks-traincontroller-gui-3")
              rendering.set_target(global.ui_renderer_id, global.player.character, {6.61, -5})
              state_9()
            end)
          end

          state_9 = function()
            local count = 60
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              rendering.set_sprite(global.ui_renderer_id, "tips-and-tricks-traincontroller-gui-4")
              rendering.set_target(global.ui_renderer_id, global.player.character, {6.61, -5})
              if game.move_cursor{position = {7, 7.5}} then
                state_10()
              end
            end)
          end

          state_10 = function()
            local count = 120
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              rendering.destroy(global.ui_renderer_id)
              global.controller_entity.destroy()
              if game.move_cursor{position = global.player.position} then
                state_1()
              end
            end)
          end

          state_1()



        ]]
      }
    },
    {
      type     = "sprite",
      name     = "tips-and-tricks-traincontroller-gui-1",
      filename = "__trainConstructionSite__/graphics/tips-and-tricks/traincontroller_1.png",
      width    = 433,
      height   = 430,
      scale    = 1.5,
      --shift    = {0, 32},
      flags    = {
        "icon",
        "no-crop"
      }
    },
    {
      type     = "sprite",
      name     = "tips-and-tricks-traincontroller-gui-2",
      filename = "__trainConstructionSite__/graphics/tips-and-tricks/traincontroller_2.png",
      width    = 433,
      height   = 430,
      scale    = 1.5,
      --shift    = {0, 32},
      flags    = {
        "icon",
        "no-crop"
      }
    },
    {
      type     = "sprite",
      name     = "tips-and-tricks-traincontroller-gui-3",
      filename = "__trainConstructionSite__/graphics/tips-and-tricks/traincontroller_3.png",
      width    = 713,
      height   = 430,
      scale    = 1.5,
      --shift    = {0, 32},
      flags    = {
        "icon",
        "no-crop"
      }
    },
    {
      type     = "sprite",
      name     = "tips-and-tricks-traincontroller-gui-4",
      filename = "__trainConstructionSite__/graphics/tips-and-tricks/traincontroller_4.png",
      width    = 713,
      height   = 430,
      scale    = 1.5,
      --shift    = {0, 32},
      flags    = {
        "icon",
        "no-crop"
      }
    },
  }
)
