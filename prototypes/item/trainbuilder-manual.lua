
data:extend{{
  type = "item-with-inventory",
  name = "trainbuilder-manual",

  localised_name = {"item-name.trainbuilder-manual", {"item-name.trainassembly"}},
  localised_description = {"item-description.trainbuilder-manual"},

  icon = "__trainConstructionSite__/graphics/item/trainbuilder-manual.png",
  icon_size = 128,

  order = data.raw["item"]["rail-chain-signal"].order .. "-tb[trainbuilding]-a[manual]",
  subgroup = "transport-railway",

  stack_size = 1,
  inventory_size = 1,

  can_be_mod_opened = true,
}}
