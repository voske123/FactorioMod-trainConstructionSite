require "LSlib/lib"

-- default styles --------------------------------------------------------------
LSlib.styles.addTabStyle(LSlib.styles.getVanillaTabStyleSpecification())
LSlib.styles.addFillerFrameStyles()
local guiStyles = data.raw["gui-style"]["default"]

-- traincontroller custom styles -----------------------------------------------
guiStyles["traincontroller_contentFlow"] = {
  type   = "horizontal_flow_style",

  horizontal_spacing = 0,
}

guiStyles["traincontroller_contentFrame"] = {
  type   = guiStyles["traindepot_contentFrame"].type,
  parent = "traindepot_contentFrame",
}

guiStyles["traincontroller_new_entry_flow"] = {
  type   = guiStyles["traindepot_new_entry_flow"].type,
  parent = "traindepot_new_entry_flow",
}

guiStyles["traincontroller_new_entry_textfield"] = {
  type = "textbox_style",
  parent = "traindepot_new_entry_textfield",
}

guiStyles["traincontroller_select_name_list_box"] = {
  type   = guiStyles["traindepot_select_name_list_box"].type,
  parent = "traindepot_select_name_list_box",
}

guiStyles["traincontroller_selected_entry_label"] = {
  type          = "label_style",
  parent        = "label"      ,

  left_padding  = 8  ,
  width = 175,
}

guiStyles["traincontroller_configuration_scrollpane"] = {
  type = "scroll_pane_style",
  parent = "traindepot_controller_minimap_scrollpane",

  padding = 12,
  horizontally_stretchable = "on",
}

guiStyles["traincontroller_configuration_flow"] = {
  type = "vertical_flow_style"   ,
  parent = "traindepot_controller_minimap_flow",
}

-- Color picker custom styles --------------------------------------------------
guiStyles["traincontroller_color_picker_entity_preview"] = {
  type = "empty_widget_style",
  parent = "empty_widget",

  minimal_width  = guiStyles["entity_button_base"].size,
  minimal_height = guiStyles["entity_button_base"].size,

  horizontally_stretchable = "on",
  vertically_stretchable = "on",

  left_margin   = 0,
  right_margin  = 4,
  top_margin    = 8,
  bottom_margin = 8,

  graphical_set = guiStyles["scroll_pane"].graphical_set,
}

guiStyles["traincontroller_color_picker_button_flow"] = {
  type = "horizontal_flow_style"   ,
  parent = "centering_horizontal_flow",
  top_padding = 4
}

guiStyles["traincontroller_color_indicator_button_housing"] = {
  type = "button_style",
  parent = "icon_button",

  padding = 0,
}

guiStyles["traincontroller_color_indicator_button_housing_pressed"] = {
  type = "button_style",
  parent = "traincontroller_color_indicator_button_housing",

  default_graphical_set = guiStyles["button"].clicked_graphical_set,
  padding = guiStyles["traincontroller_color_indicator_button_housing"].padding - 1,
}

guiStyles["traincontroller_color_indicator_button_color"] = {
  type = "progressbar_style",
  --parent = "progressbar",
  bar_width = 36,
  bar =
  {
    filename = "__core__/graphics/gui.png",
    position = {221, 0},
    size = {1, 1},
    scale = 1,
  },
  bar_background =
  {
    filename = "__core__/graphics/gui.png",
    position = {225, 0},
    size = {1, 13},
    scale = 1,
  },

  width=guiStyles["icon_button"].size - 2 * guiStyles["icon_button"].default_graphical_set.corner_size,
  height=guiStyles["icon_button"].size - 2 * guiStyles["icon_button"].default_graphical_set.corner_size,

  padding = 0,
}

guiStyles["traincontroller_color_indicator_button_sprite"] = {
  type = "button_style",
  parent = "traincontroller_color_indicator_button_housing",

  default_graphical_set =
  {
    filename = "__core__/graphics/empty.png",
    width = 1,
    height = 1,
  },

  width  = guiStyles["traincontroller_color_indicator_button_color"].width ,
  height = guiStyles["traincontroller_color_indicator_button_color"].height,

  left_padding   = math.floor(0.5 + .1   * guiStyles["traincontroller_color_indicator_button_color"].width ),
  rigth_padding  = math.floor(0.5 + .125 * guiStyles["traincontroller_color_indicator_button_color"].width ),
  top_padding    = math.floor(0.5 + .125 * guiStyles["traincontroller_color_indicator_button_color"].height),
  bottom_padding = math.floor(0.5 + .125 * guiStyles["traincontroller_color_indicator_button_color"].height),
}
