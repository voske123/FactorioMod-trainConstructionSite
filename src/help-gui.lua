require 'util'
require("__LSlib__/LSlib")

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
  -- tabElementPath
  local tabElementPath = {}
  for _,tabName in pairs{
    "introduction"
  } do
    for _,tabElementName in pairs{
      string.format("trainConstructionSite-help-toc-%s"    , tabName),
      string.format("trainConstructionSite-help-content-%s", tabName),
    } do
      tabElementPath[tabElementName] = LSlib.gui.layout.getElementPath(helpGui, tabElementName)
    end
  end
  for _, elementName in pairs{
    "trainConstructionSite-help-toc"    ,
    "trainConstructionSite-help-content",
  } do
    tabElementPath[elementName] = LSlib.gui.layout.getElementPath(helpGui, elementName)
  end

  return {
    -- gui layout
    ["helpGui"            ] = helpGui                             ,
    ["helpGui-ToCName"    ] = "trainConstructionSite-help-toc"    ,
    ["helpGui-ContentName"] = "trainConstructionSite-help-content",

    -- gui element paths (derived from layout)
    ["tabElementPath"     ] = tabElementPath                      ,
  }
end



function Help.Gui:initClickHandlerData()
  local clickHandlers = {}

  ------------------------------------------------------------------------------
  -- close button handler
  ------------------------------------------------------------------------------
  clickHandlers["trainConstructionSite-help-gui-quit"] = function(clickedElement, playerIndex)
    Help.Gui:setOpenedGui(playerIndex, nil)
    game.players[playerIndex].opened = Help.Gui:destroyGui(playerIndex)
  end



  ------------------------------------------------------------------------------
  -- tab button handler
  ------------------------------------------------------------------------------
  local tabButtonHandler = function(clickedTabButton, playerIndex)
    local tocElement = clickedTabButton.parent

    -- set the style of the clicked buttons in ToC
    local clickedElementName = clickedTabButton.name
    for _,childName in pairs(tocElement.children_names) do
      tocElement[childName].style = childName == clickedElementName and "trainConstructionSite_help_tocButton_pressed" or "trainConstructionSite_help_tocButton"
    end

    -- extract the contentFrameName
    local clickedElementNameSeperated = LSlib.utils.string.split(clickedElementName, "-")
    clickedElementName = ""
    for namePartIndex, namePart in pairs(clickedElementNameSeperated) do
      if namePartIndex > 3 then
        clickedElementName = string.format("%s-%s", clickedElementName, namePart)
      end
    end
    clickedElementName = Help.Gui:getContentName(string.sub(clickedElementName, 2))

    -- set the correct frame
    local helpGuiMain = tocElement.parent.parent
    for _,childName in pairs(helpGuiMain.children_names) do
      if childName ~= "trainConstructionSite-help-toc-frame" then
        helpGuiMain[childName].visible = childName == clickedElementName
      end
    end
  end

  local tabButton = "trainConstructionSite-help-toc-%s"
  for _,tabButtonName in pairs{
    "introduction"   ,
    "traindepot"     ,
    "trainbuilder"   ,
    "traincontroller",
  } do
    clickHandlers[string.format(tabButton, tabButtonName)] = tabButtonHandler
  end



  ------------------------------------------------------------------------------
  -- previous/next buttons
  ------------------------------------------------------------------------------
  clickHandlers["trainConstructionSite-help-content-previous"] = function(clickedElementName, playerIndex)
    local tocElement = LSlib.gui.getElement(playerIndex, Help.Gui:getTabElementPath(string.sub(Help.Gui:getToCName(""), 1, -2)))

    -- find the selected index
    local previousTabName = nil
    local foundPrevious = false
    for tabIndex, tabElementName in pairs(tocElement.children_names) do
      if string.sub(tocElement[tabElementName].style.name,-8) == "_pressed" then
        foundPrevious = true
        break
      end
      previousTabName = tabElementName
    end

    -- switch tab by simulating pressing previous tab button in ToC
    if foundPrevious then
      Help.Gui:getClickHandler(previousTabName)(tocElement[previousTabName], playerIndex)
    end
  end



  clickHandlers["trainConstructionSite-help-content-next"] = function(clickedElementName, playerIndex)
    local tocElement = LSlib.gui.getElement(playerIndex, Help.Gui:getTabElementPath(string.sub(Help.Gui:getToCName(""), 1, -2)))

    -- find the selected index
    local nextTabName = nil
    local foundCurrent = false
    for tabIndex, tabElementName in pairs(tocElement.children_names) do
      if string.sub(tocElement[tabElementName].style.name,-8) == "_pressed" then
        foundCurrent = true

      elseif foundCurrent then
        nextTabName = tabElementName
        break
      end
    end

    -- switch tab by simulating pressing next tab button in ToC
    if nextTabName then
      Help.Gui:getClickHandler(nextTabName)(tocElement[nextTabName], playerIndex)
    end
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



function Help.Gui:getToCName(pageName)
  return string.format("%s-%s", global.H_data.Gui["prototypeData"]["helpGui-ToCName"], pageName)
end



function Help.Gui:getContentName(pageName)
  return string.format("%s-%s", global.H_data.Gui["prototypeData"]["helpGui-ContentName"], pageName)
end



function Help.Gui:getTabElementPath(guiElementName)
  return global.H_data.Gui["prototypeData"]["tabElementPath"][guiElementName]
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
  local openGui = self:createGui(playerIndex)
  local introductionTabName = self:getToCName("introduction")
  self:getClickHandler(introductionTabName)(LSlib.gui.getElement(playerIndex, self:getTabElementPath(introductionTabName)))

  self:setOpenedGui(playerIndex, openGui)
  game.players[playerIndex].opened = openGui
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
