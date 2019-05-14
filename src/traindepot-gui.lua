require 'util'
require "LSlib/lib"

-- Create class
Traindepot.Gui = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Traindepot.Gui:onInit()
  if not global.TD_data.Gui then
    global.TD_data.Gui = self:initGlobalData()
  end
end



-- Initiation of the global data
function Traindepot.Gui:initGlobalData()
  local gui = {
    ["version"] = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes
    ["clickHandler"] = self:initClickHandlerData(),
  }

  return util.table.deepcopy(gui)
end



local traindepotGui = require("prototypes.guilayout.traindepot")
function Traindepot.Gui:initPrototypeData()
  local tabButtonPath = {}
  for _,tabButtonName in pairs{
    "traindepot-tab-selection" ,
    "traindepot-tab-statistics",
  } do
    tabButtonPath[tabButtonName] = LSlib.gui.layout.getElementPath(traindepotGui, tabButtonName)
  end

  return {
    ["traindepotGui"] = util.table.deepcopy(traindepotGui),
    ["tabButtonPath"] = util.table.deepcopy(tabButtonPath),
  }
end



function Traindepot.Gui:initClickHandlerData()
  local clickHandlers = {}

  ------------------------------------------------------------------------------
  -- tab button handler
  ------------------------------------------------------------------------------
  local tabButtonNames = {
    "traindepot-tab-selection" ,
    "traindepot-tab-statistics",
  }

  local tabButtonHandler = function(clickedTabButtonName, playerIndex)
    -- Get the flow with all the buttons
    local tabButtonFlow = LSlib.gui.getElement(playerIndex, self:getElementPath(clickedTabButtonName))
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

  ------------------------------------------------------------------------------
  return clickHandlers
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Traindepot.Gui:getDepotGuiLayout()
  return global.TD_data.Gui["prototypeData"]["traindepotGui"]
end



function Traindepot.Gui:getElementPath(guiElementName)
  return global.TD_data.Gui["prototypeData"]["tabButtonPath"][guiElementName]
end



function Traindepot.Gui:getClickHandler(guiElementName)
  return global.TD_data.Gui["clickHandler"][guiElementName]
end



function Traindepot.Gui:getGuiName()
  return LSlib.gui.getRootElementName(self:getDepotGuiLayout())
end



--------------------------------------------------------------------------------
-- Gui functions
--------------------------------------------------------------------------------
function Traindepot.Gui:createGui(playerIndex)
  local trainDepoGui = LSlib.gui.create(playerIndex, self:getDepotGuiLayout())
  self:updateGuiInfo(playerIndex)
  return trainDepoGui
end



function Traindepot.Gui:destroyGui(playerIndex)
  return LSlib.gui.destroy(playerIndex, self:getDepotGuiLayout())
end



function Traindepot.Gui:updateGuiInfo(playerIndex)
  -- TODO
end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player opens a gui
function Traindepot.Gui:onOpenEntity(openedEntity, playerIndex)
  if openedEntity and openedEntity.name == Traindepot:getDepotEntityName() then
    game.players[playerIndex].opened = self:createGui(playerIndex)
  end
end



-- When a player opens/closes a gui
function Traindepot.Gui:onCloseEntity(openedGui, playerIndex)
  if openedGui and openedGui.name == self:getGuiName() then
    game.players[playerIndex].opened = self:destroyGui(playerIndex)
  end
end



-- When a player clicks on the gui
function Traindepot.Gui:onClickElement(clickedElementName, playerIndex)
  local clickHandler = Traindepot.Gui:getClickHandler(clickedElementName)
  if clickHandler then clickHandler(clickedElementName, playerIndex) end
end
