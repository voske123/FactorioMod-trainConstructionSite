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
          game.camera_position = {2.5, 0}
          game.camera_zoom = 1
          game.camera_alt_info = true

          local surface = game.surfaces[1]
          for x = -30, 100 ,2 do
            global.end_rail = surface.create_entity{name = "straight-rail", position = {x, 1}, direction = 2}
          end

          global.trainbuilders =
          {
            surface.create_entity{name = "trainassembly-machine", position = {-9, 1}, direction = 6},
            surface.create_entity{name = "trainassembly-machine", position = {-2, 1},  direction = 6},
            surface.create_entity{name = "trainassembly-machine", position = {5, 1},   direction = 2},
            surface.create_entity{name = "trainassembly-machine", position = {12, 1},  direction = 2}
          }
          global.trainconfig = {"locomotive", "cargo-wagon", "cargo-wagon", "locomotive"}
          for index = 1, #global.trainbuilders do
            global.trainbuilders[index].set_recipe(global.trainconfig[index].."-fluid["..global.trainconfig[index].."]")
          end

          for x = -12.5, 15.5,7 do
            surface.create_entity{name = "medium-electric-pole", position = {x, 3.5}}
            surface.create_entity{name = "medium-electric-pole", position = {x, -1.5}}
          end

          surface.create_entity{name = "traincontroller", position = {17, 3}, direction = 2}
          
          global.train_carriers = {}
          global.train_carrier_require_fuel = {true, false, false, true}

          state_1 = function()
            local count = 30 + 90 * math.random()
            local amount = #global.trainbuilders
            local train_carriers_to_build = {}
            for i = 1, amount do
              train_carriers_to_build[i] = i
            end
            script.on_nth_tick(1, function()
              if count > 0 then count = count - 1 return end
              if amount > 0 then
                local index = 1 + math.floor(amount * math.random())
                global.train_carriers[train_carriers_to_build[index] ] = surface.create_entity{
                  name = global.trainconfig[train_carriers_to_build[index] ],
                  position = global.trainbuilders[train_carriers_to_build[index] ].position,
                  direction = global.trainbuilders[train_carriers_to_build[index] ].direction,
                  snap_to_train_stop = false
                }
                if global.train_carrier_require_fuel[train_carriers_to_build[index] ] then
                  global.train_carriers[train_carriers_to_build[index] ].insert("trainassembly-trainfuel")
                end
                table.remove(train_carriers_to_build, index)
                amount = amount - 1
                count = 30 + 60 * math.random()
              else
                global.train_carriers[1].train.schedule =
                {
                  current = 1,
                  records = 
                  {
                    {
                      rail = global.end_rail,
                      wait_conditions = 
                      {
                        {
                          type = "passenger_present",
                          compare_type = "and",
                        }
                      }
                    }
                  }
                }
                global.train_carriers[1].train.manual_mode = false
                state_2()
              end
            end)
          end

          state_2 = function()
            local count = 120
            script.on_nth_tick(1, function()
              if global.train_carriers[1].position.x >= 20 then
                if count > 0 then count = count - 1 return end
                for _,carrier in pairs(global.train_carriers) do
                  carrier.destroy()
                end
                state_1()
              end
            end)
          end

          state_1()
        ]]
      }
    }   
  }
)
