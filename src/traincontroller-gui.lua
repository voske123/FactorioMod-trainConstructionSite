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
  for _,statisticsTabElementName in pairs{
    "statistics-station-id-value"    , -- controller name
    "statistics-depot-request-value" , -- depot request amount
    "statistics-builder-status-value", -- controller status
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

  local tabButtonHandler = function(clickedTabButtonName, playerIndex)
    -- Get the flow with all the buttons
    local tabButtonFlow = LSlib.gui.getElement(playerIndex, self:getTabElementPath(clickedTabButtonName))
    if not tabButtonFlow then return end
    tabButtonFlow = tabButtonFlow.parent
    if not tabButtonFlow then return end

    -- Get the flow with all the contents
    local tabContentFlow = tabButtonFlow.parent
    if not tabContentFlow then return end
    tabContentFlow = tabContentFlow[tabContentFlow.name .. "-content"]
    if not tabContentFlow then return end

    -- For each button in the flow, set the new style and set the tabs
    for _,tabButtonName in pairs(tabButtonNames) do
      tabButtonFlow[tabButtonName].style = (tabButtonName == clickedTabButtonName and "LSlib_default_tab_button_selected" or "LSlib_default_tab_button")
      tabContentFlow[tabButtonName].visible = (tabButtonName == clickedTabButtonName)
    end
  end

  for _,tabButtonName in pairs(tabButtonNames) do
    clickHandlers[tabButtonName] = tabButtonHandler
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
  local controllerName         = openedEntity and openedEntity.valid and openedEntity.backer_name or ""
  local controllerForceName    = openedEntity and openedEntity.valid and openedEntity.force.name or ""
  local controllerSurfaceIndex = openedEntity and openedEntity.valid and openedEntity.surface.index or player.surface.index or 1

  local depotForceName    = Traincontroller:getDepotForceName(controllerForceName)
  local depotRequestCount = Traindepot:getDepotRequestCount(depotForceName, controllerSurfaceIndex, controllerName)
  local depotTrainCount   = Traindepot:getNumberOfTrainsPathingToDepot(controllerSurfaceIndex, controllerName)

  -- statistics ----------------------------------------------------------------
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-station-id-value")).caption = controllerName
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-depot-request-value")).caption = string.format(
    "%i/%i", depotTrainCount, depotRequestCount)
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-builder-status-value")).caption = self:getOpenedControllerStatusString(playerIndex)
end



function Traincontroller.Gui:updateOpenedGuis(updatedControllerEntity)
  for _,player in pairs(game.connected_players) do -- no need to check all players
    local openedEntity = self:getOpenedEntity(player.index)
    if openedEntity and openedEntity == updatedControllerEntity then
      self:updateGuiInfo(player.index)
    end
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
function Traincontroller.Gui:onClickElement(clickedElementName, playerIndex)
  if self:hasOpenedGui(playerIndex) then
    local clickHandler = self:getClickHandler(clickedElementName)
    if clickHandler then clickHandler(clickedElementName, playerIndex) end
  end
end



function Traindepot.Gui:onPlayerLeftGame(playerIndex)
  -- Called after a player leaves the game.
  if self:hasOpenedGui(playerIndex) then
    self:onCloseEntity(game.players[playerIndex].opened, playerIndex)
  end
end
