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

    width  = 400,
    height = 300,

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

  width = 356,
}

guiStyles["traindepot_controller_minimap_flow"] = {
  type = "vertical_flow_style"   ,
  parent = "packed_vertical_flow",

  padding = 0,
}

guiStyles["traindepot_controller_minimap"] = {
  type = "minimap_style",
  parent = "minimap"    ,

  size = 160,
}

guiStyles["traindepot_controller_minimap_button"] = {
  type = "button_style",
  parent = "button"    ,

  padding = 0,

  size = 8 + guiStyles["traindepot_controller_minimap"].size,
}

guiStyles["traindepot_select_name_list_box"] = {
  type = "list_box_style",
  parent = "list_box"    ,

  vertically_stretchable   = "on",
}
