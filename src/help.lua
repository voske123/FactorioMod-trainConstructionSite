require 'util'
require("__LSlib__/LSlib")

-- Create class
Help = {}
require 'src.help-gui'

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Help:onInit()
  -- Init global data; data stored through the whole map
  if not global.H_data then
    global.H_data = self:initGlobalData()
  end
  self.Gui:onInit()
end



-- Initiation of the global data
function Help:initGlobalData()
  local H_data = {
    ["version"      ]       = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes
  }

  return util.table.deepcopy(H_data)
end



-- Initialisation of the prototye data inside the global data
function Help:initPrototypeData()
  return
  {
    ["helpManualName"] = "trainbuilder-manual", -- item
  }
end



--------------------------------------------------------------------------------
-- Setter functions to alter data into the data structure
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Help:getManualItemName()
  return global.H_data.prototypeData.helpManualName
end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When the player uses the 'Open item GUI' control on an item defined with 'can_be_mod_opened' as true
function Help:onOpenItem(clickedItem, playerIndex)
  if clickedItem.name == "trainbuilder-manual" then
    Help.Gui:openGui(playerIndex)
  end
end
