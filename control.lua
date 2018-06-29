require "src.debug"

script.on_init(function(event)
  if Debug.enabled then
    Debug:onMapCreated()
  end
end)

script.on_event(defines.events.on_player_created, function(event)
  if Debug.enabled then
    Debug:onPlayerCreated(event.player_index)
  end
end)
