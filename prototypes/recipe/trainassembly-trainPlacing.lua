

for _, trainType in pairs({
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
}) do
  for _, trainEntity in pairs(data.raw[trainType]) do
    if trainEntity.minable and trainEntity.minable.result then

      local itemName = trainEntity.minable.result

      data:extend({
        {
          type = "recipe",
          name = itemName .. "-fluid",
          category = "trainassembling",
          expensive = nil,
          normal =
          {
            enabled = false,
            energy_required = 15,
            ingredients =
            {
              {itemName, 1},
            },
            results =
            {
              {
                type    = "fluid",
                name    = itemName .. "-fluid",
                amount  = 1,
              },
            },
          },
        }
      })

      if trainType == "locomotive" then

        table.insert(data.raw["recipe"][itemName .. "-fluid"].normal.ingredients, {"trainassembly-recipefuel", 1})
      end

      end
  end
end
