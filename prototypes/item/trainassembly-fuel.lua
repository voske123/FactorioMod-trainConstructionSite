require "util"

local trainassemblyTrainfuel = util.table.deepcopy(data.raw["item"]["rocket-fuel"])

trainassemblyTrainfuel.name        = "trainassembly-trainfuel"
trainassemblyTrainfuel.icon        = "__trainConstructionSite__/graphics/placeholders/icon.png"
trainassemblyTrainfuel.icon_size   = 32
trainassemblyTrainfuel.subgroup    = "transport-trains"
trainassemblyTrainfuel.order       = "b"

local trainassemblyRecipefuel = util.table.deepcopy(trainassemblyTrainfuel)

trainassemblyRecipefuel.name                          = "trainassembly-Recipefuel"
trainassemblyRecipefuel.fuel_value                    = nil
trainassemblyRecipefuel.fuel_category                 = nil
trainassemblyRecipefuel.fuel_acceleration_multiplier  = nil
trainassemblyRecipefuel.fuel_top_speed_multiplier     = nil
trainassemblyRecipefuel.fuel_glow_color               = nil
trainassemblyRecipefuel.fuel_emission_multiplier      = nil

data:extend({
  trainassemblyTrainfuel,
  trainassemblyRecipefuel,

})
