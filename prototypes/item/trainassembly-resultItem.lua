
for _, trainType in pairs({
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
}) do

  for _, trainEntity in pairs(data.raw[trainType]) do

    if trainEntity.minable and trainEntity.minable.result then

      local item = data.raw["item-with-entity-data"][trainEntity.minable.result]

      data.raw[trainType][item.place_result].order = item.order
      item.place_result =  nil

    end
  end
end
