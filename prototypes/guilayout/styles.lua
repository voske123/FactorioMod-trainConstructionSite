require "LSlib/lib"

LSlib.styles.addTabStyle(LSlib.styles.getVanillaTabStyleSpecification())

local guiStyles = data.raw["gui-style"]["default"]

guiStyles["traindepot_contentFrame"] = {
  type   = "frame_style",
  parent = "LSlib_default_tab_contentFrame",

  vertical_flow_style = {
    type = "vertical_flow_style",
    parent = "vertical_flow",

    natural_width  = 400,
    maximal_width  = 400,
    natural_height = 300,
    maximal_height = 300,
  }
}

guiStyles["traindepot_new_entry_flow_style"] = {
  type = "horizontal_flow_style",
  parent = "centering_horizontal_flow",
  left_padding   = 8,
  right_padding  = 8,
  bottom_padding = 8,
}

guiStyles["traindepot_statistics_table"] = {
  type = "table_style",

  left_cell_padding  = guiStyles["traindepot_new_entry_flow_style"].left_padding ,
  right_cell_padding = guiStyles["traindepot_new_entry_flow_style"].right_padding,

  column_widths =
  {
    {column = 1, width = 172},
    {column = 2, width = 172},
  }
}
