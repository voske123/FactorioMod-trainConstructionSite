local recipeOverride = {
  ["locomotive"     ] = {},
  ["cargo-wagon"    ] = {},
  ["fluid-wagon"    ] = {},
  ["artillery-wagon"] = {},
}

local function addrecipeOverride(ordertable)
  --["trainType"] = {["itemName"] = "recipeName"}
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

if mods["fast_trans"] then
  addrecipeOverride{
    ["locomotive"] = {
      ["fast-one"] = "fast-one-ceva text aici",
      ["fast-one-mk2"] = "fast-one-mk2 txt",
      ["fast-one-mk3"] = "fast-one-mk3 txt",
    },
  }
end

return recipeOverride
