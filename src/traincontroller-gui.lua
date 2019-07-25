require 'util'
require("__LSlib__/LSlib")

-- Create class
Traincontroller.Gui = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Traincontroller.Gui:onInit()
  if not global.TC_data.Gui then
    global.TC_data.Gui = self:initGlobalData()
    self:initEntityPreviewSurface()
  end
end



-- Initiation of the global data
function Traincontroller.Gui:initGlobalData()
  local gui = {
    ["version"       ] = 1, -- version of the global data
    ["surfaceName"   ] = "trainConstructionSite",
    ["prototypeData" ] = self:initPrototypeData(), -- data storing info about the prototypes
    ["clickHandler"  ] = self:initClickHandlerData(),
    ["openedEntities"] = {} -- opened entity for each player
  }

  return util.table.deepcopy(gui)
end



local trainControllerGui = require "prototypes.gui.layout.traincontroller"
function Traincontroller.Gui:initPrototypeData()
  -- tabButtonPath
  local tabButtonPath = {}
  for _,tabButtonName in pairs{
    "traincontroller-tab-selection" ,
    "traincontroller-tab-statistics",
  } do
    tabButtonPath[tabButtonName] = LSlib.gui.layout.getElementPath(trainControllerGui, tabButtonName)
  end

  -- updateElementPath
  local updateElementPath = {}
  for _,selectionTabElementName in pairs{
    "selected-depot-name", -- current/new depot name
    "selected-depot-list", -- list of all depot names
  } do
    updateElementPath[selectionTabElementName] = LSlib.gui.layout.getElementPath(trainControllerGui, selectionTabElementName)
  end
  for _,statisticsTabElementName in pairs{
    "statistics-station-id-value"                , -- controller name
    "statistics-depot-request-value"             , -- depot request amount
    "statistics-builder-status-value"            , -- controller status
    "statistics-builder-configuration-flow"      , -- controller configuration

    "traincontroller-color-picker"               , -- color picking frame
    "traincontroller-color-picker-entity-preview", -- color picker entity preview
  } do
    updateElementPath[statisticsTabElementName] = LSlib.gui.layout.getElementPath(trainControllerGui, statisticsTabElementName)
  end

  return {
    -- gui layout
    ["trainControllerGui"] = trainControllerGui,

    -- gui element paths (derived from layout)
    ["tabButtonPath"     ] = tabButtonPath     ,
    ["updateElementPath" ] = updateElementPath ,

    ["recipeSelector"    ] = Trainassembly:getMachineEntityName() .. "-recipe-selector"
  }
end



function Traincontroller.Gui:initEntityPreviewSurface()
  if not game.surfaces[self:getControllerSurfaceName()] then
    game.create_surface(self:getControllerSurfaceName(), {
      -- TERRAIN SPECIFICATION --
      terrain_segmentation = 0,
      water = 0, -- no water
      width  = 0, -- infinite
      height = 10,

      -- AUTOPLACE SETTINGS --
      autoplace_controls = nil,
      default_enable_all_autoplace_controls = false, -- autoplace not set, disallow to get default controls
      autoplace_settings = nil,
      cliff_settings = nil, -- no cliffs
      seed   = 0, -- doesn't matter, just has to be something

      starting_area   = 0,    -- no starting area generation procedure
      starting_points = {},   -- no starting points on this map
      peaceful_mode   = true, -- doesn't mater, no biters are autoplaced

      property_expression_names = {
        ["moisture"            ] = 1,
        ["aux"                 ] = .5,
        ["temperature"         ] = -20,
        ["elevation"           ] = 1,
        ["cliffiness"          ] = 0,
        ["enemy-base-intensity"] = 0,
        ["enemy-base-frequency"] = 0,
        ["enemy-base-radius"   ] = 0
      },
    })

    for playerIndex,_ in pairs(game.players) do
      self:initEntityPreviewPlayer(playerIndex)
    end
  end
end



function Traincontroller.Gui:initEntityPreviewPlayer(playerIndex)
  local radius = 10
  local surface = game.surfaces[self:getControllerSurfaceName()]

  for x = -radius, radius, 2 do
    surface.create_entity{
      name = "straight-rail",
      position = {
        x = x + 3*radius*playerIndex,
        y = 0
      },
      direction = defines.direction.east,
      force = game.get_player(playerIndex).force,
      player = playerIndex,
    }
  end
end



function Traincontroller.Gui:initClickHandlerData()
  local clickHandlers = {}

  ------------------------------------------------------------------------------
  -- help button handler
  ------------------------------------------------------------------------------
  clickHandlers["traincontroller-help"] = function(clickedElement, playerIndex)
    -- close this UI
    game.players[playerIndex].opened = Traincontroller.Gui:destroyGui(playerIndex)
    Traincontroller.Gui:setOpenedControllerEntity(playerIndex, nil)

    -- open the new UI
    Help.Gui:openGui(playerIndex)
  end



  ------------------------------------------------------------------------------
  -- tab button handler
  ------------------------------------------------------------------------------
  local tabButtonHandler = function(clickedTabButton, playerIndex)

    -- Get the flow with all the buttons
    if clickedTabButton.type ~= "button" then return end -- clicked on content
    local tabButtonFlow = clickedTabButton.parent

    -- Get the flow with all the contents
    local tabContentFlow = tabButtonFlow.parent
    tabContentFlow = tabContentFlow[tabContentFlow.name .. "-content"]
    if not tabContentFlow then return end

    -- For each button in the flow, set the new style and set the tabs
    local clickedTabButtonName = clickedTabButton.name
    for _,tabButtonName in pairs{
      "traincontroller-tab-selection" ,
      "traincontroller-tab-statistics",
    } do
      tabButtonFlow[tabButtonName].style = (tabButtonName == clickedTabButtonName and "LSlib_default_tab_button_selected" or "LSlib_default_tab_button")
      tabContentFlow[tabButtonName].visible = (tabButtonName == clickedTabButtonName)
    end
  end

  for _,tabButtonName in pairs{
    "traincontroller-tab-selection" ,
    "traincontroller-tab-statistics",
  } do
    clickHandlers[tabButtonName] = tabButtonHandler
  end



  ------------------------------------------------------------------------------
  -- statistics
  ------------------------------------------------------------------------------
  clickHandlers["statistics-station-id-edit"] = function(clickedElement, playerIndex)
    local tabToOpen = "traincontroller-tab-selection"
    Traincontroller.Gui:getClickHandler(tabToOpen)(LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getTabElementPath(tabToOpen)), playerIndex) -- mimic tab pressed
  end



  --[[clickHandlers["statistics-builder-configuration-button-recipe"] = function(clickedElement, playerIndex)
    local player = game.get_player(playerIndex)
    local recipeEntity =  player.surface.create_entity{
      name     = Traincontroller.Gui:getRecipeSelectorEntityName(),
      position = player.position,
      force    = player.force,
    }
    Traincontroller.Gui:setOpenedRecipeEntity(playerIndex, recipeEntity)
    player.opened = recipeEntity
  end]]



  clickHandlers["statistics-builder-configuration-button-rotate"] = function(clickedElement, playerIndex)
    -- get the trainbuilder
    local trainBuilder = Trainassembly:getTrainBuilder(Traincontroller:getTrainBuilderIndex(Traincontroller.Gui:getOpenedControllerEntity(playerIndex)))
    if not trainBuilder then return end

    -- get the assembler
    local trainAssemblerLocation = trainBuilder[tonumber(clickedElement.parent.name)]
    local trainAssembler = Trainassembly:getMachineEntity(trainAssemblerLocation.surfaceIndex, trainAssemblerLocation.position)
    if not (trainAssembler and trainAssembler.valid) then return end

    -- rotate the assembler
    local previous_direction = trainAssembler.direction
    trainAssembler.rotate()
    script.raise_event(defines.events.on_player_rotated_entity, {
      entity = trainAssembler,
      previous_direction = previous_direction,
      player_index = playerIndex
    })
  end



  clickHandlers["statistics-builder-configuration-button-color"] = function(clickedElement, playerIndex)
    local clickedElementStyle = "traincontroller_color_indicator_button_housing"
    local colorPickerFrame = LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getUpdateElementPath("traincontroller-color-picker"))

    if clickedElement.style.name == clickedElementStyle then
      if colorPickerFrame.visible then
        -- another picker is open, we simulate clicking the discard button
        Traincontroller.Gui:getClickHandler("traincontroller-color-picker-button-discard")(clickedElement, playerIndex)
      end

      -- set the button as selected
      clickedElement.style = clickedElement.style.name .. "_pressed"

      -- set the color picker ui visible
      colorPickerFrame.visible = true

      -- set the colorPicker to the currently active color
      local color = clickedElement[clickedElement.name].style.color or {}
      local colorName = "traincontroller-color-picker-%s"
      for _, colorIndex in pairs{"r", "g", "b"} do
        local colorPickerIndexFrame = colorPickerFrame[string.format(colorName, "flow-"..colorIndex)]
        local colorPickerIndexValue = math.floor(.5 + (color[colorIndex] or 0) * 255)
        colorPickerIndexFrame[string.format(colorName, "slider"   )].slider_value = colorPickerIndexValue
        colorPickerIndexFrame[string.format(colorName, "textfield")].text         = colorPickerIndexValue
      end

      -- set the entity-preview entity
      local entityRadius = 10
      local entityPreviewEntity = game.surfaces[Traincontroller.Gui:getControllerSurfaceName()].create_entity{
        name      = string.sub(clickedElement.parent["statistics-builder-configuration-button-recipe"].sprite, 7, -7),
        position  = {x = 3*entityRadius*playerIndex,
                     y = 0                         },
        direction = defines.direction.east,
        force     = game.get_player(playerIndex).force,
        player    = playerIndex,
      }
      if entityPreviewEntity then
        entityPreviewEntity.get_fuel_inventory().insert{
          name = "trainassembly-trainfuel",
          count = 1
        }
        entityPreviewEntity.color = {r=color.r, g=color.g, b=color.b, a = 127/255}

        local previewElement = LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getUpdateElementPath("traincontroller-color-picker-entity-preview"))
        previewElement.entity = entityPreviewEntity
      else
        game.print(string.format("entity preview for %q could not be added at position {%i, %i}",
          string.sub(clickedElement.parent["statistics-builder-configuration-button-recipe"].sprite, 7, -7),
          3*entityRadius*playerIndex, 0
        ))
      end
    else
      -- simulate clicking the discard button
      Traincontroller.Gui:getClickHandler("traincontroller-color-picker-button-discard")(clickedElement, playerIndex)
    end
  end



  ------------------------------------------------------------------------------
  -- color pickers
  ------------------------------------------------------------------------------
  clickHandlers["traincontroller-color-picker-button-discard"] = function(clickedElement, playerIndex)

    -- STEP 1: set color picker hidden
    LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getUpdateElementPath("traincontroller-color-picker")).visible = false

    -- also remove the entity-preview entity
    local entityRadius = 10
    game.surfaces[Traincontroller.Gui:getControllerSurfaceName()].find_entities_filtered{
      name      = "straight-rail",
      invert    = true,
      position  = {x = 3*entityRadius*playerIndex,
                   y = 0                         },
      radius    = entityRadius,
      limit     = 1,
    }[1].destroy()

    -- STEP 2: find the selected one
    local clickedElementStyle        = "traincontroller_color_indicator_button_housing"
    local clickedElementPressedStyle = clickedElementStyle.."_pressed"
    local configurationElement = LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getUpdateElementPath("statistics-builder-configuration-flow"))

    for _, assemblerElementIndex in pairs(configurationElement.children_names) do
      local colorElement = configurationElement[assemblerElementIndex]["statistics-builder-configuration-button-color"]
      if colorElement and colorElement.style.name == clickedElementPressedStyle then
        -- found the selected one

        -- STEP 3: reset the color button
        colorElement.style = clickedElementStyle

        local trainBuilder = Trainassembly:getTrainBuilder(Traincontroller:getTrainBuilderIndex(Traincontroller.Gui:getOpenedControllerEntity(playerIndex)))
        if trainBuilder then
          local trainAssemblerLocation = trainBuilder[tonumber(assemblerElementIndex)]
          colorElement[colorElement.name].style.color = Trainassembly:getMachineTint(Trainassembly:getMachineEntity(trainAssemblerLocation.surfaceIndex, trainAssemblerLocation.position))
        end

        break -- no need to look further
      end
    end
  end



  clickHandlers["traincontroller-color-picker-button-confirm"] = function(clickedElement, playerIndex)

    -- STEP 1: set color picker hidden
    LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getUpdateElementPath("traincontroller-color-picker")).visible = false

    -- also remove the entity-preview entity
    local entityRadius = 10
    game.surfaces[Traincontroller.Gui:getControllerSurfaceName()].find_entities_filtered{
      name      = "straight-rail",
      invert    = true,
      position  = {x = 3*entityRadius*playerIndex,
                   y = 0                         },
      radius    = entityRadius,
      limit     = 1,
    }[1].destroy()

    -- STEP 2: find the selected one
    local clickedElementStyle        = "traincontroller_color_indicator_button_housing"
    local clickedElementPressedStyle = clickedElementStyle.."_pressed"
    local configurationElement = LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getUpdateElementPath("statistics-builder-configuration-flow"))

    for _, assemblerElementIndex in pairs(configurationElement.children_names) do
      local colorElement = configurationElement[assemblerElementIndex]["statistics-builder-configuration-button-color"]
      if colorElement and colorElement.style.name == clickedElementPressedStyle then
        -- found the selected one

        -- STEP 3: reset the color button
        colorElement.style = clickedElementStyle

        -- STEP 4: save the machine tint
        local controllerEntity = Traincontroller.Gui:getOpenedControllerEntity(playerIndex)
        local trainAssemblerLocation = Trainassembly:getTrainBuilder(Traincontroller:getTrainBuilderIndex(controllerEntity))[tonumber(assemblerElementIndex)]
        Trainassembly:setMachineTint(Trainassembly:getMachineEntity(trainAssemblerLocation.surfaceIndex, trainAssemblerLocation.position), colorElement[colorElement.name].style.color)

        -- STEP 5: update opened UI's
        Traincontroller.Gui:updateOpenedGuis(controllerEntity)

        break -- no need to look further
      end
    end

  end



  clickHandlers["traincontroller-color-picker-textfield"] = function(clickedElement, playerIndex)
    local clickedElementValue = clickedElement.text
    clickedElementValue = tonumber(clickedElementValue ~= "" and clickedElementValue or "0") -- if "", we assume 0
    local oldClickedElementValue = clickedElementValue
    if clickedElementValue then -- valid number

      -- STEP1: make sure the value is within limits
      if clickedElementValue < 0   then
        clickedElementValue = 0
      elseif clickedElementValue > 255 then
        clickedElementValue = 255
      else
        clickedElementValue = math.floor(.5 + clickedElementValue)
      end
      if clickedElementValue ~= oldClickedElementValue then
        clickedElement.text = clickedElementValue
      end

      -- STEP2: set the slider value
      local sliderElement = clickedElement.parent["traincontroller-color-picker-slider"]
      if math.floor(.5 + sliderElement.slider_value) ~= clickedElementValue then
        sliderElement.slider_value = clickedElementValue
      else
        return -- no update required
      end

      -- STEP3: update the color button
      local clickedElementStyle        = "traincontroller_color_indicator_button_housing"
      local clickedElementPressedStyle = clickedElementStyle.."_pressed"
      local configurationElement = LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getUpdateElementPath("statistics-builder-configuration-flow"))

      local color
      for _, assemblerElementIndex in pairs(configurationElement.children_names) do
        local colorElement = configurationElement[assemblerElementIndex]["statistics-builder-configuration-button-color"]
        if colorElement and colorElement.style.name == clickedElementPressedStyle then
          -- found the selected one

          color = colorElement[colorElement.name].style.color
          color[string.sub(clickedElement.parent.name, -1)] = clickedElementValue/255
          colorElement[colorElement.name].style.color = color

          break -- no need to look further
        end
      end

      -- STEP4: update the entity preview
      if color then
        local entityRadius = 10
        game.surfaces[Traincontroller.Gui:getControllerSurfaceName()].find_entities_filtered{
          name      = "straight-rail",
          invert    = true,
          position  = {x = 3*entityRadius*playerIndex,
                       y = 0                         },
          radius    = entityRadius,
          limit     = 1,
        }[1].color = {
          r = color.r,
          g = color.g,
          b = color.b,
          a = 127/255, -- hardcoded for vanilla trains
        }
      end

    else -- invalid number
      -- reset the content of the element to the value on the slider
      clickedElement.text = math.floor(.5 + clickedElement.parent["traincontroller-color-picker-slider"].slider_value)
    end
  end



  clickHandlers["traincontroller-color-picker-slider"] = function(clickedElement, playerIndex)
    -- STEP 1: update the textfield
    local clickedElementValue = math.floor(.5 + clickedElement.slider_value)
    local textfieldElement = clickedElement.parent["traincontroller-color-picker-textfield"]
    if tonumber(textfieldElement.text) ~= clickedElementValue then
      textfieldElement.text = clickedElementValue
    else
      return -- no update required
    end

    -- STEP 2: update the color button
    local clickedElementStyle        = "traincontroller_color_indicator_button_housing"
    local clickedElementPressedStyle = clickedElementStyle.."_pressed"
    local configurationElement = LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getUpdateElementPath("statistics-builder-configuration-flow"))

    local color
    for _, assemblerElementIndex in pairs(configurationElement.children_names) do
      local colorElement = configurationElement[assemblerElementIndex]["statistics-builder-configuration-button-color"]
      if colorElement and colorElement.style.name == clickedElementPressedStyle then
        -- found the selected one

        color = colorElement[colorElement.name].style.color
        color[string.sub(clickedElement.parent.name, -1)] = clickedElementValue/255
        colorElement[colorElement.name].style.color = color

        break -- no need to look further
      end
    end

    -- STEP4: update the entity preview
    if color then
      local entityRadius = 10
      game.surfaces[Traincontroller.Gui:getControllerSurfaceName()].find_entities_filtered{
        name      = "straight-rail",
        invert    = true,
        position  = {x = 3*entityRadius*playerIndex,
                     y = 0                         },
        radius    = entityRadius,
        limit     = 1,
      }[1].color = {
        r = color.r,
        g = color.g,
        b = color.b,
        a = 127/255, -- hardcoded for vanilla trains
      }
    end

  end



  ------------------------------------------------------------------------------
  -- select train depot name
  ------------------------------------------------------------------------------
  clickHandlers["selected-depot-list"] = function(clickedElement, playerIndex)
    local listboxElement = LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getUpdateElementPath("selected-depot-list"))

    LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getUpdateElementPath("selected-depot-name")).caption = listboxElement.get_item(listboxElement.selected_index)
  end



  clickHandlers["selected-depot-enter"] = function(clickedElement, playerIndex)
    local controllerEntity  = Traincontroller.Gui:getOpenedControllerEntity(playerIndex)
    local oldControllerName = controllerEntity.backer_name
    local newControllerName = LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getUpdateElementPath("selected-depot-name")).caption

    if newControllerName ~= oldControllerName then
      controllerEntity.backer_name = newControllerName -- invokes the rename event which will update UI's
      --Traincontroller.Gui:updateGuiInfo(playerIndex)
    end

    -- mimic tab pressed to go back to statistics tab
    local tabToOpen = "traincontroller-tab-statistics"
    Traincontroller.Gui:getClickHandler(tabToOpen)(LSlib.gui.getElement(playerIndex, Traincontroller.Gui:getTabElementPath(tabToOpen)), playerIndex)
  end



  --------------------
  return clickHandlers
end



--------------------------------------------------------------------------------
-- Setter functions to alter data into the data structure
--------------------------------------------------------------------------------
function Traincontroller.Gui:setOpenedControllerEntity(playerIndex, openedEntity)
  if not global.TC_data.Gui["openedEntities"][playerIndex] then
    global.TC_data.Gui["openedEntities"][playerIndex] = {}
  end
  global.TC_data.Gui["openedEntities"][playerIndex]["traincontroller"] = openedEntity
end



function Traincontroller.Gui:setOpenedRecipeEntity(playerIndex, openedEntity)
  if not global.TC_data.Gui["openedEntities"][playerIndex] then
    global.TC_data.Gui["openedEntities"][playerIndex] = {}
  end
  global.TC_data.Gui["openedEntities"][playerIndex]["traincontroller-recipe"] = openedEntity
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Traincontroller.Gui:getControllerSurfaceName()
  return global.TC_data.Gui["surfaceName"]
end



function Traincontroller.Gui:getControllerGuiLayout()
  return global.TC_data.Gui["prototypeData"]["trainControllerGui"]
end



function Traincontroller.Gui:getRecipeSelectorEntityName()
  return global.TC_data.Gui["prototypeData"]["recipeSelector"]
end



function Traincontroller.Gui:getTabElementPath(guiElementName)
  return global.TC_data.Gui["prototypeData"]["tabButtonPath"][guiElementName]
end


function Traincontroller.Gui:getUpdateElementPath(guiElementName)
  return global.TC_data.Gui["prototypeData"]["updateElementPath"][guiElementName]
end



function Traincontroller.Gui:getClickHandler(guiElementName)
  return global.TC_data.Gui["clickHandler"][guiElementName]
end



function Traincontroller.Gui:getGuiName()
  return LSlib.gui.getRootElementName(self:getControllerGuiLayout())
end



function Traincontroller.Gui:getOpenedControllerStatusString(playerIndex)
  local controllerStatus = Traincontroller.Builder:getControllerStatus(self:getOpenedControllerEntity(playerIndex))
  local controllerStates  = global.TC_data.Builder["builderStates"]

  if controllerStatus == controllerStates["idle"] then
    -- wait until a depot request a train
    return {"gui-traincontroller.controller-status-wait-to-dispatch"}

  elseif controllerStatus == controllerStates["building"] then
    -- waiting on resources, building each component
    return {"gui-traincontroller.controller-status-building-train"}

  elseif controllerStatus == controllerStates["dispatching"] then
    -- waiting till previous train clears the train block
    return {"gui-traincontroller.controller-status-ready-to-dispatch"}

  elseif controllerStatus == controllerStates["dispatch"] then
    -- assembling the train components together and let the train drive off
    return {"gui-traincontroller.controller-status-ready-to-dispatch"}

  else return "undefined status" end
end



function Traincontroller.Gui:getOpenedControllerEntity(playerIndex)
  if global.TC_data.Gui["openedEntities"][playerIndex] then
    return global.TC_data.Gui["openedEntities"][playerIndex]["traincontroller"]
  else
    return nil
  end
end



function Traincontroller.Gui:getOpenedRecipeEntity(playerIndex)
  if global.TC_data.Gui["openedEntities"][playerIndex] then
    return global.TC_data.Gui["openedEntities"][playerIndex]["traincontroller-recipe"]
  else
    return nil
  end
end



function Traincontroller.Gui:hasOpenedGui(playerIndex)
  return self:getOpenedControllerEntity(playerIndex) and true or false
end



--------------------------------------------------------------------------------
-- Gui functions
--------------------------------------------------------------------------------
function Traincontroller.Gui:createGui(playerIndex)
  local trainDepoGui = LSlib.gui.create(playerIndex, self:getControllerGuiLayout())
  self:updateGuiInfo(playerIndex)
  return trainDepoGui
end



function Traincontroller.Gui:destroyGui(playerIndex)
  -- make sure the color picker is closed first
  local colorPickerElement = LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("traincontroller-color-picker"))
  if colorPickerElement.visible then
    -- simulate clicking discard
    self:getClickHandler("traincontroller-color-picker-button-discard")(nil, playerIndex)
  end
  return LSlib.gui.destroy(playerIndex, self:getControllerGuiLayout())
end



function Traincontroller.Gui:updateGuiInfo(playerIndex)
  -- We expect the gui to be created already
  local trainDepotGui = LSlib.gui.getElement(playerIndex, LSlib.gui.layout.getElementPath(self:getControllerGuiLayout(), self:getGuiName()))
  if not trainDepotGui then return end -- gui was not created, nothing to update

  -- data from the traindepo we require to update
  local openedEntity           = self:getOpenedControllerEntity(playerIndex)
  if not (openedEntity and openedEntity.valid) then
    self:onCloseEntity(trainDepotGui, playerIndex)
  end

  local controllerName         = openedEntity.backer_name or ""
  local controllerForceName    = openedEntity.force.name or ""
  local controllerSurfaceIndex = openedEntity.surface.index or game.get_player(playerIndex).surface.index or 1
  local controllerDirection    = openedEntity.direction or defines.direction.north

  local depotForceName    = Traincontroller:getDepotForceName(controllerForceName)
  local depotRequestCount = Traindepot:getDepotRequestCount(depotForceName, controllerSurfaceIndex, controllerName)
  local depotTrainCount   = Traindepot:getNumberOfTrainsPathingToDepot(controllerSurfaceIndex, controllerName)

  local trainBuilder         = Trainassembly:getTrainBuilder(Traincontroller:getTrainBuilderIndex(openedEntity))
  local trainBuilderIterator = Trainassembly:getTrainBuilderIterator(controllerDirection)

  -- statistics ----------------------------------------------------------------
  -- controller depot name
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-station-id-value")).caption = controllerName

  -- requested amount of trains in depot
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-depot-request-value")).caption = string.format(
    "%i/%i", depotTrainCount, depotRequestCount)

  -- status of the builder
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-builder-status-value")).caption = self:getOpenedControllerStatusString(playerIndex)

  -- configuration
  local configurationElement = LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-builder-configuration-flow"))

  local colorPickerSelectedIndex -- extract the selected element first, required for the color picker
  local configurationElementCount = #configurationElement.children_names
  local colorPickerFrame = LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("traincontroller-color-picker"))
  local clickedElementStyle        = "traincontroller_color_indicator_button_housing"
  local clickedElementPressedStyle = clickedElementStyle.."_pressed"

  if colorPickerFrame.visible then
    for _, assemblerElementIndex in pairs(configurationElement.children_names) do
      local colorElement = configurationElement[assemblerElementIndex]["statistics-builder-configuration-button-color"]
      if colorElement and colorElement.style.name == clickedElementPressedStyle then
        -- found the selected one
        colorPickerSelectedIndex = assemblerElementIndex

        break -- no need to look further
      end
    end
  end

  configurationElement.clear()
  configurationElement.add{
    type      = "flow",
    name      = "0-traincontroller",
    direction = "vertical",
    style     = "traincontroller_configuration_flow",
  }.add{
    type    = "sprite-button",
    name    = "statistics-builder-configuration-button-recipe",
    tooltip = {"item-name.traincontroller", {"item-name.trainassembly"}},
    sprite  = string.format("item/%s", Traincontroller:getControllerItemName()),
    enabled = false,
  }
  for trainAssemblerIndex,trainAssemblerLocation in trainBuilderIterator(trainBuilder) do
    local trainAssembler = Trainassembly:getMachineEntity(trainAssemblerLocation.surfaceIndex, trainAssemblerLocation.position)
    if trainAssembler and trainAssembler.valid then
      local flow = configurationElement.add{
        type      = "flow",
        name      = string.format("%i", trainAssemblerIndex),
        direction = "vertical",
        style     = "traincontroller_configuration_flow",
      }

      local trainAssemblerRecipe = trainAssembler.get_recipe()
      if trainAssemblerRecipe then
        flow.add{
          type   = "sprite-button",
          name   = "statistics-builder-configuration-button-recipe",
          sprite = string.format("fluid/%s", trainAssemblerRecipe.products[1].name),
        }

        local trainAssemblyType = LSlib.utils.string.split(trainAssemblerRecipe.name, "[")[2]
        trainAssemblyType = trainAssemblyType:sub(1, trainAssemblyType:len()-1)
        if trainAssemblyType == "locomotive"      or
           trainAssemblyType == "artillery-wagon" then
          flow.add{
            type    = "sprite-button",
            name    = "statistics-builder-configuration-button-rotate",
            tooltip = {"controls.rotate"},
            sprite  = string.format("traincontroller-orientation-%s", trainAssembler.direction == controllerDirection and "L" or "R"),
          }

          if trainAssemblyType == "locomotive" then
            flow.add{
              type    = "button",
              name    = "statistics-builder-configuration-button-color",
              tooltip = {"gui-train.color"},
              style   = "traincontroller_color_indicator_button_housing",
            }.add{
              type  = "progressbar",
              name  = "statistics-builder-configuration-button-color",
              value = 1,
              style = "traincontroller_color_indicator_button_color",
              ignored_by_interaction = true,
            }.add{
              type   = "sprite-button",
              name   = "statistics-builder-configuration-button-color",
              sprite = "utility/color_picker",
              style  = "traincontroller_color_indicator_button_sprite",
              ignored_by_interaction = true,
            }.parent.style.color = Trainassembly:getMachineTint(trainAssembler)
          end
        end
      end

    end
  end



  -- select depot name ---------------------------------------------------------
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("selected-depot-name")).caption = controllerName

  -- name selection list
  local depotEntriesList = LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("selected-depot-list"))
  depotEntriesList.clear_items()

  local itemIndex = 1
  local orderedPairs = LSlib.utils.table.orderedPairs
  for trainDepotName,_ in orderedPairs(Traindepot:getDepotData(depotForceName, controllerSurfaceIndex)) do
    -- https://lua-api.factorio.com/latest/LuaGuiElement.html#LuaGuiElement.add_item
    depotEntriesList.add_item(trainDepotName)
    if trainDepotName == controllerName then
      depotEntriesList.selected_index = itemIndex
    end
    itemIndex = itemIndex + 1
  end

  -- color picker --------------------------------------------------------------
  if colorPickerFrame.visible then
    -- set the button to selected again, else we close the UI
    local colorPickerFrameValid = true
    if colorPickerSelectedIndex and configurationElementCount == #configurationElement.children_names then
      -- still the same amount of children, make sure the recipe is still the same
      local colorElement = configurationElement[string.format("%i", colorPickerSelectedIndex)]["statistics-builder-configuration-button-color"]
      if colorElement then
        -- set it selected again
        colorElement.style = clickedElementPressedStyle

        -- and we update the color
        local buttonColor = {}
        local colorName = "traincontroller-color-picker-%s"
        for _, colorIndex in pairs{"r", "g", "b"} do
          buttonColor[colorIndex] = math.floor(.5 + colorPickerFrame[string.format(colorName, "flow-"..colorIndex)][string.format(colorName, "slider")].slider_value)
        end
        colorElement[colorElement.name].style.color = buttonColor

      else
        -- no picker element anymore, close the UI
        colorPickerFrameValid = false
      end
    else -- no selected index found, or something got removed, we remove the picker
      colorPickerFrameValid = false
    end

    if not colorPickerFrameValid then
      -- close the UI as it is not needed anymore, simulate clicking discard
      self:getClickHandler("traincontroller-color-picker-button-discard")(nil, playerIndex)
    end

  end

end



function Traincontroller.Gui:updateOpenedGuis(updatedControllerEntity, upgradeDepots)

  for _,player in pairs(game.connected_players) do -- no need to check all players
    local openedEntity = self:getOpenedControllerEntity(player.index)
    if openedEntity then
      if openedEntity.valid and openedEntity.health > 0 then
        if openedEntity == updatedControllerEntity then
          self:updateGuiInfo(player.index)
        end
      else -- not valid/killed
        self:onCloseEntity(player.opened, player.index)
      end
    end
  end

  if upgradeDepots ~= false then upgradeDepots = true end
  if upgradeDepots and updatedControllerEntity.valid then
    Traindepot.Gui:updateOpenedGuis(updatedControllerEntity.backer_name)
  end
end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player opens a gui
function Traincontroller.Gui:onOpenEntity(openedEntity, playerIndex)
  if openedEntity and openedEntity.name == Traincontroller:getControllerEntityName() then
    self:setOpenedControllerEntity(playerIndex, openedEntity)
    game.players[playerIndex].opened = self:createGui(playerIndex)
  end
end



-- When a player opens/closes a gui
function Traincontroller.Gui:onCloseEntity(openedGui, playerIndex)
  if openedGui and openedGui.valid then
    if openedGui.name == self:getGuiName() then
      game.players[playerIndex].opened = self:destroyGui(playerIndex)
      self:setOpenedControllerEntity(playerIndex, nil)

    elseif openedGui.name == self:getRecipeSelectorEntityName() then
      -- TODO... at some point if I can get it working
    end
  end
end



-- When a player clicks on the gui
function Traincontroller.Gui:onClickElement(clickedElement, playerIndex)
  if self:hasOpenedGui(playerIndex) then
    if not clickedElement.valid then return end
    local clickHandler = self:getClickHandler(clickedElement.name)
    if clickHandler then clickHandler(clickedElement, playerIndex) end
  end
end



function Traincontroller.Gui:onPlayerCreated(playerIndex)
  -- Called after the player was created.
  self:initEntityPreviewPlayer(playerIndex)
end



function Traincontroller.Gui:onPlayerLeftGame(playerIndex)
  -- Called after a player leaves the game.
  if self:hasOpenedGui(playerIndex) then
    self:onCloseEntity(game.players[playerIndex].opened, playerIndex)
  end
end
