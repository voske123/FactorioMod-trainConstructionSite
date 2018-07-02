require "util"

local trainassemblyItemTable = {}

for _, trainType in pairs({
    "locomotive",
    "cargo-wagon",
    "fluid-wagon",
    "artillery-wagon",
}) do

  for _,trainEntity in pairs(data.raw[trainType]) do

    if trainEntity.minable and trainEntity.minable.result then
        local itemName = trainEntity.minable.result

        table.insert(trainassemblyItemTable, itemName)
    end
  end
end

for _, itemName in pairs(trainassemblyItemTable) do

  local itemFluid = util.table.deepcopy(data.raw["fluid"]["crude-oil"])

  itemFluid.name        = itemName .. "-fluid"
  itemFluid.icon        = data.raw["item-with-entity-data"][itemName].icon
  itemFluid.icon_size   = data.raw["item-with-entity-data"][itemName].icon_size
  itemFluid.icons       = util.table.deepcopy(data.raw["item-with-entity-data"][itemName].icons)
  itemFluid.order       = data.raw["item-with-entity-data"][itemName].order
  itemFluid.auto_barrel = false
  itemFluid.subgroup    = "transport-trains"

  data:extend({
    itemFluid,
  })

end
