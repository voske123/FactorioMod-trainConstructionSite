require "LSlib.lib"

local guiLayout = LSlib.gui.layout.create("center")

local guiFrame = LSlib.gui.layout.addFrame(guiLayout, "root", "traindepot", "horizontal", {
  caption = {"item-name.traindepot"},
  style   = "frame_without_footer"  ,
})

local guiTabContent = LSlib.gui.layout.addTabs(guiLayout, guiFrame, "traindepot-tab", {
  { -- first tab
    name     = "-statistics"                    ,
    caption  = {"gui-traindepot.tab-statistics"},
    selected = true                             ,
  },
  { -- second tab
    name     = "-selection"                         ,
    caption  = {"gui-traindepot.tab-name-selection"},
  },
}, {
  buttonFlowStyle      = "LSlib_default_tab_buttonFlow"     ,
  buttonStyle          = "LSlib_default_tab_button"         ,
  buttonSelectedStyle  = "LSlib_default_tab_button_selected",
  tabInsideFrameStyle  = "LSlib_default_tab_insideDeepFrame",
  --tabContentFrameStyle = "LSlib_default_tab_contentFrame"   ,
  tabContentFrameStyle = "traindepot_contentFrame"          ,
})



--------------------------------------------------------------------------------
-- Name selection tab                                                         --
--------------------------------------------------------------------------------
local guiTabContent2 = LSlib.gui.layout.getTabContentFrameFlow(guiLayout, guiTabContent, 2)

local guiNewEntryFlow = LSlib.gui.layout.addFlow(guiLayout, guiTabContent2, "new-entry", "horizontal", {
  style = "traindepot_new_entry_flow",
})

LSlib.gui.layout.addLabel(guiLayout, guiNewEntryFlow, "selected-depot-label", {
  caption = {"", {"gui-traindepot.new-name-field"}, " [img=info]"},
  tooltip = {"gui-traindepot.new-name-field-tooltip"},
})
LSlib.gui.layout.addTextfield(guiLayout, guiNewEntryFlow, "selected-depot-name", {
  text    = "Enter depot name",
  tooltip = {"gui-traindepot.new-name-field-tooltip"},
  style = "traindepot_new_entry_textfield",
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiNewEntryFlow, "selected-depot-enter", {
  sprite = "utility/enter",
  style = "slot_button"   ,
})

LSlib.gui.layout.addListbox(guiLayout, guiTabContent2, "selected-depot-list", {
  items = {"test1", "test2", "test3"},
  style = "traindepot_select_name_list_box",
})



--------------------------------------------------------------------------------
-- statistics tab                                                         --
--------------------------------------------------------------------------------
local guiTabContent1 = LSlib.gui.layout.getTabContentFrameFlow(guiLayout, guiTabContent, 1)

local statistics = LSlib.gui.layout.addTable(guiLayout, guiTabContent1, "statistics", 2, {
  style = "traindepot_statistics_table",
})

-- name
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-station-id", {
  caption = {"gui-traindepot.depot-name"},
})
local stationIDflow = LSlib.gui.layout.addFlow(guiLayout, statistics, "statistics-station-id-flow", "horizontal", {
  style = "centering_horizontal_flow",
})
LSlib.gui.layout.addSpriteButton(guiLayout, stationIDflow, "statistics-station-id-edit", {
  sprite = "utility/rename_icon_small",
  style = "mini_button"               ,
})
LSlib.gui.layout.addLabel(guiLayout, stationIDflow, "statistics-station-id-value", {
  caption = {"gui-traindepot.unused-depot-name"},
})

-- amount
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-station-amount", {
  caption = {"gui-traindepot.depot-availability"},
})
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-station-amount-value", {
  caption = "-999/999",
})

-- traindepos
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-builderproduct-amount", {
  caption = {"", {"gui-traindepot.depot-auto-request"}, " [img=info]"},
  tooltip = {"gui-traindepot.depot-auto-request-tooltip"},
})
local builderproductFlow = LSlib.gui.layout.addFlow(guiLayout, statistics, "statistics-builderproduct-amount-flow", "horizontal", {
  style = "centering_horizontal_flow",
})
LSlib.gui.layout.addSpriteButton(guiLayout, builderproductFlow, "statistics-builder-amount-value-", {
  sprite = "utility/editor_speed_down",
  style = "mini_button"               ,
})
LSlib.gui.layout.addLabel(guiLayout, builderproductFlow, "statistics-builder-amount-value", {
  caption = "-999/999",
})
LSlib.gui.layout.addSpriteButton(guiLayout, builderproductFlow, "statistics-builder-amount-value+", {
  sprite = "utility/editor_speed_up",
  style = "mini_button"             ,
})

-- trainbuilders
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-builders-working-amount", {
  caption = {"", {"gui-traindepot.depot-builder-utilisation"}, " [img=info]"},
  tooltip = {"gui-traindepot.depot-builder-utilisation-tooltip"}
})
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-builder-working-amount-value", {
  caption = "-999",
})
local controllerList = LSlib.gui.layout.addScrollPane(guiLayout, guiTabContent1, "statistics-builder-list-flow", {
  horizontal_scroll_policy = "never"                                   ,
  vertical_scroll_policy   = "always"                                  ,
  style                    = "traindepot_controller_minimap_scrollpane",
})
controllerList = LSlib.gui.layout.addTable(guiLayout, controllerList, "statistics-builder-list", 2, {
  style = "traindepot_controller_minimap_table",
})

----------------
return guiLayout
