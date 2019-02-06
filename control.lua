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



script.on_load(function()
  Traincontroller:onLoad()
end)



-- called when a mod setting changed
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  Traincontroller:onSettingChanged(event)
end)



script.on_event(defines.events.on_player_created, function(event)
  -- Called after the new player was created.
  if Debug.enabled then
    -- Insert items we want for debugging purposes
    Debug:onPlayerCreated(event.player_index)
  end
end)



script.on_event({defines.events.on_built_entity      ,
                 defines.events.on_robot_built_entity}, function(event)
  -- Called when an entity gets placed.
  Trainassembly:onBuildEntity(event.created_entity, event.player_index)
  Traincontroller:onBuildEntity(event.created_entity, event.player_index)
end)



script.on_event({defines.events.on_player_mined_entity,
                 defines.events.on_robot_mined_entity ,
                 defines.events.on_entity_died        }, function(event)
  -- Called when an entity gets removed.
  Trainassembly:onRemoveEntity(event.entity)
  Traincontroller:onRemoveEntity(event.entity)
end)



script.on_event(defines.events.on_player_rotated_entity, function(event)
  --Called when player rotates an entity.
  Trainassembly:onPlayerRotatedEntity(event.entity)
  Traincontroller:onPlayerRotatedEntity(event.entity, event.player_index)
end)



script.on_event(defines.events.on_entity_settings_pasted, function(event)
  --Called when player rotates an entity.
  Traincontroller:onPlayerChangedRecipe(event.destination, event.player_index)
end)
