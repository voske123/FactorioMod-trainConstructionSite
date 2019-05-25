require 'util'
require "src.traindepot"
require "src.trainassembly"
require "src.traincontroller"

Debug = {
  enabled = false
}

function Debug:onInit()
  if not self.enabled then return end

  local size = 500

  local surface = game.surfaces["nauvis"]
  surface.always_day = true
  if game.active_mods["The_Lab_tiles"] then
    -- Let's create lab tiles
    local labTiles = {}
    for X = -size/2,size/2 do
      for Y = -size/2,size/2 do
        if (X+Y) %2 == 0 then
          table.insert(labTiles, {name = "lab-dark-1", position = {X,Y} })
        else
          table.insert(labTiles, {name = "lab-dark-2", position = {X,Y} })
        end
      end
    end
    surface.set_tiles(labTiles)

  else
    -- If no lab tiles, just delete the water
    local waterTiles = {}
    for _, waterTile in pairs(surface.find_tiles_filtered{
      area =
      {
        left_top = {-size/2, -size/2},
        right_bottom = {size/2, size/2},
      },
      collision_mask = "water-tile"
    }) do
      if waterTile.valid then
        table.insert(waterTiles, {name = "grass-1", position = util.table.deepcopy(waterTile.position)})
      end
    end
    surface.set_tiles(waterTiles)
  end
end



function Debug:onPlayerCreated(player_index)
  -- Insert items we want for debugging purposes
  if not self.enabled then return end

  -- research all technologies
  game.players[player_index].force.research_all_technologies()

  -- insert debug items
  local player = game.players[player_index]

  player.insert("solar-panel")
  player.insert("accumulator")
  player.insert("substation")

  player.insert("rail")
  player.insert("rail-signal")
  player.insert("train-stop")
  player.insert(Trainassembly:getItemName())
  player.insert(Traincontroller:getControllerItemName())
  player.insert(Traindepot:getDepotItemName())

  player.insert("locomotive")
  player.insert("trainassembly-recipefuel")

  -- create debug environment if this is the first player ingame
  if player_index == 1 then
    Debug:createTestbench(player.surface)
  end
end



function Debug:createTestbench(surface)
  local areaRange = 60
  self:createTestbench1(surface, areaRange)
  self:createTestbench2(surface, areaRange)
end



function Debug:createTestbench1(surface, areaRange)

  -- STEP 1: delete all entities surrounding the test surface
  surface.destroy_decoratives{area = {{-areaRange, -areaRange}, {areaRange, areaRange}}}
  areaRange = math.floor(.5 + areaRange / 2)
  for _, entity in pairs(surface.find_entities_filtered{
    area   = {{-areaRange, -areaRange}, {areaRange, areaRange}},
    type   = "character",
    invert = true,
  }) do
    entity.destroy()
  end

  -- STEP 2: Create the test bench
  -- STEP 2a:create the rails
  local distance = math.floor(.5 + areaRange/2)
  local areaMax = math.floor(.5 + (areaRange*.8)/2)*2
  for i = 3, areaMax, 2 do
    for direction,position in pairs{
      [defines.direction.east ] = {x =  i       , y =  distance},
      [defines.direction.west ] = {x = -i       , y =  distance},
      [defines.direction.north] = {x =  distance, y = -i       },
      [defines.direction.south] = {x = -distance, y = -i       },
    } do
      surface.create_entity{
        name      = "straight-rail",
        position  = position,
        direction = direction,
        force     = "player",
      }
    end
  end

  -- Step 2b:create the train depots
  local depotName = "test depot id%i"
  for direction,position in pairs{
    [defines.direction.east ] = {x =  areaMax  - 2, y =  distance + 2},
    [defines.direction.west ] = {x = -areaMax     , y =  distance - 2},
    [defines.direction.north] = {x = -distance + 2, y = -areaMax     },
    [defines.direction.south] = {x =  distance - 2, y = -3           },
  } do
    surface.create_entity{
      name        = Traindepot:getDepotEntityName(),
      position    = position,
      direction   = direction,
      force       = "player",
      raise_built = true,
    }.backer_name = string.format(depotName, direction)
  end

  -- Step 2c:create the train assemblers
  for direction,position in pairs{
    [defines.direction.east ] = {x =  7       , y =  distance   },
    [defines.direction.west ] = {x = -7       , y =  distance   },
    [defines.direction.north] = {x = -distance, y = -7          },
    [defines.direction.south] = {x =  distance, y = -areaMax + 5},
  } do
    surface.create_entity{
      name        = Trainassembly:getPlaceableEntityName(),
      position    = position,
      direction   = direction,
      force       = "player",
      raise_built = true,
    }
    surface.find_entities_filtered{
      name        = Trainassembly:getMachineEntityName(),
      position    = position,
      limit       = 1,
    }[1].set_recipe("locomotive-fluid[locomotive]")
  end

  -- Step 2d:create the traincontrollers
  for direction,position in pairs{
    [defines.direction.east ] = {x =  7 + 4       , y =  distance + 2   },
    [defines.direction.west ] = {x = -7 - 4       , y =  distance - 2   },
    [defines.direction.north] = {x = -distance + 2, y = -7 - 4          },
    [defines.direction.south] = {x =  distance - 2, y = -areaMax + 5 + 4},
  } do
    surface.create_entity{
      name        = Traincontroller:getControllerEntityName(),
      position    = position,
      direction   = direction,
      force       = "player",
      raise_built = true,
    }.backer_name = string.format(depotName, direction)
  end
end



function Debug:createTestbench2(surface, areaRange)
  local offset = {x = -2 * areaRange, y = 0}

  -- STEP 1: delete all entities surrounding the test surface
  surface.destroy_decoratives{area = {{-areaRange + offset.x, -areaRange + offset.y}, {areaRange + offset.x, areaRange + offset.y}}}
  for _, entity in pairs(surface.find_entities_filtered{
    area   = {{-areaRange + offset.x, -areaRange + offset.y}, {areaRange + offset.x, areaRange + offset.y}},
    type   = "character",
    invert = true,
  }) do
    entity.destroy()
  end

  -- STEP 2: Create the testbench
  -- STEP 2a:create the rails
  local distance = math.floor(.5 + areaRange/2)
  local areaMax = math.floor(.5 + (areaRange-6)/2)*2
  for i = 3, areaMax, 2 do
    for direction,position in pairs{
      [defines.direction.east ] = {x =  i        + offset.x, y =  distance + offset.y},
      [defines.direction.west ] = {x = -i        + offset.x, y =  distance + offset.y},
      [defines.direction.north] = {x =  distance + offset.x, y = -i        + offset.y},
      [defines.direction.south] = {x = -distance + offset.x, y = -i        + offset.y},
    } do
      surface.create_entity{
        name      = "straight-rail",
        position  = position,
        direction = direction,
        force     = "player",
      }
    end
  end

  -- Step 2b:create the train assemblers
  local length = 6
  for i = 0, length - 1 do
    for direction,position in pairs{
      [defines.direction.east ] = {x =  7 + 7 * i + offset.x, y =  distance            + offset.y},
      [defines.direction.west ] = {x = -7 - 7 * i + offset.x, y =  distance            + offset.y},
      [defines.direction.north] = {x = -distance  + offset.x, y = -7           - 7 * i + offset.y},
      [defines.direction.south] = {x =  distance  + offset.x, y = -areaMax + 5 + 7 * i + offset.y},
    } do
      surface.create_entity{
        name        = Trainassembly:getPlaceableEntityName(),
        position    = position,
        direction   = direction,
        force       = "player",
        raise_built = true,
      }
      surface.find_entities_filtered{
        name        = Trainassembly:getMachineEntityName(),
        position    = position,
        limit       = 1,
      }[1].set_recipe("locomotive-fluid[locomotive]")
    end
  end

  -- Step 2c:create the traincontrollers
  local i = length - 1
  for direction,position in pairs{
    [defines.direction.east ] = {x =  7 + 7 * i + 4 + offset.x, y =  distance + 2            + offset.y},
    [defines.direction.west ] = {x = -7 - 7 * i - 5 + offset.x, y =  distance - 2            + offset.y},
    [defines.direction.north] = {x = -distance + 2  + offset.x, y = -7           - 4 - 7 * i + offset.y},
    [defines.direction.south] = {x =  distance - 2  + offset.x, y = -areaMax + 5 + 4 + 7 * i + offset.y},
  } do
    surface.create_entity{
      name        = Traincontroller:getControllerEntityName(),
      position    = position,
      direction   = direction,
      force       = "player",
      raise_built = true,
    }.backer_name = string.format("test depot id%i", direction)
  end

end
