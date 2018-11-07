require "util"

local transportLogistics = util.table.deepcopy(data.raw["item-group"]["logistics"])

  --Maingroup for all the subgroups involved in trains

  transportLogistics.name = "transport-logistics"
  transportLogistics.localised_name = {"item-group-name.transportLogistics"}
  transportLogistics.order = transportLogistics.order .. "a[transport]"
  transportLogistics.icon = "__trainConstructionSite__/graphics/placeholders/icon.png"
  transportLogistics.icon_size = 32

local transportRailway = util.table.deepcopy(data.raw["item-subgroup"]["transport"])

  --Rails, assembler, trainstop, depo, railsignal and chainsignal.

  transportRailway.name = "transport-railway"
  transportRailway.group = transportLogistics.name
  transportRailway.order = "a"

local trainassemblerFuel = util.table.deepcopy(transportRailway)

  --fuel

  trainassemblerFuel.name = "trainassembler-fuel"
  trainassemblerFuel.order = "b"

local trainpartsFluid = util.table.deepcopy(transportRailway)

  --trainparts fluid

  trainpartsFluid.name = "trainparts-fluid"
  trainpartsFluid.order = "d"


data.raw["item-subgroup"]["transport"].group = transportRailway.group
data.raw["item-subgroup"]["transport"].order = "c"


data:extend{
  transportLogistics,
  transportRailway,
  trainassemblerFuel,
  trainpartsFluid,
}
