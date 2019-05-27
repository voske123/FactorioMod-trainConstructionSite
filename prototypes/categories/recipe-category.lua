
local trainRecipeGroup = util.table.deepcopy(data.raw["recipe-category"]["chemistry"])
trainRecipeGroup.name = "trainassembling"

local characterRecipeGroup = util.table.deepcopy(trainRecipeGroup)
characterRecipeGroup.name = "manual-crafting"


data:extend{
  trainRecipeGroup    ,
  characterRecipeGroup,
}

table.insert(data.raw["god-controller"]["default"  ].crafting_categories, characterRecipeGroup.name)
table.insert(data.raw["character"     ]["character"].crafting_categories, characterRecipeGroup.name)
