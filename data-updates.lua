
require "prototypes.recipe.trainassembly-trainPlacing-updates"

require "prototypes.entity.trainassembly-placeable-updates"

require "prototypes.technology.trainassembly-trainPlacing-updates"

-- Other mod items related to trains to be sorted

if mods["concreted-rails"] then
  data.raw["rail-planner"]["concrete-rail"].subgroup = data.raw["rail-planner"]["rail"].subgroup
  data.raw["rail-planner"]["concrete-rail"].order    = "a[rai]-b[concreted-rails]"
end

if mods["FuelTrainStop"] then
  data.raw["item"]["fuel-train-stop"].subgroup = data.raw["item"]["train-stop"].subgroup
  data.raw["item"]["fuel-train-stop"].order    = "b[stop]-c[FuelTrainStop]"
end

if mods["Armored-train"] then
  for _,itemName in pairs{ -- turret ingredients
    "platform-minigun-turret-mk1",
    "wagon-cannon-turret-mk1"    ,
    "platform-rocket-turret-mk1" ,
  } do
    data.raw["item"][itemName].subgroup = data.raw["item"]["gun-turret"].subgroup
    data.raw["item"][itemName].order    = "b[turret]-a[gun-turret]-h[Armored-train]-"..data.raw["item"][itemName].order
  end
end

if mods["FARL"] then
  data.raw["item"]["farl-roboport"].subgroup = data.raw["item-with-entity-data"]["locomotive-manual-build"].subgroup
  data.raw["item"]["farl-roboport"].order    = "a[railway]-b[FARL]"
end