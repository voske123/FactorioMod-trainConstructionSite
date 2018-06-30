require "src.debug"
require "src.trainassembly"


script.on_init(function(event)
  -- This is called once when a new save game is created or once
  -- when a save file is loaded that previously didn't contain the mod.

  if Debug.enabled then
    Debug:onMapCreated()
  end

  Trainassembly:onInit()
end)



script.on_event(defines.events.on_player_created, function(event)
  -- Called after the player was created.
  if Debug.enabled then
    Debug:onPlayerCreated(event.player_index)
  end
end)



script.on_event(defines.events.on_built_entity, function(event)
  -- Called when player builds something.
  Trainassembly:onPlayerBuildEntity(event.created_entity)
end)
