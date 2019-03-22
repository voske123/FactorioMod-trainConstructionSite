require "LSlib.lib"

local guiLayout = LSlib.gui.layout.create("center")

local guiFrame = LSlib.gui.layout.addFrame(guiLayout, "root", "traincontroller", "horizontal", {
  caption = {"item-name.traincontroller", {[1] = "item-name.trainassembly"}},
  style   = "frame_without_footer",
})

local guiTabs = LSlib.gui.layout.addTabs(guiLayout, guiFrame, "traincontroller-tab", {
  {
    name    = "depoSelection"                    ,
    caption = "select depoT"                     ,
    style   = "LSlib_default_tab_button_selected",
  },
  {
    name    = "configuration"           ,
    caption = "train configuration"     ,
    style   = "LSlib_default_tab_button",
  },
}, {
  buttonFlowStyle      = "LSlib_default_tab_buttonFlow",
  tabInsideFrameStyle  = "LSlib_default_tab_insideDeepFrame",
  tabContentFrameStyle = "LSlib_default_tab_contentFrame",
})

--[[
local tabFrame = LSlib.gui.layout.addFrame(guiLayout, guiFrame, "tabFrame", "vertical", {
  style = "inside_deep_frame_for_tabs"
})

-- buttons
local tabButtonFlow = LSlib.gui.layout.addFlow(guiLayout, tabFrame, "tabFlow", "horizontal")
LSlib.gui.layout.addButton(guiLayout, tabButtonFlow, "button1")
LSlib.gui.layout.addButton(guiLayout, tabButtonFlow, "button2")

-- content
tabFrame = LSlib.gui.layout.addFrame(guiLayout, tabFrame, "tabFrame", "vertical")
]]

return guiLayout
