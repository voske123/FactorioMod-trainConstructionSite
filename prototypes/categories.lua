require "util"

local transportGroup = util.table.deepcopy(data.raw["item-subgroup"]["transport"])

transportGroup.name = "transport-trains"
transportGroup.order = transportGroup.order .. "-a"

data:extend({
  transportGroup,

})
