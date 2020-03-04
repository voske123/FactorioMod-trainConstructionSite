
local locomotiveManualBuild = util.table.deepcopy(data.raw["item-with-entity-data"]["locomotive"])

locomotiveManualBuild.name = "locomotive-manual-build"
locomotiveManualBuild.subgroup = "manual-buildable-vehicles"
locomotiveManualBuild.order = "a[railway]-a[vanilla]"


-- We have fluids to craft to make the train on a track. With this in mind, we
-- don't want the player to place down the train manualy. We have to remove the
-- place_result on the entity.

local trainsToIgnore = require("prototypes/modded-trains-to-ignore")
local itemOrder      = require("prototypes/modded-trains-ordening")
local itemOverride   = require("prototypes/modded-trains-item-override")
local itemPlaceResult = {}

-- For each train type like item we want to change the place_result
-- To accuire all the itemnames, we have to iterate over the entities
-- because those have different types as the items are all type = "item".
for _, trainType in pairs{
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
} do
  -- For each type, we get all the different entities (ex: locomotive mk1, mk2, ...)
  for _, trainEntity in pairs(data.raw[trainType]) do
    -- For each entity, we get the item name. The item name is stored in minable.result
    if (not trainsToIgnore[trainType][trainEntity.name]) and trainEntity.minable and trainEntity.minable.result then

      -- Now that we have the item, we can remove the place_result. When we remove
      -- the place_result, the entity will be delinked from the item. This means
      -- the entity will not have an order defined. To solve this issue we copy
      -- the order string over from the item to the entity.
      local itemName = itemOverride[trainType][trainEntity.name] or trainEntity.minable.result
      local item = data.raw["item-with-entity-data"][itemName] or data.raw["item"][itemName]

      if item and data.raw[trainType][item.place_result] then
        log(string.format("Creating train parts: %s (%s)", trainEntity.name, trainType))
        data.raw[trainType][item.place_result].order = item.order

        item.localised_name = item.localised_name and {"item-name.trainparts", item.localised_name} or {"item-name.trainparts", "__ENTITY__"..trainEntity.name.."__"}
        item.subgroup       = "transport"
        item.order          = (itemOrder[trainType][item.name] and itemOrder[trainType][item.name].."-" or "") .. item.order

        -- Add item to remove the place_result.
        if not itemPlaceResult[item.type] then itemPlaceResult[item.type] = {} end
        itemPlaceResult[item.type][item.name] = (settings.startup["trainController-manual-placing-trains"].value == false)
        trainEntity.fast_upgrade_group = nil
        trainEntity.next_upgrade = nil

      else
        log(string.format("Error creating train parts: %s (%s)", trainEntity.name, trainType))
      end
    end
  end
end

-- Now we can remove all place_results
for itemType, itemNames in pairs(itemPlaceResult) do
  for itemName, removePlaceResult in pairs(itemNames) do
    if removePlaceResult then
      data.raw[itemType][itemName].place_result =  nil
    end
  end
end

if settings.startup["trainController-manual-placing-trains"].value == false then
  data:extend{
    locomotiveManualBuild,
  }
end
