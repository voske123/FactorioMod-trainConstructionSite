require "LSlib/lib"

LSlib.styles.addTabStyle(LSlib.styles.getVanillaTabStyleSpecification())

data.raw["gui-style"]["default"]["traindepot_new_entry_flow_style"] = {
  type = "horizontal_flow_style",
  parent = "centering_horizontal_flow",
  left_padding   = 8,
  right_padding  = 8,
  bottom_padding = 8,
}
