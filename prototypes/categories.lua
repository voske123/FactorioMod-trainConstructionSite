require "util"

local transportGroup = util.table.deepcopy(data.raw["item-subgroup"]["transport"])

transportGroup.name = "transport-trains"
transportGroup.order = transportGroup.order .. "-a"



local trainRecipeGroup = util.table.deepcopy(data.raw["recipe-category"]["chemistry"])

trainRecipeGroup.name = "trainassembling"


data:extend({
  transportGroup,
  trainRecipeGroup,

})
