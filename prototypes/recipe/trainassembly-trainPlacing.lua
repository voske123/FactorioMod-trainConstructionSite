
-- For each train-like entity we want to create a recipe so we can put this in
-- our trainbuilding to make an actual train on the tracks. To get the fluidname
-- we require the itemname. To aquire the itemname we get the entity.minable.result.
-- For this we start to iterate over all tine train types
for _, trainType in pairs({
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
}) do
  -- For each type, we get all the different entities (ex: locomotive mk1, mk2, ...)
  for _, trainEntity in pairs(data.raw[trainType]) do
    -- For each entity, we get the item name. The item name is stored in minable.result
    if trainEntity.minable and trainEntity.minable.result then

      local itemName = trainEntity.minable.result

      -- now that we have the itemname we can create the fluid recipe.
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

      -- Now we created recipes only requiring the item. If this is a locomotive
      -- we will also require fuel to start the engine.
      if trainType == "locomotive" then
        -- This is a locomotive, add another ingredient to the list for fuel
        table.insert(data.raw["recipe"][itemName .. "-fluid"].normal.ingredients, {"trainassembly-recipefuel", 1})
      end

    end
  end
end
