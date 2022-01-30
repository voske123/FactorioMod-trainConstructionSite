
local trainsToIgnore = require("prototypes/modded-trains-to-ignore")
local itemOverride   = require("prototypes/modded-trains-item-override")
--local functions      = require("prototypes/functions")

-- For each train type like item we want to make an equal fluid
-- To accuire all the itemnames, we have to iterate over the entities
-- becose those have different types as the items are all type = "item".
for _,trainType in pairs({
    "locomotive"     ,
    "cargo-wagon"    ,
    "fluid-wagon"    ,
    "artillery-wagon",
}) do
  -- For each type, we get all the different entities (ex: locomotive mk1, mk2, ...)
  for _,trainEntity in pairs(data.raw[trainType]) do
    -- For each entity, we get the item name. The item name is stored in minable.result
    if (not trainsToIgnore[trainType][trainEntity.name]) and trainEntity.minable and trainEntity.minable.result then
      local itemName = itemOverride[trainType][trainEntity.name] or trainEntity.minable.result
      local item = data.raw["item-with-entity-data"][itemName] or data.raw["item"][itemName]
      if item then
        -- Now that we have the item name, we can update the icon
        local item_icons = {
          {
            icon      = "__base__/graphics/icons/wooden-chest.png",
            --icon      = "__trainConstructionSite__/graphics/item/trainparts/trainparts-chest.png",
            icon_size = 64,
            tint      = {r = 0.75, g = 0.75, b = 0.75}
          }
        }

        local train_layers = LSlib.item.getIcons(item.type, item.name, 32/(LSlib.item.getIconSize(item.type, item.name)[1] or 32) * 0.65)
        for _, train_layer in pairs(train_layers) do
          table.insert(item_icons, train_layer)
        end

        item.icon       = nil
        item.icon_scale = nil
        item.icons      = item_icons
      end
    end
  end
end
