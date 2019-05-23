require 'util'
require "LSlib/lib"

-- Create class
Traincontroller.Gui = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Traincontroller.Gui:onInit()
  if not global.TC_data.Gui then
    global.TC_data.Gui = self:initGlobalData()
  end
end



-- Initiation of the global data
function Traincontroller.Gui:initGlobalData()
  local gui = {
    ["version"      ] = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes
    ["clickHandler" ] = self:initClickHandlerData(),
    ["openedEntity" ] = {} -- opened entity for each player
  }

  return util.table.deepcopy(gui)
end



local trainControllerGui = require("prototypes.guilayout.traincontroller")
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
    "statistics-station-id-value"          , -- controller name
    "statistics-depot-request-value"       , -- depot request amount
    "statistics-builder-status-value"      , -- controller status
    "statistics-builder-configuration-flow", -- controller configuration
  } do
    updateElementPath[statisticsTabElementName] = LSlib.gui.layout.getElementPath(trainControllerGui, statisticsTabElementName)
  end

  return {
    -- gui layout
    ["trainControllerGui"] = trainControllerGui,

    -- gui element paths (derived from layout)
    ["tabButtonPath"     ] = tabButtonPath     ,
    ["updateElementPath" ] = updateElementPath ,
  }
end



function Traincontroller.Gui:initClickHandlerData()
  local clickHandlers = {}

  ------------------------------------------------------------------------------
  -- tab button handler
  ------------------------------------------------------------------------------
  local tabButtonNames = {
    "traincontroller-tab-selection" ,
    "traincontroller-tab-statistics",
  }

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
    for _,tabButtonName in pairs(tabButtonNames) do
      tabButtonFlow[tabButtonName].style = (tabButtonName == clickedTabButtonName and "LSlib_default_tab_button_selected" or "LSlib_default_tab_button")
      tabContentFlow[tabButtonName].visible = (tabButtonName == clickedTabButtonName)
    end
  end

  for _,tabButtonName in pairs(tabButtonNames) do
    clickHandlers[tabButtonName] = tabButtonHandler
  end



  ------------------------------------------------------------------------------
  -- statistics
  ------------------------------------------------------------------------------
  clickHandlers["statistics-station-id-edit"] = function(clickedElement, playerIndex)
    local tabToOpen = "traincontroller-tab-selection"
    clickHandlers[tabToOpen](LSlib.gui.getElement(playerIndex, self:getTabElementPath(tabToOpen)), playerIndex) -- mimic tab pressed
  end

  --[[clickHandlers["statistics-builder-configuration-button-recipe"] = function(clickedElement, playerIndex)
    --game.get_player(playerIndex).print("clicked!")
    local trainAssemblerIndex = tonumber(clickedElement.parent.name)
    local trainBuilder = Trainassembly:getTrainBuilder(Traincontroller:getTrainBuilderIndex(self:getOpenedEntity(playerIndex)))
    local trainAssemblerLocation = trainBuilder[trainAssemblerIndex]
    local trainAssembler = Trainassembly:getMachineEntity(trainAssemblerLocation.surfaceIndex, trainAssemblerLocation.position)

    game.get_player(playerIndex).print(trainAssembler.get_recipe().products[1].name)
    trainAssembler.set_recipe(nil) -- remove recipe
    game.get_player(playerIndex).opened = trainAssembler -- open the UI
  end]]

  clickHandlers["statistics-builder-configuration-button-rotate"] = function(clickedElement, playerIndex)
    -- get the trainbuilder
    local trainBuilder = Trainassembly:getTrainBuilder(Traincontroller:getTrainBuilderIndex(self:getOpenedEntity(playerIndex)))
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

  ------------------------------------------------------------------------------
  -- select train depot name
  ------------------------------------------------------------------------------
  clickHandlers["selected-depot-list"] = function(clickedElement, playerIndex)
    local listboxElement = LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("selected-depot-list"))

    LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("selected-depot-name")).caption = listboxElement.get_item(listboxElement.selected_index)
  end

  clickHandlers["selected-depot-enter"] = function(clickedElement, playerIndex)
    local controllerEntity  = self:getOpenedEntity(playerIndex)
    local oldControllerName = controllerEntity.backer_name
    local newControllerName = LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("selected-depot-name")).caption

    if newControllerName ~= oldControllerName then
      controllerEntity.backer_name = newControllerName -- invokes the rename event which will update UI's
      --self:updateGuiInfo(playerIndex)
    end

    -- mimic tab pressed to go back to statistics tab
    local tabToOpen = "traincontroller-tab-statistics"
    clickHandlers[tabToOpen](LSlib.gui.getElement(playerIndex, self:getTabElementPath(tabToOpen)), playerIndex)
  end

  --------------------
  return clickHandlers
end



--------------------------------------------------------------------------------
-- Setter functions to alter data into the data structure
--------------------------------------------------------------------------------
function Traincontroller.Gui:setOpenedEntity(playerIndex, openedEntity)
  global.TC_data.Gui["openedEntity"][playerIndex] = openedEntity
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Traincontroller.Gui:getControllerGuiLayout()
  return global.TC_data.Gui["prototypeData"]["trainControllerGui"]
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
  local controllerStatus = Traincontroller.Builder:getControllerStatus(self:getOpenedEntity(playerIndex))
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



function Traincontroller.Gui:getOpenedEntity(playerIndex)
  return global.TC_data.Gui["openedEntity"][playerIndex]
end



function Traincontroller.Gui:hasOpenedGui(playerIndex)
  return self:getOpenedEntity(playerIndex) and true or false
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
  return LSlib.gui.destroy(playerIndex, self:getControllerGuiLayout())
end



function Traincontroller.Gui:updateGuiInfo(playerIndex)
  -- We expect the gui to be created already
  local trainDepotGui = LSlib.gui.getElement(playerIndex, LSlib.gui.layout.getElementPath(self:getControllerGuiLayout(), self:getGuiName()))
  if not trainDepotGui then return end -- gui was not created, nothing to update

  -- data from the traindepo we require to update
  local openedEntity           = self:getOpenedEntity(playerIndex)
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
  configurationElement.clear()
  for trainAssemblerIndex,trainAssemblerLocation in trainBuilderIterator(trainBuilder) do
    local trainAssembler = Trainassembly:getMachineEntity(trainAssemblerLocation.surfaceIndex, trainAssemblerLocation.position)
    if trainAssembler and trainAssembler.valid then
      local trainAssemblerRecipe = trainAssembler.get_recipe()

      local flow = configurationElement.add{
        type      = "flow",
        name      = string.format("%i", trainAssemblerIndex),
        direction = "vertical",
        style     = "traincontroller_configuration_flow",
      }

      flow.add{
        type   = "sprite-button",
        name   = "statistics-builder-configuration-button-recipe",
        sprite = trainAssemblerRecipe and string.format("%s-%s", trainAssemblerRecipe.products[1].name, trainAssembler.direction == controllerDirection and "L" or "R"),
      }
      flow.add{
        type   = "sprite-button",
        name   = "statistics-builder-configuration-button-rotate",
        sprite = "utility/refresh",
      }
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

end



function Traincontroller.Gui:updateOpenedGuis(updatedControllerEntity, upgradeDepots)

  for _,player in pairs(game.connected_players) do -- no need to check all players
    local openedEntity = self:getOpenedEntity(player.index)
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
    self:setOpenedEntity(playerIndex, openedEntity)
    game.players[playerIndex].opened = self:createGui(playerIndex)
  end
end



-- When a player opens/closes a gui
function Traincontroller.Gui:onCloseEntity(openedGui, playerIndex)
  if openedGui and openedGui.valid and openedGui.name == self:getGuiName() then
    self:setOpenedEntity(playerIndex, nil)
    game.players[playerIndex].opened = self:destroyGui(playerIndex)
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



function Traindepot.Gui:onPlayerLeftGame(playerIndex)
  -- Called after a player leaves the game.
  if self:hasOpenedGui(playerIndex) then
    self:onCloseEntity(game.players[playerIndex].opened, playerIndex)
  end
end
