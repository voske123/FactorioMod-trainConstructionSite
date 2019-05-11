require "LSlib.lib"

local guiLayout = LSlib.gui.layout.create("center")

local guiFrame = LSlib.gui.layout.addFrame(guiLayout, "root", "traindepo", "horizontal", {
  caption = {"item-name.traindepo"},
  style   = "frame_without_footer",
})

local guiTabContent = LSlib.gui.layout.addTabs(guiLayout, guiFrame, "traindepo-tab", {
  { -- first tab
    name    = "traindepo-selection"              ,
    caption = "select depoT"                     ,
    style   = "LSlib_default_tab_button_selected",
  },
  { -- second tab
    name    = "traindepo-statistics"    ,
    caption = "depo statistics"         ,
    style   = "LSlib_default_tab_button",
  },
}, {
  buttonFlowStyle      = "LSlib_default_tab_buttonFlow"     ,
  tabInsideFrameStyle  = "LSlib_default_tab_insideDeepFrame",
  tabContentFrameStyle = "LSlib_default_tab_contentFrame"   ,
})

--------------------------------------------------------------------------------
-- Name selection tab                                                         --
--------------------------------------------------------------------------------
local guiTabContent1 = LSlib.gui.layout.getTabContentFrameFlow(guiLayout, guiTabContent, 1)

-- new entry
local guiNewEntryFlow = LSlib.gui.layout.addFlow(guiLayout, guiTabContent1, "new-entry", "horizontal", {
  style = "centering_horizontal_flow",
})

LSlib.gui.layout.addTextfield(guiLayout, guiNewEntryFlow, "new-depo-name", {
  text    = "Enter depot name",
  tooltip = "Enter new depot name or select existing one below.",
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiNewEntryFlow, "enter-new-entry", {
  sprite = "utility/enter",
  style = "slot_button"   ,
})

LSlib.gui.layout.addListbox(guiLayout, guiTabContent1, "old-entries")

return guiLayout
