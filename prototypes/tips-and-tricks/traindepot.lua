data:extend(
  {
    {
      type = "tips-and-tricks-item",
      name = "traindepot",
      tag = "[item=traindepot]",
      localised_name = {"item-name.traindepot"},
      localised_description = {"",
        {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.traindepot-1-h"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traindepot-1-1"}},
        {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.traindepot-2-h"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traindepot-2-1"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traindepot-2-2"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traindepot-2-3"}},
        {"tips-and-tricks-font-setup.TCS-header", {"tips-and-tricks-item-description.traindepot-3-h"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traindepot-3-1"}},
        {"tips-and-tricks-font-setup.TCS-paragraph", {"tips-and-tricks-item-description.traindepot-3-2"}},
      },
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
      simulation = {
        init =
        [[
          global.player = game.create_test_player{name = "Voske_123"}
          global.player.color = {70, 192, 181}
          global.character = global.player.character
          game.camera_player = global.player
          game.camera_zoom = 0.80
          
          local surface = game.surfaces[1]
          global.rail_position = {x=14, y=0}
          local rail_length = 50
                    
          for x = -rail_length - global.rail_position.x, rail_length - global.rail_position.x, 2 do
            surface.create_entity{name = "straight-rail", position = {x, global.rail_position.y - 7}, direction = 2}
            surface.create_entity{name = "straight-rail", position = {x, global.rail_position.y - 1}, direction = 2}
            surface.create_entity{name = "straight-rail", position = {x, global.rail_position.y + 5}, direction = 2}
          end
          
          global.player.teleport({0, global.rail_position.y + 2}, global.player.surface) 
          
          global.traindepot = {
            surface.create_entity{name = "traindepot", position = {global.rail_position.x, global.rail_position.y - 5}, direction = 2, force = "player", raise_build = true},
            surface.create_entity{name = "traindepot", position = {global.rail_position.x, global.rail_position.y + 1}, direction = 2, force = "player", raise_build = true},
            surface.create_entity{name = "traindepot", position = {global.rail_position.x, global.rail_position.y + 7}, direction = 2, force = "player", raise_build = true},
          }

          global.end_rail = {
            surface.find_entity("straight-rail", {rail_length - global.rail_position.x, global.rail_position.y - 7}),
            surface.find_entity("straight-rail", {rail_length - global.rail_position.x, global.rail_position.y - 1}),
            surface.find_entity("straight-rail", {rail_length - global.rail_position.x, global.rail_position.y + 5}),
          }
  
          --TODO

        ]]
      }
    }   
  }
)
