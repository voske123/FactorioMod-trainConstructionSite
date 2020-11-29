data:extend(
  {
    {
      type = "tips-and-tricks-item",
      name = "traindepot",
      tag = "[item=traindepot]",
      localised_name = {"item-name.traindepot"},
      localised_description = {"",
        {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.traindepot-1-h"}},
        {"tips-and-tricks-item-description.traindepot-1-1"},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traindepot-1-2"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.traindepot-2-h"}}},
        {"tips-and-tricks-item-description.traindepot-2-1"},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traindepot-2-2"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traindepot-2-3"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.traindepot-3-h"}}},
        {"tips-and-tricks-item-description.traindepot-3-1"},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traindepot-3-2"}},
      },
      category = "trains",
      indent = 2,
      order = "cx-tcs[trainbuilder]-a",
      trigger =
      {
        type = "research",
        technology = "automated-rail-transportation"
      },
      dependencies = {"train-stops"},
      --tutorial = "trains-advanced-signals",
      simulation = {
        init =
        [[
          local surface = game.surfaces[1]
          global.rail_position = {x=14, y=0}
          local rail_length = 100
          game.camera_position = {0, global.rail_position.y - 1}
          game.camera_zoom = 0.8
          
          for x = -rail_length + global.rail_position.x, rail_length + global.rail_position.x, 2 do
            surface.create_entity{name = "straight-rail", position = {x, global.rail_position.y - 7}, direction = 2}
            surface.create_entity{name = "straight-rail", position = {x, global.rail_position.y - 1}, direction = 2}
            surface.create_entity{name = "straight-rail", position = {x, global.rail_position.y + 5}, direction = 2}
          end
          
          global.traindepot = {
            surface.create_entity{name = "traindepot", position = {global.rail_position.x, global.rail_position.y - 5}, direction = 2, force = "player", raise_build = true},
            surface.create_entity{name = "traindepot", position = {global.rail_position.x, global.rail_position.y + 1}, direction = 2, force = "player", raise_build = true},
            surface.create_entity{name = "traindepot", position = {global.rail_position.x, global.rail_position.y + 7}, direction = 2, force = "player", raise_build = true},
          }

          global.end_rail = {
            surface.find_entity("straight-rail", {rail_length + global.rail_position.x - 1, global.rail_position.y - 7}),
            surface.find_entity("straight-rail", {rail_length + global.rail_position.x - 1, global.rail_position.y - 1}),
            surface.find_entity("straight-rail", {rail_length + global.rail_position.x - 1, global.rail_position.y + 5}),
          }
  
          global.trains = {}
          for i = 1,3 do global.trains[i] = {} end

          global.state = 0  --state 0 = train 1 right, train 3 in station
                            --state 1 = train 1 in station, train 3 in station
                            --state 2 = train 1 in station, train 3 right
                            --state 3 = train 1 in station, train 3 in station
                            --state 0

          global.spawn_distance = 40 - rail_length

          global.trains[2][1] = game.surfaces[1].create_entity{name = "locomotive",  position = {global.rail_position.x - 2,  global.rail_position.y - 1}, orientation = 0.25, force = "player"}
          global.trains[2][2] = game.surfaces[1].create_entity{name = "cargo-wagon", position = {global.rail_position.x - 9,  global.rail_position.y - 1}, orientation = 0.25, force = "player"}
          global.trains[2][3] = game.surfaces[1].create_entity{name = "cargo-wagon", position = {global.rail_position.x - 16, global.rail_position.y - 1}, orientation = 0.25, force = "player"}
          global.trains[2][4] = game.surfaces[1].create_entity{name = "locomotive",  position = {global.rail_position.x - 23, global.rail_position.y - 1}, orientation = 0.75, force = "player"}

          global.trains[2][1].train.schedule = 
          {
            current = 1,
            records = 
            {
              {
                station = global.traindepot[2].backer_name,
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
          global.trains[2][1].train.manual_mode = false
          global.trains[2][1].insert("trainassembly-trainfuel")
          global.trains[2][4].insert("trainassembly-trainfuel")

          global.trains[3][1] = game.surfaces[1].create_entity{name = "locomotive",  position = {global.rail_position.x - 2,  global.rail_position.y + 5}, orientation = 0.25, force = "player"}
          global.trains[3][2] = game.surfaces[1].create_entity{name = "cargo-wagon", position = {global.rail_position.x - 9,  global.rail_position.y + 5}, orientation = 0.25, force = "player"}
          global.trains[3][3] = game.surfaces[1].create_entity{name = "cargo-wagon", position = {global.rail_position.x - 16, global.rail_position.y + 5}, orientation = 0.25, force = "player"}
          global.trains[3][4] = game.surfaces[1].create_entity{name = "locomotive",  position = {global.rail_position.x - 23, global.rail_position.y + 5}, orientation = 0.75, force = "player"}

          global.trains[3][1].train.schedule = 
          {
            current = 1,
            records = 
            {
              {
                station = global.traindepot[3].backer_name,
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
          global.trains[3][1].train.manual_mode = false
          global.trains[3][1].insert("trainassembly-trainfuel")
          global.trains[3][4].insert("trainassembly-trainfuel")

          script.on_nth_tick(500, function()
            if global.state == 0 then
              if global.trains[1] then
                for i = 1,4 do
                  if global.trains[1][i] and global.trains[1][i].valid then
                    global.trains[1][i].destroy()
                  end
                end
              end

              global.trains[1][1] = game.surfaces[1].create_entity{name = "locomotive",  position = {global.spawn_distance - 0,  global.rail_position.y - 7}, orientation = 0.25, force = "player"}
              global.trains[1][2] = game.surfaces[1].create_entity{name = "cargo-wagon", position = {global.spawn_distance - 7,  global.rail_position.y - 7}, orientation = 0.25, force = "player"}
              global.trains[1][3] = game.surfaces[1].create_entity{name = "cargo-wagon", position = {global.spawn_distance - 14, global.rail_position.y - 7}, orientation = 0.25, force = "player"}
              global.trains[1][4] = game.surfaces[1].create_entity{name = "locomotive",  position = {global.spawn_distance - 21, global.rail_position.y - 7}, orientation = 0.75, force = "player"}
              
              global.trains[1][1].train.schedule = 
              {
                current = 1,
                records = 
                {
                  {
                    station = global.traindepot[1].backer_name,
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
              global.trains[1][1].train.manual_mode = false
              global.trains[1][1].insert("trainassembly-trainfuel")
              global.trains[1][4].insert("trainassembly-trainfuel")

              global.state = 1

            elseif global.state == 1 then
              global.trains[3][1].train.schedule = 
              {
                current = 1,
                records = 
                {
                  {
                    rail = global.end_rail[3],
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

              global.state = 2

            elseif global.state == 2 then
              if global.trains[3] then
                for i = 1,4 do
                  if global.trains[3][i] and global.trains[3][i].valid then
                    global.trains[3][i].destroy()
                  end
                end
              end
              
              global.trains[3][1] = game.surfaces[1].create_entity{name = "locomotive",  position = {global.spawn_distance - 0,  global.rail_position.y + 5}, orientation = 0.25, force = "player"}
              global.trains[3][2] = game.surfaces[1].create_entity{name = "cargo-wagon", position = {global.spawn_distance - 7,  global.rail_position.y + 5}, orientation = 0.25, force = "player"}
              global.trains[3][3] = game.surfaces[1].create_entity{name = "cargo-wagon", position = {global.spawn_distance - 14, global.rail_position.y + 5}, orientation = 0.25, force = "player"}
              global.trains[3][4] = game.surfaces[1].create_entity{name = "locomotive",  position = {global.spawn_distance - 21, global.rail_position.y + 5}, orientation = 0.75, force = "player"}
              
              global.trains[3][1].train.schedule = 
              {
                current = 1,
                records = 
                {
                  {
                    station = global.traindepot[3].backer_name,
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
              global.trains[3][1].train.manual_mode = false
              global.trains[3][1].insert("trainassembly-trainfuel")
              global.trains[3][4].insert("trainassembly-trainfuel")

              global.state = 3

            elseif global.state == 3 then

              global.trains[1][1].train.schedule = 
              {
                current = 1,
                records = 
                {
                  {
                    rail = global.end_rail[1],
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

              global.state = 0
            end

          end)
        ]]
      }
    }   
  }
)
