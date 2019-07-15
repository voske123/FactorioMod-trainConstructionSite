local itemOverride = {
  ["locomotive"     ] = {},
  ["cargo-wagon"    ] = {},
  ["fluid-wagon"    ] = {},
  ["artillery-wagon"] = {},
}

local function addItemOverride(ordertable)
  for type,data in pairs(ordertable or {}) do
    for railwagon,item in pairs(data) do
      itemOverride[type][railwagon] = item
    end
  end
end

if mods["Armored-train"] then
  addItemOverride{
    ["locomotive"] = {
      --["armored-locomotive-mk1"] = "armored-locomotive-mk1",
    },

    ["cargo-wagon"] = {
      --["armored-platform-mk1"        ] = "armored-platform-mk1",
      ["armored-platform-minigun-mk1"] = "armored-platform-minigun-mk1",
      ["armored-platform-rocket-mk1" ] = "armored-platform-rocket-mk1" ,
      --["armored-wagon-mk1"           ] = "armored-wagon-mk1",
      ["armored-wagon-cannon-mk1"    ] = "armored-wagon-cannon-mk1",
      ["armored-wagon-chaingun-mk1"  ] = "armored-wagon-chaingun-mk1",
    },
  }
end

if mods["FARL"] then
  addItemOverride{
    ["locomotive"] = {
      ["farl"] = "farl",
    },
  }
end

return itemOverride
