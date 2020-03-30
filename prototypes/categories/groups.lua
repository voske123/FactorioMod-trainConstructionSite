
local transportLogistics = util.table.deepcopy(data.raw["item-group"]["logistics"])

  --Maingroup for all the subgroups involved in trains

  transportLogistics.name = "transport-logistics"
  transportLogistics.localised_name = {"item-group-name.transportLogistics"}
  transportLogistics.order = transportLogistics.order .. "a[transport]"
  transportLogistics.icon = "__trainConstructionSite__/graphics/technology/trainassembly.png"
  transportLogistics.icon_size = 128

local transportRailway = util.table.deepcopy(data.raw["item-subgroup"]["transport"])

  --Rails, assembler, trainstop, depo, railsignal and chainsignal.

  transportRailway.name = "transport-railway"
  transportRailway.group = transportLogistics.name
  transportRailway.order = "a"

local trainassemblerFuel = util.table.deepcopy(transportRailway)

  --fuel

  trainassemblerFuel.name = "trainassembler-fuel"
  trainassemblerFuel.order = "b"


local manualBuildVehicles = util.table.deepcopy(transportRailway)

  --manual buildable vehicles

  manualBuildVehicles.name = "manual-buildable-vehicles"
  manualBuildVehicles.order = "c"

local trainpartsFluid = util.table.deepcopy(transportRailway)

  --trainparts fluid

  trainpartsFluid.name = "trainparts-fluid"
  trainpartsFluid.order = "e"


data.raw["item-subgroup"]["transport"].group = transportRailway.group
data.raw["item-subgroup"]["transport"].order = "d"


for _, vehicleName in pairs{
  "car",
  "tank",
} do

  if data.raw["item-with-entity-data"][vehicleName] then
    data.raw["item-with-entity-data"][vehicleName].subgroup = "manual-buildable-vehicles"
    data.raw["item-with-entity-data"][vehicleName].order = "b"
  end
end







data:extend{
  transportLogistics,
  transportRailway,
  trainassemblerFuel,
  manualBuildVehicles,
  trainpartsFluid,
}
