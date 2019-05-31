require "LSlib/lib"

-- default styles --------------------------------------------------------------
LSlib.styles.addFillerFrameStyles()
local guiStyles = data.raw["gui-style"]["default"]

-- help gui custom styles ------------------------------------------------------
guiStyles["trainConstructionSite_help_contentFlow"] = {
  type = "horizontal_flow_style",

  horizontal_spacing = 0,
  height = 500,
}

guiStyles["trainConstructionSite_help_scrollpane"] = {
  type   = "scroll_pane_style",
  parent = "scroll_pane"      ,

  padding = 12,
  vertically_stretchable = "on",

  vertical_flow_style = {
    type = "vertical_flow_style",
    vertical_spacing = 12,
  },
}

-- ToC
guiStyles["trainConstructionSite_help_tocButton"] = {
  type = "button_style",
  parent = "button",
  horizontally_stretchable = "on",
}

guiStyles["trainConstructionSite_help_tocButton_pressed"] = {
  type = "button_style",
  parent = "trainConstructionSite_help_tocButton",

  default_graphical_set = guiStyles["button"].clicked_graphical_set,
}

guiStyles["trainConstructionSite_help_ToC_footer_flow"] = {
  type = "horizontal_flow_style"   ,
  parent = "LSlib_default_footer",
  right_margin = -8,
}

-- Content
guiStyles["trainConstructionSite_help_contentHeader"] = {
  type = "label_style",
  parent = "heading_2_label",

  width = 500,
  single_line = false,
  bottom_margin = guiStyles["flow"].vertical_spacing - guiStyles["trainConstructionSite_help_scrollpane"].vertical_flow_style.vertical_spacing,
}

guiStyles["trainConstructionSite_help_contentText"] = {
  type = "label_style",
  parent = "label",

  width = guiStyles["trainConstructionSite_help_contentHeader"].width,
  single_line = guiStyles["trainConstructionSite_help_contentHeader"].single_line,
}

guiStyles["trainConstructionSite_help_screenshot"] = {
  type   = "image_style",
  parent = "image"      ,

  stretch_image_to_widget_size = true,
  width = guiStyles["trainConstructionSite_help_contentText"].width,
}

local guiName = "trainConstructionSite-help-content"
for _, spriteName in pairs{
  "-introduction-sprite1",
  "-traindepot-sprite1",
  "-trainbuilder-sprite1",
  "-trainbuilder-sprite2",
  "-traincontroller-sprite1",
  "-traincontroller-sprite2",
} do
  local styleParent = "trainConstructionSite_help_screenshot"
  local sprite = data.raw["sprite"][guiName..spriteName]

  guiStyles[sprite.name] = {
    type = guiStyles[styleParent].type,
    parent = styleParent,

    height = math.floor(.5 + sprite.height * guiStyles[styleParent].width / sprite.width),
  }
end
