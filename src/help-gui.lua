require 'util'
require "LSlib/lib"

-- Create class
Help.Gui = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Help.Gui:onInit()
  if not global.H_data.Gui then
    global.H_data.Gui = self:initGlobalData()
  end
end



-- Initiation of the global data
function Help.Gui:initGlobalData()
  local gui = {
    ["version"      ] = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes
    ["clickHandler" ] = self:initClickHandlerData(),
    ["openedGui"    ] = {} -- opened entity for each player
  }

  return util.table.deepcopy(gui)
end



local helpGui = require "prototypes.gui.layout.help-gui"
function Help.Gui:initPrototypeData()
  -- tabButtonPath
  local tabButtonPath = {}
  for _,tabButtonName in pairs{
    --"traindepot-tab-selection" ,
    --"traindepot-tab-statistics",
  } do
    tabButtonPath[tabButtonName] = LSlib.gui.layout.getElementPath(trainDepotGui, tabButtonName)
  end

  return {
    -- gui layout
    ["helpGui"      ] = helpGui      ,

    -- gui element paths (derived from layout)
    ["tabButtonPath"] = tabButtonPath,
  }
end



function Help.Gui:initClickHandlerData()
  local clickHandlers = {}

  ------------------------------------------------------------------------------
  -- close button handler
  ------------------------------------------------------------------------------
  clickHandlers["traindepot-help"] = function(clickedElement, playerIndex)

  end



  ------------------------------------------------------------------------------
  -- tab button handler
  ------------------------------------------------------------------------------
  local tabButtonHandler = function(clickedTabButton, playerIndex)

  end

  for _,tabButtonName in pairs{
    --"traindepot-tab-selection" ,
    --"traindepot-tab-statistics",
  } do
    clickHandlers[tabButtonName] = tabButtonHandler
  end



  ------------------------------------------------------------------------------
  return clickHandlers
end



--------------------------------------------------------------------------------
-- Setter functions to alter data into the data structure
--------------------------------------------------------------------------------
function Help.Gui:setOpenedGui(playerIndex, openedHelpGui)
  global.H_data.Gui["openedGui"][playerIndex] = openedHelpGui
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Help.Gui:getHelpGuiLayout()
  return global.H_data.Gui["prototypeData"]["helpGui"]
end



function Help.Gui:getTabElementPath(guiElementName)
  return global.H_data.Gui["prototypeData"]["tabButtonPath"][guiElementName]
end



function Help.Gui:getClickHandler(guiElementName)
  return global.H_data.Gui["clickHandler"][guiElementName]
end



function Help.Gui:getGuiName()
  return LSlib.gui.getRootElementName(self:getHelpGuiLayout())
end



function Help.Gui:hasOpenedGui(playerIndex)
  return global.H_data.Gui["openedGui"][playerIndex] and true or false
end



--------------------------------------------------------------------------------
-- Gui functions
--------------------------------------------------------------------------------
function Help.Gui:createGui(playerIndex)
  return LSlib.gui.create(playerIndex, self:getHelpGuiLayout())
end



function Help.Gui:destroyGui(playerIndex)
  return LSlib.gui.destroy(playerIndex, self:getHelpGuiLayout())
end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player opens a gui
function Help.Gui:openGui(playerIndex)
  self:setOpenedGui(playerIndex, nil)
  game.players[playerIndex].opened = self:createGui(playerIndex)
end



-- When a player closes a gui/entity
function Help.Gui:onCloseEntity(openedGui, playerIndex)
  if openedGui and openedGui.valid and openedGui.name == self:getGuiName() then
    self:setOpenedGui(playerIndex, nil)
    game.players[playerIndex].opened = self:destroyGui(playerIndex)
  end
end



-- When a player clicks on the gui
function Help.Gui:onClickElement(clickedElement, playerIndex)
  if self:hasOpenedGui(playerIndex) then
    if not clickedElement.valid then return end
    local clickHandler = self:getClickHandler(clickedElement.name)
    if clickHandler then clickHandler(clickedElement, playerIndex) end
  end
end



-- Called after a player leaves the game.
function Help.Gui:onPlayerLeftGame(playerIndex)
  if self:hasOpenedGui(playerIndex) then
    self:onCloseEntity(game.players[playerIndex].opened, playerIndex)
  end
end
