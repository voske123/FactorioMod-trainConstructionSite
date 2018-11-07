require "src.debug"
require "src.trainassembly"
require "src.traincontroller"


script.on_init(function(event)
  -- This is called once when a new save game is created or once
  -- when a save file is loaded that previously didn't contain the mod.

  if Debug.enabled then
    -- Terraforming the land to fit our debugging needs
    Debug:onMapCreated()
  end

  Trainassembly:onInit()
  Traincontroller:onInit()
end)



script.on_event(defines.events.on_player_created, function(event)
  -- Called after the new player was created.
  if Debug.enabled then
    -- Insert items we want for debugging purposes
    Debug:onPlayerCreated(event.player_index)
  end
end)



script.on_event(defines.events.on_built_entity, function(event)
  -- Called when player builds an entity.
  game.print(serpent.block(event.created_entity.position))
  Trainassembly:onPlayerBuildEntity(event.created_entity)
  Traincontroller:onPlayerBuildEntity(event.created_entity, event.player_index)
end)



script.on_event(defines.events.on_player_mined_entity, function(event)
  -- Called when player mines an entity.
  Trainassembly:onRemoveEntity(event.entity)
end)



script.on_event(defines.events.on_player_rotated_entity, function(event)
  --Called when player rotates an entity.
  Trainassembly:onPlayerRotatedEntity(event.entity)
end)
