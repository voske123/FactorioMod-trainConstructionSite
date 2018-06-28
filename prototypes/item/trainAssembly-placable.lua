require 'util'

local trainassembly = util.table.deepcopy(data.raw["item"]["rail-signal"])
trainassembly["name"] = "trainassembly"
trainassembly["localised_name"] = {"item-name.trainassembly"}
trainassembly["localised_description"] = {"item-description.trainassembly"}
trainassembly["icon"] = "__trainConstructionSite__/graphics/placeholders/icon.png"

data:extend({
  trainassembly,

})
