require "util"

local trainassembly = util.table.deepcopy(data.raw["rail-signal"]["rail-signal"])
trainassembly["name"] = "trainassembly"
trainassembly["icon"] = "__trainConstructionSite__/graphics/placeholders/icon.png"
trainassembly["fast_replaceable_group"] = nil
trainassembly["rail_piece"] = nil
trainassembly["animation"] =
  {
    filename = "__trainConstructionSite__/graphics/placeholders/6x6.png",
    piority =  "high",
    width = 256,
    height = 256,
    frame_count = 1,
    direction_count = 8,
    hr_version = nil,

  }

data:extend({
  trainassembly,

})
