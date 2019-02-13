
-- We have fluids to craft to make the train on a track. With this in mind, we
-- don't want the player to place down the train manualy. We have to remove the
-- place_result on the entity.

-- For each train type like item we want to change the place_result
-- To accuire all the itemnames, we have to iterate over the entities
-- becose those have different types as the items are all type = "item".
for _, trainType in pairs{
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
} do
  -- For each type, we get all the different entities (ex: locomotive mk1, mk2, ...)
  for _, trainEntity in pairs(data.raw[trainType]) do
    -- For each entity, we get the item name. The item name is stored in minable.result
    if trainEntity.minable and trainEntity.minable.result then

      -- Now that we have the item, we can remove the place_result. When we remove
      -- the place_result, the entity will be delinked from the item. This means
      -- the entity will not have an order defined. To solve this issue we copy
      -- the order string over from the item to the entity.
      local item = data.raw["item-with-entity-data"][trainEntity.minable.result]
      data.raw[trainType][item.place_result].order = item.order

      -- And finaly remove the place_result.
      item.place_result =  nil

      item.localised_name = {"item-name.trainparts", trainEntity.name}


    end
  end
end
