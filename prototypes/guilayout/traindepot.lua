require "LSlib.lib"

local guiLayout = LSlib.gui.layout.create("center")

local guiFrame = LSlib.gui.layout.addFrame(guiLayout, "root", "traindepot", "horizontal", {
  caption = {"item-name.traindepot"},
  style   = "frame_without_footer",
})

local guiTabContent = LSlib.gui.layout.addTabs(guiLayout, guiFrame, "traindepot-tab", {
  { -- first tab
    name     = "-statistics"     ,
    caption  = "depot statistics",
    selected = true              ,
  },
  { -- second tab
    name     = "-selection"  ,
    caption  = "select depot",
  },
}, {
  buttonFlowStyle      = "LSlib_default_tab_buttonFlow"     ,
  buttonStyle          = "LSlib_default_tab_button"         ,
  buttonSelectedStyle  = "LSlib_default_tab_button_selected",
  tabInsideFrameStyle  = "LSlib_default_tab_insideDeepFrame",
  tabContentFrameStyle = "LSlib_default_tab_contentFrame"   ,
})

--------------------------------------------------------------------------------
-- Name selection tab                                                         --
--------------------------------------------------------------------------------
local guiTabContent1 = LSlib.gui.layout.getTabContentFrameFlow(guiLayout, guiTabContent, 2)

local guiNewEntryFlow = LSlib.gui.layout.addFlow(guiLayout, guiTabContent1, "new-entry", "horizontal", {
  style = "traindepot_new_entry_flow_style", --"centering_horizontal_flow",
})

LSlib.gui.layout.addTextfield(guiLayout, guiNewEntryFlow, "new-depot-name", {
  text    = "Enter depot name",
  tooltip = "Enter new depot name or select existing one below.",
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiNewEntryFlow, "enter-new-entry", {
  sprite = "utility/enter",
  style = "slot_button"   ,
})

LSlib.gui.layout.addListbox(guiLayout, guiTabContent1, "old-entries", {
  items = {"test1", "test2", "test3"}
})



--------------------------------------------------------------------------------
-- statistics tab                                                         --
--------------------------------------------------------------------------------
local guiTabContent2 = LSlib.gui.layout.getTabContentFrameFlow(guiLayout, guiTabContent, 1)

----------------
return guiLayout
