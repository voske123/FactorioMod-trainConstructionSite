
local trainsToIgnore = require("prototypes/modded-trains-to-ignore")
local itemOverride   = require("prototypes/modded-trains-item-override")

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
        -- Now that we have the item name, we create the fluid
        local itemFluid = util.table.deepcopy(data.raw["fluid"]["crude-oil"])
        itemFluid.auto_barrel = false -- We don't want to end up with barreling recipes


        itemFluid.name            = itemName .. "-fluid"
        itemFluid.localised_name  = {"item-name.localisedEntity", trainEntity.name}
        itemFluid.icon            = item.icon
        itemFluid.icon_size       = item.icon_size
        itemFluid.icons           = util.table.deepcopy(item.icons)

        itemFluid.order           = item.order
        itemFluid.subgroup        = "trainparts-fluid"

        data:extend{
          itemFluid,
        }
      end
    end
  end
end
