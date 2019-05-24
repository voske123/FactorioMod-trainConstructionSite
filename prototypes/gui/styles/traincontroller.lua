require "LSlib/lib"

-- default styles --------------------------------------------------------------
LSlib.styles.addTabStyle(LSlib.styles.getVanillaTabStyleSpecification())
LSlib.styles.addFillerFrameStyle()
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
  minimal_width = 175,
  maximal_width = 175,
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

guiStyles["traincontroller_color_picker_button_flow"] = {
  type = "horizontal_flow_style"   ,
  parent = "centering_horizontal_flow",
  top_padding = 4
}

guiStyles["traincontroller_color_indicator"] = {
  type = "progressbar_style",
  --parent = "progressbar",
  bar_width = 36,
  bar =
  {
    filename = "__core__/graphics/gui.png",
    position = {221, 0},
    size = {1, 1},
    scale = 1
  },
  bar_background =
  {
    filename = "__core__/graphics/gui.png",
    position = {225, 0},
    size = {1, 13},
    scale = 1
  },
  width=14,
  height=35,
  right_padding = 0,
  left_padding = 0,
  bottom_padding = 2
}

guiStyles["traincontroller_button_filler"] = {
  type = "frame_style",
  parent = "LSlib_default_filler_frame",

  minimal_height = guiStyles["dialog_button"].height,
  maximal_height = guiStyles["dialog_button"].height,
}
