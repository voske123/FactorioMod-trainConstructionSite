require "LSlib.lib"
require "src.debug"
require "src.traindepot"
require "src.trainassembly"
require "src.traincontroller"

script.on_init(function(event)
  -- This is called once when a new save game is created or once
  -- when a save file is loaded that previously didn't contain the mod.
  Traindepot     :onInit()
  Trainassembly  :onInit()
  Traincontroller:onInit()

  if Debug.enabled then
    -- Terraforming the land to fit our debugging needs
    Debug:onMapCreated()
  end
end)



script.on_load(function()
  Traincontroller:onLoad()
end)



script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  -- called when a mod setting changed
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
                 defines.events.on_robot_built_entity,
                 defines.events.script_raised_built  }, function(event)
  -- Called when an entity gets placed.
  local createdEntity = event.created_entity or event.entity
  if createdEntity and createdEntity.valid then
    local playerIndex = event.player_index

    Traindepot     :onBuildEntity(createdEntity)
    Trainassembly  :onBuildEntity(createdEntity, playerIndex)
    Traincontroller:onBuildEntity(createdEntity, playerIndex)
  end
end)



script.on_event({defines.events.on_player_mined_entity,
                 defines.events.on_robot_mined_entity ,
                 defines.events.on_entity_died        ,
                 defines.events.script_raised_destroy }, function(event)
  -- Called when an entity gets removed.
  local removedEntity = event.entity
  if removedEntity and removedEntity.valid then
    Traindepot     :onRemoveEntity(removedEntity)
    Trainassembly  :onRemoveEntity(removedEntity)
    Traincontroller:onRemoveEntity(removedEntity)
  end
end)



script.on_event(defines.events.on_player_rotated_entity, function(event)
  -- Called when player rotates an entity.
  local rotatedEntity = event.entity
  if rotatedEntity and rotatedEntity.valid then
    Trainassembly  :onPlayerRotatedEntity(rotatedEntity)
    Traincontroller:onPlayerRotatedEntity(rotatedEntity, event.player_index)
  end
end)



script.on_event(defines.events.on_entity_settings_pasted, function(event)
  -- Called after entity copy-paste is done.
  Traincontroller:onPlayerChangedSettings(event.destination, event.player_index)
end)



script.on_event(defines.events.on_entity_renamed, function(event)
  -- Called after an entity has been renamed either by the player or through script.
  Traincontroller:onRenameEntity(event.entity, event.old_name)
  Traindepot     :onRenameEntity(event.entity, event.old_name)
end)



script.on_event(defines.events.on_player_left_game, function(event)
  -- Called after a player leaves the game.
  Traindepot     .Gui:onLeftGame(event.player_index)
  Traincontroller.Gui:onLeftGame(event.player_index)
end)



script.on_event(defines.events.on_gui_opened, function(event)
  -- Called when the player opens a GUI.
  Traindepot     .Gui:onOpenEntity(event.entity, event.player_index)
  Traincontroller.Gui:onOpenEntity(event.entity, event.player_index)
end)



script.on_event(defines.events.on_gui_closed, function(event)
  -- Called when the player closes a GUI.
  Traindepot     .Gui:onCloseEntity(event.element, event.player_index)
  Traincontroller.Gui:onCloseEntity(event.element, event.player_index)
end)



script.on_event({defines.events.on_gui_click                  ,
                 defines.events.on_gui_elem_changed           ,
                 defines.events.on_gui_selection_state_changed}, function(event)
  -- Called when the player clicks on a GUI.
  Traindepot     .Gui:onClickElement(event.element.name, event.player_index)
  Traincontroller.Gui:onClickElement(event.element.name, event.player_index)
end)
