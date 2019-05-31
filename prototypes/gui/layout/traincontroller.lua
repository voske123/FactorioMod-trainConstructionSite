require "LSlib.lib"

local guiLayout = LSlib.gui.layout.create("center")

local guiFlow = LSlib.gui.layout.addFlow(guiLayout, "root", "traincontroller-gui", "horizontal", {
  style = "traincontroller_contentFlow", -- no padding
})

local guiFrame = LSlib.gui.layout.addFrame(guiLayout, guiFlow, "traincontroller-mainframe", "vertical", {
  --caption = {"item-name.traincontroller", {[1] = "item-name.trainassembly"}},
  style   = "frame_without_footer"       ,
})

local guiFrameHeaderFlow = LSlib.gui.layout.addFlow(guiLayout, guiFrame, "traincontroller-mainframe-gui-header", "horizontal", {
  style = "LSlib_default_header",
})

LSlib.gui.layout.addLabel(guiLayout, guiFrameHeaderFlow, "traincontroller-mainframe-gui-header-title", {
  caption = {"item-name.traincontroller", {[1] = "item-name.trainassembly"}},
  style   = "LSlib_default_frame_title",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addFrame(guiLayout, guiFrameHeaderFlow, "traincontroller-mainframe-gui-header-filler", "vertical", {
  style = "LSlib_default_header_filler",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFrameHeaderFlow, "traincontroller-help", {
  sprite = "utility/questionmark"      ,
  style = "LSlib_default_header_button",
})

local guiTabContent = LSlib.gui.layout.addTabs(guiLayout, guiFrame, "traincontroller-tab", {
  { -- first tab
    name     = "-statistics"     ,
    caption  = {"gui-traincontroller.tab-statistics"},
    selected = true              ,
  },
  { -- second tab
    name     = "-selection"                              ,
    caption  = {"gui-traincontroller.tab-name-selection"},
  },
}, {
  buttonFlowStyle      = "LSlib_default_tab_buttonFlow"     ,
  buttonStyle          = "LSlib_default_tab_button"         ,
  buttonSelectedStyle  = "LSlib_default_tab_button_selected",
  tabInsideFrameStyle  = "LSlib_default_tab_insideDeepFrame",
  --tabContentFrameStyle = "LSlib_default_tab_contentFrame"   ,
  tabContentFrameStyle = "traincontroller_contentFrame"     ,
})



--------------------------------------------------------------------------------
-- Name selection tab                                                         --
--------------------------------------------------------------------------------
local guiTabContent2 = LSlib.gui.layout.getTabContentFrameFlow(guiLayout, guiTabContent, 2)

local guiSelectedEntryFlow = LSlib.gui.layout.addFlow(guiLayout, guiTabContent2, "selected-depot", "horizontal", {
  --style = "centering_horizontal_flow",
  style = "traincontroller_new_entry_flow",
})

LSlib.gui.layout.addLabel(guiLayout, guiSelectedEntryFlow, "selected-depot-label", {
  caption = {"", {"gui-traincontroller.selected-entry-label"}, " [img=info]"},
  tooltip = {"gui-traincontroller.selected-entry-label-tooltip"}             ,
})
LSlib.gui.layout.addLabel(guiLayout, guiSelectedEntryFlow, "selected-depot-name", {
  caption = "Enter controller name"                             ,
  tooltip = {"gui-traincontroller.selected-entry-label-tooltip"},
  style   = "traincontroller_selected_entry_label"              ,
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiSelectedEntryFlow, "selected-depot-enter", {
  sprite = "utility/enter",
  style = "slot_button"   ,
})

LSlib.gui.layout.addListbox(guiLayout, guiTabContent2, "selected-depot-list", {
  items = {"test1", "test2", "test3"},
  style = "traincontroller_select_name_list_box",
})



--------------------------------------------------------------------------------
-- statistics tab                                                             --
--------------------------------------------------------------------------------
local guiTabContent1 = LSlib.gui.layout.getTabContentFrameFlow(guiLayout, guiTabContent, 1)

local statistics = LSlib.gui.layout.addTable(guiLayout, guiTabContent1, "statistics", 2, {
  style = "traindepot_statistics_table",
})

-- name
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-station-id", {
  caption = {"", {"gui-traincontroller.connected-depot-name"}, " [img=info]"},
  tooltip = {"gui-traincontroller.connected-depot-name-tooltip"},
})
local stationIDflow = LSlib.gui.layout.addFlow(guiLayout, statistics, "statistics-station-id-flow", "horizontal", {
  style = "centering_horizontal_flow",
})
LSlib.gui.layout.addLabel(guiLayout, stationIDflow, "statistics-station-id-value", {
  caption = {"gui-traindepot.unused-depot-name"},
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSpriteButton(guiLayout, stationIDflow, "statistics-station-id-edit", {
  sprite = "utility/rename_icon_small",
  style = "mini_button"               ,
})

-- depot requests
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-depot-request", {
  caption = {"", {"gui-traincontroller.depot-availability"}, " [img=info]"},
  tooltip = {"gui-traincontroller.depot-availability-tooltip"},
})
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-depot-request-value", {
  caption = "-999/999",
  ignored_by_interaction = true,
})

-- controller status
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-builder-status", {
  caption = {"gui-traincontroller.builder-status"},
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-builder-status-value", {
  caption = "undefined status",
  ignored_by_interaction = true,
})

-- controller configuration
LSlib.gui.layout.addLabel(guiLayout, statistics, "statistics-builder-configuration", {
  caption = {"gui-traincontroller.builder-configuration"},
  ignored_by_interaction = true,
})
local controllerFlow = LSlib.gui.layout.addScrollPane(guiLayout, guiTabContent1, "statistics-builder-configuration-flow-scrolling", {
  horizontal_scroll_policy = "always",
  vertical_scroll_policy   = "never" ,

  style = "traincontroller_configuration_scrollpane",
})
controllerFlow = LSlib.gui.layout.addFlow(guiLayout, controllerFlow, "statistics-builder-configuration-flow", "horizontal", {
  style = "research_queue_first_slot_flow", -- no padding
})



--------------------------------------------------------------------------------
-- color picker                                                               --
--------------------------------------------------------------------------------
local colorPicker = LSlib.gui.layout.addFrame(guiLayout, guiFlow, "traincontroller-color-picker", "vertical", {
  visible = false
})
LSlib.gui.layout.addFrame(guiLayout, colorPicker, "traincontroller-color-picker-button-filler", "vertical", {
  style = "LSlib_default_header_filler",
  ignored_by_interaction = true,
})

for _,color in pairs{"red", "green", "blue"} do
  local colorName = "traincontroller-color-picker-%s"

  local colorPickerColorFlow = LSlib.gui.layout.addFlow(guiLayout, colorPicker, string.format(colorName, string.format("flow-%s", string.sub(color, 1, 1))), "horizontal", {
    style = "centering_horizontal_flow",
  })
  LSlib.gui.layout.addLabel(guiLayout, colorPickerColorFlow, string.format(colorName, "label"), {
    caption = string.upper(string.sub(color, 1, 1)),
    ignored_by_interaction = true,
  })
  LSlib.gui.layout.addSlider(guiLayout, colorPickerColorFlow, string.format(colorName, "slider"), {
    minimum_value = 0  ,
    maximum_value = 255,
    value         = 127,

    style         = string.format("%s_slider", color),
  })
  LSlib.gui.layout.addTextfield(guiLayout, colorPickerColorFlow, string.format(colorName, "textfield"), {
    text    = "-1",
    style = "slider_value_textfield",
  })
end
LSlib.gui.layout.addEntityPreview(guiLayout, colorPicker, "traincontroller-color-picker-entity-preview", {
  style = "traincontroller_color_picker_entity_preview",
  ignored_by_interaction = true,
})

local colorPickerButtonFlow = LSlib.gui.layout.addFlow(guiLayout, colorPicker, "traincontroller-color-picker-button-flow", "horizontal", {
  style = "traincontroller_color_picker_button_flow",
})
LSlib.gui.layout.addButton(guiLayout, colorPickerButtonFlow, "traincontroller-color-picker-button-discard", {
  caption = {"gui-traincontroller.discard"},
  tooltip = {"discard-changes"},
  style = "red_back_button"
})
LSlib.gui.layout.addFrame(guiLayout, colorPickerButtonFlow, "traincontroller-color-picker-button-filler", "vertical", {
  style = "LSlib_default_footer_filler",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addButton(guiLayout, colorPickerButtonFlow, "traincontroller-color-picker-button-confirm", {
  caption = {"gui-traincontroller.confirm"},
  tooltip = {"gui-traincontroller.confirm-tooltip"},
  style = "confirm_button"
})
----------------
return guiLayout
