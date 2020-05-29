require 'util'
require("__LSlib__/LSlib")

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
    ["version"      ] = 3, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes
    ["openedEntity" ] = {} -- opened entity for each player
  }

  return util.table.deepcopy(gui)
end



local trainDepotGui = require "prototypes.gui.layout.traindepot"
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
    "selected-depot-name", -- current/new depot name
    "selected-depot-list", -- list of all depot names
  } do
    updateElementPath[selectionTabElementName] = LSlib.gui.layout.getElementPath(trainDepotGui, selectionTabElementName)
  end
  for _,statisticsTabElementName in pairs{
    "statistics-station-id-value"            , -- station name
    "statistics-station-amount-value"        , -- number of depots
    "statistics-builder-amount-value"        , -- number of trains to be available at the depot
    "statistics-builder-working-amount-value", -- number of trainbuilders that are connected to this builder
    "statistics-builder-list"                , -- list of all trainbuilders connected to this depot
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



function Traindepot.Gui:initClickHandlers()
  local clickHandlers = {}

  ------------------------------------------------------------------------------
  -- help button handler
  ------------------------------------------------------------------------------
  clickHandlers["traindepot-help"] = function(clickedElement, playerIndex)
    -- close this UI
    Traindepot.Gui:setOpenedEntity(playerIndex, nil)
    game.players[playerIndex].opened = Traindepot.Gui:destroyGui(playerIndex)

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
      "traindepot-tab-selection" ,
      "traindepot-tab-statistics",
    } do
      tabButtonFlow[tabButtonName].style = (tabButtonName == clickedTabButtonName and "LSlib_default_tab_button_selected" or "LSlib_default_tab_button")
      tabContentFlow[tabButtonName].visible = (tabButtonName == clickedTabButtonName)
    end
  end

  for _,tabButtonName in pairs{
    "traindepot-tab-selection" ,
    "traindepot-tab-statistics",
  } do
    clickHandlers[tabButtonName] = tabButtonHandler
  end



  ------------------------------------------------------------------------------
  -- statistics
  ------------------------------------------------------------------------------
  clickHandlers["statistics-station-id-edit"] = function(clickedElement, playerIndex)
    local tabToOpen = "traindepot-tab-selection"
    Traindepot.Gui:getClickHandler(tabToOpen)(LSlib.gui.getElement(playerIndex, Traindepot.Gui:getTabElementPath(tabToOpen)), playerIndex) -- mimic tab pressed
  end

  clickHandlers["statistics-builder-amount-value-"] = function(clickedElement, playerIndex)
    local depotEntity       = Traindepot.Gui:getOpenedEntity(playerIndex)
    local depotForceName    = depotEntity.force.name
    local depotSurfaceIndex = depotEntity.surface.index
    local depotName         = depotEntity.backer_name

    -- update the data
    Traindepot:setDepotRequestCount(depotForceName, depotSurfaceIndex, depotName,
      Traindepot:getDepotRequestCount(depotForceName, depotSurfaceIndex, depotName) - 1)

    -- update the gui element
    LSlib.gui.getElement(playerIndex, Traindepot.Gui:getUpdateElementPath("statistics-builder-amount-value")).caption = string.format("%i/%i",
      Traindepot:getDepotRequestCount(depotForceName, depotSurfaceIndex, depotName),
      Traindepot:getDepotStationCount(depotForceName, depotSurfaceIndex, depotName))
  end

  clickHandlers["statistics-builder-amount-value+"] = function(clickedElement, playerIndex)
    local depotEntity       = Traindepot.Gui:getOpenedEntity(playerIndex)
    local depotForceName    = depotEntity.force.name
    local depotSurfaceIndex = depotEntity.surface.index
    local depotName         = depotEntity.backer_name

    -- update the data
    Traindepot:setDepotRequestCount(depotForceName, depotSurfaceIndex, depotName,
      Traindepot:getDepotRequestCount(depotForceName, depotSurfaceIndex, depotName) + 1)

    -- update the gui element
    LSlib.gui.getElement(playerIndex, Traindepot.Gui:getUpdateElementPath("statistics-builder-amount-value")).caption = string.format("%i/%i",
      Traindepot:getDepotRequestCount(depotForceName, depotSurfaceIndex, depotName),
      Traindepot:getDepotStationCount(depotForceName, depotSurfaceIndex, depotName))
  end

  clickHandlers["statistics-builder-list-button"] = function(clickedElement, playerIndex)
    local minimapElement   = clickedElement["statistics-builder-list-minimap"]
    local controllerEntity = game.surfaces[minimapElement.surface_index].find_entities_filtered{
      name     = Traincontroller:getControllerEntityName(),
      position = minimapElement.position,
      limit    = 1,
    }[1]
    if controllerEntity then
      -- destroy this depot UI
      Traindepot.Gui:onCloseEntity(game.players[playerIndex].opened, playerIndex)

      -- open the controller UI
      Traincontroller.Gui:onOpenEntity(controllerEntity, playerIndex)
    end
  end



  ------------------------------------------------------------------------------
  -- select train depot name
  ------------------------------------------------------------------------------
  clickHandlers["selected-depot-list"] = function(clickedElement, playerIndex)
    local listboxElement = LSlib.gui.getElement(playerIndex, Traindepot.Gui:getUpdateElementPath("selected-depot-list"))

    LSlib.gui.getElement(playerIndex, Traindepot.Gui:getUpdateElementPath("selected-depot-name")).text = listboxElement.get_item(listboxElement.selected_index)
  end

  clickHandlers["selected-depot-enter"] = function(clickedElement, playerIndex)
    local depotEntity  = Traindepot.Gui:getOpenedEntity(playerIndex)
    local oldDepotName = depotEntity.backer_name
    local newDepotName = LSlib.gui.getElement(playerIndex, Traindepot.Gui:getUpdateElementPath("selected-depot-name")).text

    if newDepotName ~= oldDepotName then
      depotEntity.backer_name = newDepotName -- invokes the rename event which will update UI's
      --Traindepot.Gui:updateGuiInfo(playerIndex)
    end

    -- mimic tab pressed to go back to statistics tab
    local tabToOpen = "traindepot-tab-statistics"
    Traindepot.Gui:getClickHandler(tabToOpen)(LSlib.gui.getElement(playerIndex, Traindepot.Gui:getTabElementPath(tabToOpen)), playerIndex)
  end



  ------------------------------------------------------------------------------
  return clickHandlers
end
Traindepot.Gui.clickHandlers = Traindepot.Gui:initClickHandlers()



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
  return Traindepot.Gui.clickHandlers[guiElementName]
end



function Traindepot.Gui:getGuiName()
  return LSlib.gui.getRootElementName(self:getDepotGuiLayout())
end



function Traindepot.Gui:getOpenedEntity(playerIndex)
  return global.TD_data.Gui["openedEntity"][playerIndex]
end



function Traindepot.Gui:hasOpenedGui(playerIndex)
  return self:getOpenedEntity(playerIndex) and true or false
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

  -- selection tab -------------------------------------------------------------
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("selected-depot-name")).text = depotName

  -- name selection list
  local depotEntriesList = LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("selected-depot-list"))
  depotEntriesList.clear_items()
  local itemIndex = 1
  local orderedPairs = LSlib.utils.table.orderedPairs
  for trainDepotName,_ in orderedPairs(Traindepot:getDepotData(depotForceName, depotSurfaceIndex)) do
    -- https://lua-api.factorio.com/latest/LuaGuiElement.html#LuaGuiElement.add_item
    depotEntriesList.add_item(trainDepotName)
    if trainDepotName == depotName then
      depotEntriesList.selected_index = itemIndex
    end
    itemIndex = itemIndex + 1
  end

  -- statistics ----------------------------------------------------------------
  local depotStationCount  = Traindepot:getDepotStationCount(depotForceName, depotSurfaceIndex, depotName)

  -- station name
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-station-id-value")).caption = depotName

  -- number of depots available
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-station-amount-value")).caption = string.format(
    "%i/%i", depotStationCount - Traindepot:getNumberOfTrainsStoppedInDepot(depotSurfaceIndex, depotName), depotStationCount)

  -- number of trains to be available at the depot
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-builder-amount-value")).caption = string.format(
    "%i/%i", Traindepot:getDepotRequestCount(depotForceName, depotSurfaceIndex, depotName), depotStationCount)

  -- number of trainbuilders that are connected to this builder
  LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-builder-working-amount-value")).caption =
    Traindepot:getTrainBuilderCount(depotForceName, depotSurfaceIndex, depotName)

  -- list of all trainbuilders connected to this depot
  local controllerList = LSlib.gui.getElement(playerIndex, self:getUpdateElementPath("statistics-builder-list"))
  controllerList.clear()
  local controllers = Traincontroller:getAllTrainControllers(depotSurfaceIndex, depotName)
  for controllerIndex,controller in pairs(controllers) do
    controllerList.add{
      -- flow is required so all the buttons have the same name
      type      = "flow"                                          ,
      name      = "statistics-builder-list-flow-"..controllerIndex,
      direction = "vertical"                                      ,
      style     = "traindepot_controller_minimap_flow"            ,
    }.add{
      type    = "button"                                                ,
      name    = "statistics-builder-list-button"                        ,
      tooltip = {"gui-traindepot.depot-builder-open-controller-tooltip"},
      style   = "traindepot_controller_minimap_button"                  ,
    }.add{
      type                   = "minimap"                        ,
      name                   = "statistics-builder-list-minimap",
      position               = controller.position              ,
      surface_index          = depotSurfaceIndex                ,
      force                  = depotForceName                   ,
      style                  = "traindepot_controller_minimap"  ,
      zoom                   = 2                                ,
      ignored_by_interaction = true --[[for button behaviour]]  ,
    }
  end
end



function Traindepot.Gui:updateOpenedGuis(depotName)
  for _,player in pairs(game.connected_players) do -- no need to check all players
    local openedEntity = self:getOpenedEntity(player.index)
    if openedEntity then
      if openedEntity.valid and openedEntity.health > 0 then
        if openedEntity.backer_name == depotName then
          self:updateGuiInfo(player.index)
        end
      else -- not valid/killed
        self:onCloseEntity(player.opened, player.index)
      end
    end
  end
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
function Traindepot.Gui:onClickElement(clickedElement, playerIndex)
  if self:hasOpenedGui(playerIndex) then
    if not clickedElement.valid then return end
    local clickHandler = self:getClickHandler(clickedElement.name)
    if clickHandler then clickHandler(clickedElement, playerIndex) end
  end
end



-- Called after a player leaves the game.
function Traindepot.Gui:onPlayerLeftGame(playerIndex)
  if self:hasOpenedGui(playerIndex) then
    self:onCloseEntity(game.players[playerIndex].opened, playerIndex)
  end
end
