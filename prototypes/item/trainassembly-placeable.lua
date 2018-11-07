require 'util'

-- the placeable entity is linked to this item
local trainassembly = util.table.deepcopy(data.raw["item"]["rail-signal"])

trainassembly.name  = "trainassembly"
trainassembly.localised_name = {"item-name.trainassembly"}
trainassembly.localised_description = {"item-description.trainassembly"}

trainassembly.icon = "__trainConstructionSite__/graphics/placeholders/icon.png"
trainassembly.icons = nil
trainassembly.icon_size = 32

trainassembly.subgroup = "transport-railway"
trainassembly.order = "a-b"

trainassembly.place_result = "trainassembly-placeable" -- the name of the placable entity

trainassembly.stack_size = 10



data:extend{
  trainassembly,
}
