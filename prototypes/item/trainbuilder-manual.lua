
data:extend{
  {
    type = "selection-tool",
    name = "trainbuilder-manual",

    localised_name = {"item-name.trainbuilder-manual", {"item-name.trainassembly"}},
    localised_description = {"item-description.trainbuilder-manual"},

    icon = "__trainConstructionSite__/graphics/item/trainbuilder-manual.png",
    icon_size = 128,

    order = "d[trainbuilder]-a[manual]",
    subgroup = "transport-railway",

    stack_size = 10,
    stackable = true,
    show_in_library = false,

    can_be_mod_opened = true,

    mouse_cursor = "trainbuilder-manual",

    selection_color           = {a=0},
    selection_mode            = {"nothing"},
    selection_cursor_box_type = "copy",

    alt_selection_color           = {a=0},
    alt_selection_mode            = {"nothing"},
    alt_selection_cursor_box_type = "copy",
  },
  {
    type = "mouse-cursor",
    name = "trainbuilder-manual",
    system_cursor = "arrow",
  }
}
