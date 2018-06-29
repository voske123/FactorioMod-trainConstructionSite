require "util"

local trainassembly = util.table.deepcopy(data.raw["item"]["trainassembly"])

trainassembly.name = "trainassembly-machine"
trainassembly.place_result = "trainassembly-machine"

data:extend({
  trainassembly,
})
