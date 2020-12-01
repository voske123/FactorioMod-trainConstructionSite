require("__LSlib__/LSlib")

-- To make sure everything is inline with the technology tree when the mod is added.
-- This is for when the mod is added into an existing game or when the mod is updated.
local trainControllerGui = require("prototypes.gui.layout.traincontroller")
local trainDepotGui = require("prototypes.gui.layout.traindepot")

require("src.traincontroller")

return function(configurationData)
  local modChanges = configurationData.mod_changes["trainConstructionSite"]
  if modChanges and modChanges.new_version ~= (modChanges.old_version or "") then
    log(string.format("Updating trainConstructionSite from version %q to version %q", modChanges.old_version or "nil", modChanges.new_version))

    --------------------------------------------------
    -- Prototype data                               --
    --------------------------------------------------
    for forceName, force in pairs(game.forces) do
      local technologies = force.technologies
      local recipes      = force.recipes

      if recipes["locomotive"].enabled then
        technologies["trainassembly-automated-train-assembling"].researched = true
      end

      if recipes["cargo-wagon"].enabled then
        technologies["trainassembly-cargo-wagon"].researched = true
     end

      if recipes["artillery-wagon"].enabled then
        technologies["trainassembly-artillery-wagon"].researched = true
      end

      force.reset_technology_effects()
    end

    --------------------------------------------------
    -- Trainassembly script                         --
    --------------------------------------------------
    if global.TA_data.version == 1 then
      log("Updating Trainassembly from version 1 to version 2.")
      global.TA_data.prototypeData.trainTint = {}
      global.TA_data.version = 2
    end

    if global.TA_data.version == 2 then
      log("Updating Trainassembly from version 2 to version 3.")
      global.TA_data.prototypeData.rollingStock =
      {
        ["locomotive"     ] = true,
        ["cargo-wagon"    ] = true,
        ["fluid-wagon"    ] = true,
        ["artillery-wagon"] = true,
      }
      global.TA_data.version = 3
    end

    if global.TA_data.version == 3 then
      log("Updating Trainassembly from version 3 to version 4.")
      for machineSurface,machineSurfaceData in pairs(global.TA_data and global.TA_data["trainAssemblers"] or {}) do
        for machinePositionY, machinePositionData in pairs(machineSurfaceData) do
          for machinePositionX, machineData in pairs(machinePositionData) do
            local renderIDs = {}
            local machineEntity = machineData.entity
            for animationLayer,renderLayer in pairs{
              ["base"] = 124,
              ["overlay"] = 133
            } do
              renderIDs[animationLayer] = rendering.draw_animation{
                animation = machineEntity.name .. "-" .. LSlib.utils.directions.toString(machineEntity.direction) .. "-" .. animationLayer,
                render_layer = renderLayer,
                target = machineEntity,
                surface = machineEntity.surface,
              }
            end
            global.TA_data["trainAssemblers"][machineSurface][machinePositionY][machinePositionX]["renderID"] = renderIDs
          end
        end
      end
      global.TA_data.version = 4
    end

    --------------------------------------------------
    -- Traincontroller script                       --
    --------------------------------------------------
    if global.TC_data.version == 1 then
      log("Updating Traincontroller from version 1 to version 2.")
      if LSlib.utils.table.isEmpty(global.TC_data["trainControllers"]) and global.TC_data["nextTrainControllerIterate"] then
        global.TC_data["nextTrainControllerIterate"] = nil
        Traincontroller.Builder:deactivateOnTick()
      end
      global.TC_data.version = 2
    end

    if global.TC_data.version == 2 then
      log("Updating Traincontroller from version 2 to version 3.")
      for surfaceIndex, surfaceData in pairs(global.TC_data["trainControllers"] or {}) do
        for controllerPositionY, controllerPositionData in pairs(surfaceData) do
          for controllerPositionX, controllerData in pairs(controllerPositionData) do
            for _, hiddenEntity in pairs(controllerData["entity-hidden"]) do
              if hiddenEntity.valid then
                hiddenEntity.destroy()
              end
            end
            controllerData["entity-hidden"] = {}
            local controllerEntity = controllerData["entity"]
            for hiddenEntityIndex, hiddenEntityData in pairs(Traincontroller:getHiddenEntityData(controllerEntity.position, controllerEntity.direction)) do
              controllerData["entity-hidden"][hiddenEntityIndex] = controllerEntity.surface.create_entity{
                name      = hiddenEntityData.name,
                position  = hiddenEntityData.position,
                direction = hiddenEntityData.direction,
                force     = Traincontroller:getDepotForceName(controllerEntity.force.name)
              }
            end
          end
        end
      end
      global.TC_data.version = 3
    end

    --------------------------------------------------
    -- Traincontroller.Gui script                   --
    --------------------------------------------------
    if global.TC_data.Gui.version == 1 then
      log("Updating Traincontroller.Gui from version 1 to version 2.")
      global.TC_data.Gui["prototypeData"]["trainControllerGui"] = trainControllerGui
      global.TC_data.Gui.version = 2
    end

    if global.TC_data.Gui.version == 2 then
      log("Updating Traincontroller.Gui from version 2 to version 3.")
      global.TC_data.Gui["clickHandler"] = nil
      global.TC_data.Gui.version = 3
    end

    if global.TC_data.Gui.version == 3 then
      log("Updating Traincontroller.Gui from version 3 to version 4.")
      global.TC_data.Gui["prototypeData"]["trainControllerGui"] = trainControllerGui
      global.TC_data.Gui.version = 4
    end

    if global.TC_data.Gui.version == 4 then
      log("Updating Traincontroller.Gui from version 4 to version 5.")
      for playerIndex, _ in pairs(game.players) do
        if Traincontroller.Gui:hasOpenedGui(playerIndex) then
          game.players[playerIndex].opened = Traincontroller.Gui:destroyGui(playerIndex)
          Traincontroller.Gui:setOpenedControllerEntity(playerIndex, nil)
        end
      end
      global.TC_data.Gui["prototypeData"] = Traincontroller.Gui:initPrototypeData()
      global.TC_data.Gui.version = 5
    end

    --------------------------------------------------
    -- Traindepot script                            --
    --------------------------------------------------
    if global.TD_data.version == 1 then
      log("Updating Traindepot from version 1 to version 2.")
      global.TD_data.version = 2
    end

    --------------------------------------------------
    -- Traindepot.Gui script                        --
    --------------------------------------------------
    if global.TD_data.Gui.version == 1 then
      log("Updating Traindepot.Gui from version 1 to version 2.")
      global.TD_data.Gui["prototypeData"]["trainDepotGui"] = trainDepotGui
      global.TD_data.Gui.version = 2
    end

    if global.TD_data.Gui.version == 2 then
      log("Updating Traindepot.Gui from version 2 to version 3.")
      global.TD_data.Gui["clickHandler"] = nil
      global.TD_data.Gui.version = 3
    end

    if global.TD_data.Gui.version == 3 then
      log("Updating Traindepot.Gui from version 3 to version 4.")
      global.TD_data.Gui["prototypeData"]["trainDepotGui"] = trainDepotGui
      global.TD_data.Gui.version = 4
    end

    if global.TD_data.Gui.version == 4 then
      log("Updating Traindepot.Gui from version 4 to version 5.")
      for playerIndex, _ in pairs(game.players) do 
        if Traindepot.Gui:hasOpenedGui(playerIndex) then
          Traindepot.Gui:setOpenedEntity(playerIndex, nil)
          game.players[playerIndex].opened = Traindepot.Gui:destroyGui(playerIndex)
        end
      end
      global.TD_data.Gui["prototypeData"] = Traindepot.Gui:initPrototypeData()
      global.TD_data.Gui.version = 5
    end

    --------------------------------------------------
    -- Help.Gui script                              --
    --------------------------------------------------
    if global.H_data.Gui then
      if global.H_data.Gui.version then
        log("Removing Help.Gui version "..(global.H_data.Gui.version or "unknown")..".")
      end
      for player_index, _ in pairs(game.players) do
        if global.H_data.Gui["openedGui"][playerIndex] then
          global.H_data.Gui["openedGui"][playerIndex].destroy()
        end
      end
      global.H_data.Gui = nil
    end

    --------------------------------------------------
    -- Help script                                  --
    --------------------------------------------------
    if global.H_data then
      if global.H_data.version then
        log("Removing Help version "..(global.H_data.version or "unknown")..".")
      end
      global.H_data = nil
    end

  end
end
