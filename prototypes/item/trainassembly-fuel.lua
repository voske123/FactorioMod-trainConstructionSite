
-- For the fuel needed to kick-start the engine to roll to a station, we need some fuel.
-- Becose we don't want 10 different recipes for each fuel type, we make a new fuel type
-- for this purpose only.

-- Becose of this, we don't want players to be able to insert this fuel into a train. For
-- this reason we make an item the player can craft without a fuel_value that they can
-- have in there inventory and we also make a copy of this with a fuel_value that the
-- code will manualy insert into the locomotives.

-- STEP 1: create the actual fuel item
local trainassemblyTrainfuel = util.table.deepcopy(data.raw["item"]["rocket-fuel"])

trainassemblyTrainfuel.name           = "trainassembly-trainfuel"
trainassemblyTrainfuel.localised_name = {"item-name.trainassemblyfuel"}
trainassemblyTrainfuel.icon           = nil--"__trainConstructionSite__/graphics/placeholders/icon.png"
trainassemblyTrainfuel.icon_size      = nil--32
trainassemblyTrainfuel.icons          = {
  {
    icon      = "__trainConstructionSite__/graphics/item/trainfuel/loco/loco-64.png",
    icon_size = 64,
    shift     = {10, 0}
  },
  {
    icon      = "__trainConstructionSite__/graphics/item/trainfuel/fuel-handle/fuel-handle-32.png",
    icon_size = 32,
    shift     = {-16, -20},
    scale     = 1.2,
  }
}
trainassemblyTrainfuel.subgroup       = "trainassembler-fuel"
trainassemblyTrainfuel.order          = "b"

-- STEP 2: create a duplicate of this item and remove the fuel information
local trainassemblyRecipefuel = util.table.deepcopy(trainassemblyTrainfuel)

trainassemblyRecipefuel.name                          = "trainassembly-recipefuel"
trainassemblyRecipefuel.fuel_value                    = nil
trainassemblyRecipefuel.fuel_category                 = nil
trainassemblyRecipefuel.fuel_acceleration_multiplier  = nil
trainassemblyRecipefuel.fuel_top_speed_multiplier     = nil
trainassemblyRecipefuel.fuel_glow_color               = nil
trainassemblyRecipefuel.fuel_emission_multiplier      = nil

-- STEP 3: make sure the player only can see the recipefuel
trainassemblyTrainfuel.flags = trainassemblyTrainfuel.flags or {}
table.insert(trainassemblyTrainfuel.flags, "hidden")
table.insert(trainassemblyTrainfuel.flags, "hide-from-bonus-gui")
table.insert(trainassemblyTrainfuel.flags, "hide-from-fuel-tooltip")

-- STEP 4: add both items to the game
data:extend{
  trainassemblyTrainfuel,
  trainassemblyRecipefuel,
}
