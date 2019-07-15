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

if mods["boblogistics"] then
  createOrdering{
    ["locomotive"] = {
      ["bob-locomotive-2"         ] = "b[boblogistics]-a[regular-mk2]-a[locomotive]",
      ["bob-locomotive-3"         ] = "b[boblogistics]-b[regular-mk3]-a[locomotive]",
      ["bob-armoured-locomotive"  ] = "b[boblogistics]-c[armoured-mk1]-a[locomotive]",
      ["bob-armoured-locomotive-2"] = "b[boblogistics]-d[armoured-mk2]-a[locomotive]",
    },

    ["cargo-wagon"] = {
      ["bob-cargo-wagon-2"         ] = "b[boblogistics]-a[regular-mk2]-b[cargo-wagon]",
      ["bob-cargo-wagon-3"         ] = "b[boblogistics]-b[regular-mk3]-b[cargo-wagon]",
      ["bob-armoured-cargo-wagon"  ] = "b[boblogistics]-c[armoured-mk1]-b[cargo-wagon]",
      ["bob-armoured-cargo-wagon-2"] = "b[boblogistics]-d[armoured-mk2]-b[cargo-wagon]",
    },
    
    ["fluid-wagon"] = {
      ["bob-fluid-wagon-2"         ] = "b[boblogistics]-a[regular-mk2]-c[fluid-wagon]",
      ["bob-fluid-wagon-3"         ] = "b[boblogistics]-b[regular-mk3]-c[fluid-wagon]",
      ["bob-armoured-fluid-wagon"  ] = "b[boblogistics]-c[armoured-mk1]-c[fluid-wagon]",
      ["bob-armoured-fluid-wagon-2"] = "b[boblogistics]-d[armoured-mk2]-c[fluid-wagon]",
    },
  }
end

if mods["TrainOverhaul"] then
  createOrdering{
    ["locomotive"] = {
      ["heavy-locomotive"  ] = "c[TrainOverhaul]-a[heavy]-a[locomotive]",
      ["express-locomotive"] = "c[TrainOverhaul]-b[express]-a[locomotive]",
      ["nuclear-locomotive"] = "c[TrainOverhaul]-c[nuclear]-a[locomotive]",
    },

    ["cargo-wagon"] = {
      ["heavy-cargo-wagon"  ] = "c[TrainOverhaul]-a[heavy]-b[cargo-wagon]",
      ["express-cargo-wagon"] = "c[TrainOverhaul]-b[express]-b[cargo-wagon]",
    },

    ["fluid-wagon"] = {
      ["heavy-fluid-wagon"  ] = "c[TrainOverhaul]-a[heavy]-c[fluid-wagon]",
      ["express-fluid-wagon"] = "c[TrainOverhaul]-b[express]-c[fluid-wagon]",
    },
  }
end

if mods["Realistic_Electric_Trains"] then
  createOrdering{
    ["locomotive"] = {
      ["ret-electric-locomotive"    ] = "z[Realistic_Electric_Trains]-a[electric-locomotive]-a[mk1]",
      ["ret-electric-locomotive-mk2"] = "z[Realistic_Electric_Trains]-a[electric-locomotive]-b[mk2]",
      ["ret-modular-locomotive"     ] = "z[Realistic_Electric_Trains]-b[modular-locomotive]-a",
    },
  }
end

if mods["accumulator-wagon"] then
  createOrdering{
    ["fluid-wagon"] = {
      ["accumulator-wagon"] = "z[accumulator-wagon]-a[accumulator]-a",
    },
  }
end

if mods["Armored-train"] then
  createOrdering{
    ["locomotive"] = {
      ["armored-locomotive-mk1"] = "y[Armored-train]-a[armored-locomotive]-a",
    },

    ["cargo-wagon"] = {
      ["armored-platform-mk1"        ] = "y[Armored-train]-b[armored-platform]-a[platform]",
      ["armored-platform-minigun-mk1"] = "y[Armored-train]-b[armored-platform]-b[minigun]",
      ["armored-platform-rocket-mk1" ] = "y[Armored-train]-b[armored-platform]-c[rocket]",
      ["armored-wagon-mk1"           ] = "y[Armored-train]-b[armored-wagon]-a[wagon]",
      ["armored-wagon-cannon-mk1"    ] = "y[Armored-train]-b[armored-wagon]-b[cannon]",
      ["armored-wagon-chaingun-mk1"  ] = "y[Armored-train]-b[armored-wagon]-c[chaingun]",
    },
  }
end

if mods["FARL"] then
  createOrdering{
    ["locomotive"] = {
      ["farl"] = "a[farl]-a",
    },
  }
end

return trainOrdening
