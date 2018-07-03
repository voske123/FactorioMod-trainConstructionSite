require "util"

local trainassemblyItemTable {}

for _, trainType in pairs({
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
}) do

  for _, trainEntity in pairs(data.raw[trainType]) do

    if trainEntity.minable and trainEntity.minable.result then
      table.insert(trainassemblyItemTable, {
        "itemName" = trainEntity.minable.result,
        "entityType" = trainType,
      })

    end
  end
end

for _, trainItem in pairs(trainassemblyItemTable) do

  local item = data.raw["item-with-entity-data"][trainType.itemName]

  data.raw[trainEntity.entityType][item.place_result].order = item.order
  item.place_result =  nil

end
