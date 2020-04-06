local recipeOverride = {
  ["locomotive"     ] = {},
  ["cargo-wagon"    ] = {},
  ["fluid-wagon"    ] = {},
  ["artillery-wagon"] = {},
}

local function addrecipeOverride(ordertable)
  for type,data in pairs(ordertable or {}) do
    for railwagon,item in pairs(data) do
      recipeOverride[type][railwagon] = item
    end
  end
end

if mods["TrainOverhaul"] then
  addrecipeOverride{
    ["locomotive"] = {
      ["nuclear-locomotive"] = "express-nuclear-locomotive",
    },
  }
end

return recipeOverride
