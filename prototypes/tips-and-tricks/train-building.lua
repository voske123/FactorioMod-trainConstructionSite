data:extend(
  {
    {
      type = "tips-and-tricks-item",
      name = "TCS-train-building",
      tag = "[entity=locomotive]",
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
          global.player = game.create_test_player{name = "Voske_123"}
          global.player.color = {70, 192, 181}
          global.player.teleport({0, 4})
          global.player.character.direction = defines.direction.south
          game.camera_alt_info = true
          game.camera_player = global.player
          global.player.character_running_speed_modifier = -0.5
          
          local surface = game.surfaces[1]
          for x = -40, 40, 2 do
            global.end_rail = surface.create_entity{name ="straight-rail",position = {x, 1}, direction = 2}
          end
          
          global.locomotive_entity = nil
          
          state_0 = function()
            game.camera_player_cursor_position = global.player.position
            game.camera_player_cursor_direction = defines.direction.east
            local count = 120
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              if game.move_cursor{position = global.player.position} then
                state_1()
              end
            end)
          end

          state_1 = function()
            local count = 60
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              global.player.cursor_stack.set_stack({name = "locomotive-manual-build", count = 1})
              if game.move_cursor{position = {0, 1}} then 
                state_2()
              end
            end)
          end

          state_2 = function()
            local count = 60
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              global.locomotive_entity = surface.create_entity{ name = "locomotive", position = game.camera_player_cursor_position, direction = 2, force = "player"}
              global.locomotive_entity.insert("trainassembly-trainfuel")
              global.locomotive_entity.train.schedule = 
              {
                current = 1,
                records = 
                {
                  {
                    rail = global.end_rail,
                    wait_conditions = 
                    {
                      {
                        type = "passenger_not_present",
                        compare_type = "and",
                      }
                    }
                  }
                }
              }              
              global.player.cursor_stack.clear()
              state_3()
            end)
          end 

          state_3 = function()
            local count = 60
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              global.player.character.orientation = 0
              if global.player.position.y >= 2.25 then 
                game.camera_player_cursor_position = {-50, 0}
                game.move_cursor{position = {-50, 0}}
                global.player.walking_state = {walking = true, direction = defines.direction.north}
              else
                global.player.walking_state = {walking = false}
                state_4()
              end
            end)
          end

          state_4 = function()
            local count = 30
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              global.player.teleport({-10, 4})
              state_5()
            end)
          end

          state_5 = function()
            local count = 30
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              global.locomotive_entity.train.manual_mode = false
              state_6()
            end)
          end

          state_6 = function()
            script.on_nth_tick(1, function()
              if global.locomotive_entity.position.x >= 20 then
                global.locomotive_entity.destroy()
                state_7()
              end
            end)
          end

          state_7 = function()
            local count = 120
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              if global.player.position.x <= 0 then 
                global.player.walking_state = {walking = true, direction = defines.direction.east}
              else
                global.player.walking_state = {walking = false}
                global.player.character.direction = defines.direction.south
                state_0()
              end
            end)
          end

          state_0()

        ]]
      }
    }   
  }
)
