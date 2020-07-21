
local trainsToIgnore = require("prototypes/modded-trains-to-ignore")
local itemOverride   = require("prototypes/modded-trains-item-override")
local functions      = require("prototypes/functions")

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
      local fluid = data.raw["fluid"][itemName .. "-fluid"]
      if fluid then
        -- Now that we have the item name, we add a localised_name
        fluid.localised_description = functions.createTrainLocalisedDescription(trainEntity.type, trainEntity.name)
      end
    end
  end
end
