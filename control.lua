require "src.debug"
require "src.traindepo"
require "src.trainassembly"
require "src.traincontroller"


script.on_init(function(event)
  -- This is called once when a new save game is created or once
  -- when a save file is loaded that previously didn't contain the mod.

  if Debug.enabled then
    -- Terraforming the land to fit our debugging needs
    Debug:onMapCreated()
  end

  Traindepo:onInit()
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
  local createdEntity = event.created_entity
  if createdEntity and createdEntity.valid then
    local playerIndex = event.player_index

    Traindepo:onBuildEntity(createdEntity)
    Trainassembly:onBuildEntity(createdEntity, playerIndex)
    Traincontroller:onBuildEntity(createdEntity, playerIndex)
  end
end)



script.on_event({defines.events.on_player_mined_entity,
                 defines.events.on_robot_mined_entity ,
                 defines.events.on_entity_died        }, function(event)
  -- Called when an entity gets removed.
  local removedEntity = event.entity
  if removedEntity and removedEntity.valid then
    Traindepo:onRemoveEntity(removedEntity)
    Trainassembly:onRemoveEntity(removedEntity)
    Traincontroller:onRemoveEntity(removedEntity)
  end
end)



script.on_event(defines.events.on_player_rotated_entity, function(event)
  --Called when player rotates an entity.
  local rotatedEntity = event.entity
  if rotatedEntity and rotatedEntity.valid then
    Trainassembly:onPlayerRotatedEntity(rotatedEntity)
    Traincontroller:onPlayerRotatedEntity(rotatedEntity, event.player_index)
  end
end)



script.on_event(defines.events.on_entity_settings_pasted, function(event)
  --Called when player rotates an entity.
  Traincontroller:onPlayerChangedRecipe(event.destination, event.player_index)
end)



script.on_event(defines.events.on_entity_renamed, function(event)
  --Called after an entity has been renamed either by the player or through script.
  Traindepo:onRenameEntity(event.entity, event.old_name)
end)
