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
    ["locomotive"] = "aa[locomotive]-a[base]",
  },

  ["cargo-wagon"] = {
    ["cargo-wagon"] = "ab[cargo-wagon]-a[base]",
  },

  ["fluid-wagon"] = {
    ["fluid-wagon"] = "ac[fluid-wagon]-a[base]",
  },

  ["artillery-wagon"] = {
    ["artillery-wagon"] = "ad[artillery-wagon]-a[base]",
  },
}

if mods["angelsaddons-petrotrain"] or mods["angelsaddons-mobility"] then
  local electricVersion = mods["Electronic_Angels_Locomotives"] and true or false
  createOrdering{
    ["locomotive"] = {
      ["petro-locomotive-1"  ] = "y[angel]-b[petro]-a-aa",
      ["petro-locomotive-1-2"] = "y[angel]-b[petro]-a-ab",
      ["petro-locomotive-1-3"] = "y[angel]-b[petro]-a-ac",
      ["petro-locomotive-1-4"] = "y[angel]-b[petro]-a-ad",
      ["petro-locomotive-1-5"] = "y[angel]-b[petro]-a-ae",

      ["electronic-petro-locomotive-1"  ] = electricVersion and "y[angel]-b[petro]-b-aa" or nil,
      ["electronic-petro-locomotive-1-2"] = electricVersion and "y[angel]-b[petro]-b-ab" or nil,
      ["electronic-petro-locomotive-1-3"] = electricVersion and "y[angel]-b[petro]-b-ac" or nil,
      ["electronic-petro-locomotive-1-4"] = electricVersion and "y[angel]-b[petro]-b-ad" or nil,
      ["electronic-petro-locomotive-1-5"] = electricVersion and "y[angel]-b[petro]-b-ae" or nil,
    },

    ["fluid-wagon"] = {
      ["petro-tank1"  ] = "y[angel]-b[petro]-c-aa",
      ["petro-tank1-2"] = "y[angel]-b[petro]-c-ab",
      ["petro-tank1-3"] = "y[angel]-b[petro]-c-ac",
      ["petro-tank1-4"] = "y[angel]-b[petro]-c-ad",
      ["petro-tank1-5"] = "y[angel]-b[petro]-c-ae",

      ["petro-tank2"  ] = "y[angel]-b[petro]-c-ba",
      ["petro-tank2-2"] = "y[angel]-b[petro]-c-bb",
      ["petro-tank2-3"] = "y[angel]-b[petro]-c-bc",
      ["petro-tank2-4"] = "y[angel]-b[petro]-c-bd",
      ["petro-tank2-5"] = "y[angel]-b[petro]-c-be",
    },
  }
end

if mods["angelsaddons-smeltingtrain"] or mods["angelsaddons-mobility"] then
  local electricVersion = mods["Electronic_Angels_Locomotives"] and true or false
  createOrdering{
    ["locomotive"] = {
      ["smelting-locomotive-1"       ] = "y[angel]-c[smelt]-a-aa",
      ["smelting-locomotive-1-2"     ] = "y[angel]-c[smelt]-a-ab",
      ["smelting-locomotive-1-3"     ] = "y[angel]-c[smelt]-a-ac",
      ["smelting-locomotive-1-4"     ] = "y[angel]-c[smelt]-a-ad",
      ["smelting-locomotive-1-5"     ] = "y[angel]-c[smelt]-a-ae",

      ["smelting-locomotive-tender"  ] = "y[angel]-c[smelt]-a-ba",
      ["smelting-locomotive-tender-2"] = "y[angel]-c[smelt]-a-bb",
      ["smelting-locomotive-tender-3"] = "y[angel]-c[smelt]-a-bc",
      ["smelting-locomotive-tender-4"] = "y[angel]-c[smelt]-a-bd",
      ["smelting-locomotive-tender-5"] = "y[angel]-c[smelt]-a-be",

      ["electronic-smelting-locomotive-1"       ] = electricVersion and "y[angel]-c[smelt]-b-aa" or nil,
      ["electronic-smelting-locomotive-1-2"     ] = electricVersion and "y[angel]-c[smelt]-b-ab" or nil,
      ["electronic-smelting-locomotive-1-3"     ] = electricVersion and "y[angel]-c[smelt]-b-ac" or nil,
      ["electronic-smelting-locomotive-1-4"     ] = electricVersion and "y[angel]-c[smelt]-b-ad" or nil,
      ["electronic-smelting-locomotive-1-5"     ] = electricVersion and "y[angel]-c[smelt]-b-ae" or nil,

      ["electronic-smelting-locomotive-tender"  ] = electricVersion and "y[angel]-c[smelt]-b-ba" or nil,
      ["electronic-smelting-locomotive-tender-2"] = electricVersion and "y[angel]-c[smelt]-b-bb" or nil,
      ["electronic-smelting-locomotive-tender-3"] = electricVersion and "y[angel]-c[smelt]-b-bc" or nil,
      ["electronic-smelting-locomotive-tender-4"] = electricVersion and "y[angel]-c[smelt]-b-bd" or nil,
      ["electronic-smelting-locomotive-tender-5"] = electricVersion and "y[angel]-c[smelt]-b-be" or nil,
    },

    ["cargo-wagon"] = {
      ["smelting-wagon-1"  ] = "y[angel]-c[smelt]-c-aa",
      ["smelting-wagon-1-2"] = "y[angel]-c[smelt]-c-ab",
      ["smelting-wagon-1-3"] = "y[angel]-c[smelt]-c-ac",
      ["smelting-wagon-1-4"] = "y[angel]-c[smelt]-c-ad",
      ["smelting-wagon-1-5"] = "y[angel]-c[smelt]-c-ae",
    },
  }
end

if mods["angelsaddons-crawlertrain"] or mods["angelsaddons-mobility"] then
  local electricVersion = mods["Electronic_Angels_Locomotives"] and true or false
  createOrdering{
    ["locomotive"] = {
      ["crawler-locomotive"      ] = "y[angel]-a[crawler]-a-aa",
      ["crawler-locomotive-2"    ] = "y[angel]-a[crawler]-a-ab",
      ["crawler-locomotive-3"    ] = "y[angel]-a[crawler]-a-ac",
      ["crawler-locomotive-4"    ] = "y[angel]-a[crawler]-a-ad",
      ["crawler-locomotive-5"    ] = "y[angel]-a[crawler]-a-ae",

      ["crawler-locomotive-wagon"  ] = "y[angel]-a[crawler]-a-ba",
      ["crawler-locomotive-wagon-2"] = "y[angel]-a[crawler]-a-bb",
      ["crawler-locomotive-wagon-3"] = "y[angel]-a[crawler]-a-bc",
      ["crawler-locomotive-wagon-4"] = "y[angel]-a[crawler]-a-bd",
      ["crawler-locomotive-wagon-5"] = "y[angel]-a[crawler]-a-be",

      ["electronic-crawler-locomotive"      ] = electricVersion and "y[angel]-a[crawler]-b-aa" or nil,
      ["electronic-crawler-locomotive-2"    ] = electricVersion and "y[angel]-a[crawler]-b-ab" or nil,
      ["electronic-crawler-locomotive-3"    ] = electricVersion and "y[angel]-a[crawler]-b-ac" or nil,
      ["electronic-crawler-locomotive-4"    ] = electricVersion and "y[angel]-a[crawler]-b-ad" or nil,
      ["electronic-crawler-locomotive-5"    ] = electricVersion and "y[angel]-a[crawler]-b-ae" or nil,

      ["electronic-crawler-locomotive-wagon"  ] = electricVersion and "y[angel]-a[crawler]-b-ba" or nil,
      ["electronic-crawler-locomotive-wagon-2"] = electricVersion and "y[angel]-a[crawler]-b-bb" or nil,
      ["electronic-crawler-locomotive-wagon-3"] = electricVersion and "y[angel]-a[crawler]-b-bc" or nil,
      ["electronic-crawler-locomotive-wagon-4"] = electricVersion and "y[angel]-a[crawler]-b-bd" or nil,
      ["electronic-crawler-locomotive-wagon-5"] = electricVersion and "y[angel]-a[crawler]-b-be" or nil,
    },

    ["cargo-wagon"] = {
      ["crawler-wagon"      ] = "y[angel]-a[crawler]-c-aa",
      ["crawler-wagon-2"    ] = "y[angel]-a[crawler]-c-ab",
      ["crawler-wagon-3"    ] = "y[angel]-a[crawler]-c-ac",
      ["crawler-wagon-4"    ] = "y[angel]-a[crawler]-c-ad",
      ["crawler-wagon-5"    ] = "y[angel]-a[crawler]-c-ae",

      ["crawler-bot-wagon"  ] = "y[angel]-a[crawler]-c-ba",
      ["crawler-bot-wagon-2"] = "y[angel]-a[crawler]-c-bb",
      ["crawler-bot-wagon-3"] = "y[angel]-a[crawler]-c-bc",
      ["crawler-bot-wagon-4"] = "y[angel]-a[crawler]-c-bd",
      ["crawler-bot-wagon-5"] = "y[angel]-a[crawler]-c-be",
    },
  }
end

if mods["boblogistics"] then
  createOrdering{
    ["locomotive"] = {
      ["bob-locomotive-2"         ] = "aa[locomotive]-b[boblogistics]-a[regular-mk2]",
      ["bob-locomotive-3"         ] = "aa[locomotive]-b[boblogistics]-b[regular-mk3]",
      ["bob-armoured-locomotive"  ] = "aa[locomotive]-b[boblogistics]-c[armoured-mk1]",
      ["bob-armoured-locomotive-2"] = "aa[locomotive]-b[boblogistics]-d[armoured-mk2]",
    },

    ["cargo-wagon"] = {
      ["bob-cargo-wagon-2"         ] = "ab[cargo-wagon]-b[boblogistics]-a[regular-mk2]",
      ["bob-cargo-wagon-3"         ] = "ab[cargo-wagon]-b[boblogistics]-b[regular-mk3]",
      ["bob-armoured-cargo-wagon"  ] = "ab[cargo-wagon]-b[boblogistics]-c[armoured-mk1]",
      ["bob-armoured-cargo-wagon-2"] = "ab[cargo-wagon]-b[boblogistics]-d[armoured-mk2]",
    },

    ["fluid-wagon"] = {
      ["bob-fluid-wagon-2"         ] = "ac[fluid-wagon]-b[boblogistics]-a[regular-mk2]",
      ["bob-fluid-wagon-3"         ] = "ac[fluid-wagon]-b[boblogistics]-b[regular-mk3]",
      ["bob-armoured-fluid-wagon"  ] = "ac[fluid-wagon]-b[boblogistics]-c[armoured-mk1]",
      ["bob-armoured-fluid-wagon-2"] = "ac[fluid-wagon]-b[boblogistics]-d[armoured-mk2]",
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

if mods["FactorioExtended-Plus-Transport"] then
  createOrdering{
    ["locomotive"] = {
      ["locomotive-mk2"] = "aa[locomotive]-c[FactorioExtended-Plus]-a[mk2]-a[locomotive]",
      ["locomotive-mk3"] = "aa[locomotive]-c[FactorioExtended-Plus]-b[mk3]-a[locomotive]",
    },
    ["cargo-wagon"] = {
      ["cargo-wagon-mk2"] = "ab[cargo-wagon]-c[FactorioExtended-Plus]-a[mk2]-b[cargo-wagon]",
      ["cargo-wagon-mk3"] = "ab[cargo-wagon]-c[FactorioExtended-Plus]-b[mk3]-b[cargo-wagon]",
    },
    ["fluid-wagon"] = {
      ["fluid-wagon-mk2"] = "ac[fluid-wagon]-c[FactorioExtended-Plus]-a[mk2]-c[fluid-wagon]",
      ["fluid-wagon-mk3"] = "ac[fluid-wagon]-c[FactorioExtended-Plus]-b[mk3]-c[fluid-wagon]",
    },
  }
end

if mods["RailPowerSystem"] then
  createOrdering{
    ["locomotive"] = {
      ["hybrid-train"] = "z[RailPowerSystem]-a[hybrid-train]",
    },
  }
end

if mods["Electronic_Locomotives"] then
  createOrdering{
    ["locomotive"] = {
      ["Electronic-Standard-Locomotive" ] = "z[Senpais_Electronic_Locomotives]-a[regular]-a",
      ["Electronic-Cargo-Locomotive"    ] = "z[Senpais_Electronic_Locomotives]-a[regular]-b",
    },
  }
end

if mods["Electronic_Battle_Locomotives"] then
  createOrdering{
    ["locomotive"] = {
      ["Electronic-Battle-Locomotive-1"] = "z[Senpais_Electronic_Locomotives]-b[battle]-a",
      ["Electronic-Battle-Locomotive-2"] = "z[Senpais_Electronic_Locomotives]-b[battle]-b",
      ["Electronic-Battle-Locomotive-3"] = "z[Senpais_Electronic_Locomotives]-b[battle]-c",
    },
  }
end

return trainOrdening
