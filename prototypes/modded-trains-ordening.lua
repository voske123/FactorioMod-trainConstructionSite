local trainOrdening = {
  ["locomotive"     ] = {},
  ["cargo-wagon"    ] = {},
  ["fluid-wagon"    ] = {},
  ["artillery-wagon"] = {},
}

local function createOrdering(ordertable)
  for type,data in pairs(ordertable or {}) do
    for railwagon,order in pairs(data) do
      trainOrdening[type][railwagon] = order
    end
  end
end

createOrdering{ -- base game
  ["locomotive"] = {
    ["locomotive"] = "a[base]-a",
  },

  ["cargo-wagon"] = {
    ["cargo-wagon"] = "a[base]-b",
  },

  ["fluid-wagon"] = {
    ["fluid-wagon"] = "a[base]-c",
  },

  ["artillery-wagon"] = {
    ["artillery-wagon"] = "a[base]-d",
  },
}

if mods["angelsaddons-petrotrain"] then
  createOrdering{
    ["locomotive"] = {
      ["petro-locomotive-1"] = "y[angel]-b[petro]",
    },

    ["fluid-wagon"] = {
      ["petro-tank1"] = "y[angel]-b[petro]",
      ["petro-tank2"] = "y[angel]-b[petro]",
    },
  }
end

if mods["angelsaddons-smeltingtrain"] then
  createOrdering{
    ["locomotive"] = {
      ["smelting-locomotive-1"     ] = "y[angel]-a[smelt]",
      ["smelting-locomotive-tender"] = "y[angel]-a[smelt]",
    },

    ["cargo-wagon"] = {
      ["smelting-wagon-1"] = "y[angel]-a[smelt]",
    },
  }
end

if mods["TrainOverhaul"] then
  createOrdering{
    ["locomotive"] = {
      ["heavy-locomotive"  ] = "b[TrainOverhaul]-a[heavy]-a[locomotive]",
      ["express-locomotive"] = "b[TrainOverhaul]-b[express]-a[locomotive]",
      ["nuclear-locomotive"] = "b[TrainOverhaul]-c[nuclear]-a[locomotive]",
    },

    ["cargo-wagon"] = {
      ["heavy-cargo-wagon"  ] = "b[TrainOverhaul]-a[heavy]-b[cargo-wagon]",
      ["express-cargo-wagon"] = "b[TrainOverhaul]-b[express]-b[cargo-wagon]",
    },

    ["fluid-wagon"] = {
      ["heavy-fluid-wagon"  ] = "b[TrainOverhaul]-a[heavy]-c[fluid-wagon]",
      ["express-fluid-wagon"] = "b[TrainOverhaul]-b[express]-c[fluid-wagon]",
    },
  }
end

if mods["Realistic_Electric_Trains"] then
  createOrdering{
    ["locomotive"] = {
      ["ret-electric-locomotive"    ] = "c[Realistic_Electric_Trains]-a[electric-locomotive]-a",
      ["ret-electric-locomotive-mk2"] = "c[Realistic_Electric_Trains]-a[electric-locomotive]-b",
      ["ret-modular-locomotive"     ] = "c[Realistic_Electric_Trains]-b[modular-locomotive]-a",
    },
  }
end

return trainOrdening
