
local trainRecipeGroup = util.table.deepcopy(data.raw["recipe-category"]["chemistry"])

trainRecipeGroup.name = "trainassembling"


data:extend{
  trainRecipeGroup,

}
