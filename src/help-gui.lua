require 'util'
require "LSlib/lib"

-- Create class
HelpGui = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function HelpGui:onInit()
  if not global.HG_data then
    global.HG_data = self:initGlobalData()
  end
end



-- Initiation of the global data
function HelpGui:initGlobalData()
  local gui = {
    ["version"      ] = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes
    ["clickHandler" ] = self:initClickHandlerData(),
    ["openedGui"    ] = {} -- opened entity for each player
  }

  return util.table.deepcopy(gui)
end



local helpGui = require "prototypes.gui.layout.help-gui"
function HelpGui:initPrototypeData()
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



function HelpGui:initClickHandlerData()
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
function HelpGui:setOpenedGui(playerIndex, openedHelpGui)
  global.HG_data["openedGui"][playerIndex] = openedHelpGui
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function HelpGui:getHelpGuiLayout()
  return global.HG_data["prototypeData"]["helpGui"]
end



function HelpGui:getTabElementPath(guiElementName)
  return global.HG_data["prototypeData"]["tabButtonPath"][guiElementName]
end



function HelpGui:getClickHandler(guiElementName)
  return global.HG_data["clickHandler"][guiElementName]
end



function HelpGui:getGuiName()
  return LSlib.gui.getRootElementName(self:getHelpGuiLayout())
end



function HelpGui:hasOpenedGui(playerIndex)
  return global.HG_data["openedGui"][playerIndex] and true or false
end



--------------------------------------------------------------------------------
-- Gui functions
--------------------------------------------------------------------------------
function HelpGui:createGui(playerIndex)
  return LSlib.gui.create(playerIndex, self:getHelpGuiLayout())
end



function HelpGui:destroyGui(playerIndex)
  return LSlib.gui.destroy(playerIndex, self:getHelpGuiLayout())
end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player opens/closes a gui
function HelpGui:onCloseEntity(openedGui, playerIndex)
  if openedGui and openedGui.valid and openedGui.name == self:getGuiName() then
    self:setOpenedGui(playerIndex, nil)
    game.players[playerIndex].opened = self:destroyGui(playerIndex)
  end
end



-- When a player clicks on the gui
function HelpGui:onClickElement(clickedElement, playerIndex)
  if self:hasOpenedGui(playerIndex) then
    if not clickedElement.valid then return end
    local clickHandler = self:getClickHandler(clickedElement.name)
    if clickHandler then clickHandler(clickedElement, playerIndex) end
  end
end



-- Called after a player leaves the game.
function HelpGui:onPlayerLeftGame(playerIndex)
  if self:hasOpenedGui(playerIndex) then
    self:onCloseEntity(game.players[playerIndex].opened, playerIndex)
  end
end
