require "LSlib/lib"

-- default styles --------------------------------------------------------------
LSlib.styles.addTabStyle(LSlib.styles.getVanillaTabStyleSpecification())
local guiStyles = data.raw["gui-style"]["default"]

-- traindepot custom styles ----------------------------------------------------
guiStyles["traindepot_contentFrame"] = {
  type   = "frame_style"                   ,
  parent = "LSlib_default_tab_contentFrame",

  vertical_flow_style = {
    type = "vertical_flow_style",
    parent = "vertical_flow"    ,

    minimal_width  = 400,
    maximal_width  = 400,
    minimal_height = 300,
    maximal_height = 300,

    bottom_padding = -8,
  }
}

guiStyles["traindepot_new_entry_flow"] = {
  type = "horizontal_flow_style"      ,
  parent = "centering_horizontal_flow",

  left_padding   = 8,
  right_padding  = 8,
  bottom_padding = 8,
}

guiStyles["traindepot_new_entry_textfield"] = {
  type = "textbox_style",
  parent = "textbox"    ,

  horizontally_stretchable = "on",
}

guiStyles["traindepot_statistics_table"] = {
  type = "table_style",

  left_cell_padding  = guiStyles["traindepot_new_entry_flow"].left_padding ,
  right_cell_padding = guiStyles["traindepot_new_entry_flow"].right_padding,

  column_widths =
  {
    {column = 1, width = 172},
    {column = 2, width = 172},
  },

  bottom_padding = 8,
}

guiStyles["traindepot_controller_minimap_scrollpane"] = {
  type = "scroll_pane_style",
  parent = "scroll_pane",

  padding = 12,

  horizontally_stretchable = "on",
  vertically_stretchable   = "on",
}

guiStyles["traindepot_controller_minimap_table"] = {
  type   = "table_style"                ,
  parent = "traindepot_statistics_table",

  cell_padding = 0,
  horizontal_spacing = guiStyles["traindepot_controller_minimap_scrollpane"].padding,
  vertical_spacing   = guiStyles["traindepot_controller_minimap_scrollpane"].padding,

  horizontally_squashable = "off",
  verticaly_squashable    = "off",

  minimal_width = 356,
  maximal_width = 356,
}

guiStyles["traindepot_controller_minimap_flow"] = {
  type = "vertical_flow_style"   ,
  parent = "packed_vertical_flow",

  padding = 0,
}

guiStyles["traindepot_controller_minimap"] = {
  type = "minimap_style",
  parent = "minimap"    ,

  minimal_width  = 160,
  maximal_width  = 160,
  minimal_height = 160,
  maximal_height = 160,
}

guiStyles["traindepot_controller_minimap_button"] = {
  type = "button_style",
  parent = "button"    ,

  padding = 0,

  minimal_width  = 8 + guiStyles["traindepot_controller_minimap"].minimal_width ,
  maximal_width  = 8 + guiStyles["traindepot_controller_minimap"].maximal_width ,
  minimal_height = 8 + guiStyles["traindepot_controller_minimap"].minimal_height,
  maximal_heigh  = 8 + guiStyles["traindepot_controller_minimap"].maximal_height,
}

guiStyles["traindepot_select_name_list_box"] = {
  type = "list_box_style",
  parent = "list_box"    ,

  vertically_stretchable   = "on",
}



-- traincontroller custom styles -----------------------------------------------
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
