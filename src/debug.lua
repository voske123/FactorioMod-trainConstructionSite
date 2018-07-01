require 'util'

Debug = {}

Debug.enabled = true

function Debug:onMapCreated()
  local size = 500

  local surface = game.surfaces["nauvis"]
  if game.active_mods["The_Lab_016"] then
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
  local mainInventory = game.players[player_index].get_main_inventory()
  local quickbar = game.players[player_index].get_quickbar()
  local toolInventory = game.players[player_index].get_inventory(defines.inventory.player_tools)

  if quickbar and quickbar.valid then
    quickbar.insert("rail")
    quickbar.insert("rail-signal")
    quickbar.insert("trainassembly")
  end

  if toolInventory and toolInventory.valid then
    toolInventory.insert("steel-axe")
  end

  log(game.players[player_index].force.name)
end
