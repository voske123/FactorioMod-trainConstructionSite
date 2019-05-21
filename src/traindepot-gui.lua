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
    ["version"      ] = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes
    ["clickHandler" ] = self:initClickHandlerData(),
    ["openedEntity" ] = {} -- opened entity for each player
  }

  return util.table.deepcopy(gui)
end



local trainDepotGui = require("prototypes.guilayout.traindepot")
function Traindepot.Gui:initPrototypeData()
  -- tabButtonPath
  local tabButtonPath = {}
  for _,tabButtonName in pairs{
    "traindepot-tab-selection" ,
    "traindepot-tab-statistics",
  } do
    tabButtonPath[tabButtonName] = LSlib.gui.layout.getElementPath(trainDepotGui, tabButtonName)
  end

  -- updateElementPath
  local updateElementPath = {}
  for _,selectionTabElementName in pairs{
    "new-depot-entry", -- current/new depot name
    "old-depot-entry", -- list of all depot names
  } do
    updateElementPath[selectionTabElementName] = LSlib.gui.layout.getElementPath(trainDepotGui, selectionTabElementName)
  end
  for _,statisticsTabElementName in pairs{
    "statistics-station-id-value"            , -- station name
    "statistics-station-amount-value"        , -- number of depots
    "statistics-builder-amount-value"        , -- number of trains to be available at the depot
    "statistics-builder-working-amount-value", -- number of trainbuilders that are connected to this builder
  } do
    updateElementPath[statisticsTabElementName] = LSlib.gui.layout.getElementPath(trainDepotGui, statisticsTabElementName)
  end

  return {
    -- gui layout
    ["trainDepotGui"    ] = trainDepotGui    ,

    -- gui element paths (derived from layout)
    ["tabButtonPath"    ] = tabButtonPath    ,
    ["updateElementPath"] = updateElementPath,
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

  ------------------------------------------------------------------------------
  -- statistics
  ------------------------------------------------------------------------------
  clickHandlers["statistics-station-id-edit"] = function(clickedTabButtonName, playerIndex)
    local tabToOpen = "traindepot-tab-selection"
    clickHandlers[tabToOpen](tabToOpen, playerIndex) -- mimic tab pressed
  end

  ------------------------------------------------------------------------------
  -- select train depot name
  ------------------------------------------------------------------------------
  -- TODO

  ------------------------------------------------------------------------------
  return clickHandlers
end



--------------------------------------------------------------------------------
-- Setter functions to alter data into the data structure
--------------------------------------------------------------------------------
function Traindepot.Gui:setOpenedEntity(playerIndex, openedEntity)
  global.TD_data.Gui["openedEntity"][playerIndex] = openedEntity
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Traindepot.Gui:getDepotGuiLayout()
  return global.TD_data.Gui["prototypeData"]["trainDepotGui"]
end



function Traindepot.Gui:getTabElementPath(guiElementName)
  return global.TD_data.Gui["prototypeData"]["tabButtonPath"][guiElementName]
end



function Traindepot.Gui:getUpdateElementPath(guiElementName)
  return global.TD_data.Gui["prototypeData"]["updateElementPath"][guiElementName]
end



function Traindepot.Gui:getClickHandler(guiElementName)
  return global.TD_data.Gui["clickHandler"][guiElementName]
end



function Traindepot.Gui:getGuiName()
  return LSlib.gui.getRootElementName(self:getDepotGuiLayout())
end



function Traindepot.Gui:getOpenedEntity(playerIndex)
  return global.TD_data.Gui["openedEntity"][playerIndex]
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
  -- We expect the gui to be created already
  local trainDepotGui = LSlib.gui.getElement(playerIndex, LSlib.gui.layout.getElementPath(self:getDepotGuiLayout(), self:getGuiName()))
  if not trainDepotGui then return end -- gui was not created, nothing to update

  -- data from the traindepo we require to update
  local player = game.players[playerIndex]

  local openedEntity      = self:getOpenedEntity(playerIndex)
  local depotName         = openedEntity and openedEntity.valid and openedEntity.backer_name or ""
  local depotForceName    = openedEntity and openedEntity.valid and openedEntity.force.name or ""
  local depotSurfaceIndex = openedEntity and openedEntity.valid and openedEntity.surface.index or player.surface.index or 1

  local depotStationCounts = Traindepot:getDepotNames(depotForceName, depotSurfaceIndex) or {}
  local depotStationCount  = depotStationCounts[depotName] or 0

  -- selection tab -------------------------------------------------------------
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("new-depot-entry")).text = depotName

  -- name selection list
  local depotEntriesList = LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("old-depot-entry"))
  for trainDepotName,trainDepotCount in pairs(depotStationCounts) do
    -- https://lua-api.factorio.com/latest/LuaGuiElement.html#LuaGuiElement.add_item
    depotEntriesList.add_item(trainDepotName)
  end

  -- statistics ----------------------------------------------------------------
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-station-id-value")).caption = depotName
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-station-amount-value")).caption = string.format(
    "%i/%i", depotStationCount - Traindepot:getNumberOfTrainsStoppedInDepot(depotSurfaceIndex, depotName), depotStationCount)
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-builder-amount-value")).caption = string.format(
    "%i/%i", -999, depotStationCount)
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-builder-working-amount-value")).caption =
    Traindepot:getTrainBuilderCount(depotForceName, depotSurfaceIndex, depotName)

end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player opens a gui
function Traindepot.Gui:onOpenEntity(openedEntity, playerIndex)
  if openedEntity and openedEntity.name == Traindepot:getDepotEntityName() then
    self:setOpenedEntity(playerIndex, openedEntity)
    game.players[playerIndex].opened = self:createGui(playerIndex)
  end
end



-- When a player opens/closes a gui
function Traindepot.Gui:onCloseEntity(openedGui, playerIndex)
  if openedGui and openedGui.valid and openedGui.name == self:getGuiName() then
    self:setOpenedEntity(playerIndex, nil)
    game.players[playerIndex].opened = self:destroyGui(playerIndex)
  end
end



-- When a player clicks on the gui
function Traindepot.Gui:onClickElement(clickedElementName, playerIndex)
  --game.players[playerIndex].print(clickedElementName)
  local clickHandler = self:getClickHandler(clickedElementName)
  if clickHandler then clickHandler(clickedElementName, playerIndex) end
end
