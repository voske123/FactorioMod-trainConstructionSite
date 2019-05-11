require "LSlib.lib"

local guiLayout = LSlib.gui.layout.create("center")

local guiFrame = LSlib.gui.layout.addFrame(guiLayout, "root", "traincontroller", "horizontal", {
  caption = {"item-name.traincontroller", {[1] = "item-name.trainassembly"}},
  style   = "frame_without_footer",
})

local guiTabContent = LSlib.gui.layout.addTabs(guiLayout, guiFrame, "traincontroller-tab", {
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

local guiTabContent1 = LSlib.gui.layout.getTabContentFrameFlow(guiLayout, guiTabContent, 1)
LSlib.gui.layout.addTextfield(guiLayout, guiTabContent1, "new-depo-name")

return guiLayout
