-- Other mod items related to trains to be sorted
require "prototypes/modded-updates-trainfuel"
local otherVehicleGroup = "manual-buildable-vehicles"

if mods["concreted-rails"] then
  LSlib.item.setSubgroup("rail-planner", "concrete-rail", LSlib.item.getSubgroup("rail-planner", "rail"))
  LSlib.item.setOrderstring("rail-planner", "concrete-rail", "a[rai]-b[concreted-rails]")
end

if mods["FuelTrainStop"] then
  LSlib.item.setSubgroup("item", "fuel-train-stop", LSlib.item.getSubgroup("item", "train-stop"))
  LSlib.item.setOrderstring("item", "fuel-train-stop", "b[stop]-c[FuelTrainStop]")
end

if mods["Armored-train"] then
  for _,itemName in pairs{ -- turret ingredients
    "platform-minigun-turret-mk1",
    "wagon-cannon-turret-mk1"    ,
    "platform-rocket-turret-mk1" ,
  } do
    LSlib.item.setSubgroup("item", itemName, LSlib.item.getSubgroup("item", "gun-turret"))
    LSlib.item.setOrderstring("item", itemName, "b[turret]-a[gun-turret]-h[Armored-train]-"..LSlib.item.getSubgroup("item", itemName))
  end
end

if mods["FARL"] then
  LSlib.item.setSubgroup("item", "farl-roboport", otherVehicleGroup)
  LSlib.item.setOrderstring("item", "farl-roboport", "a[railway]-b[FARL]")
end

if mods["SmartTrains"] then
  LSlib.item.setSubgroup("item", "smart-train-stop", LSlib.item.getSubgroup("item", "train-stop"))
  LSlib.item.setOrderstring("item", "smart-train-stop", "b[stop]-d[SmartTrains]")
end

if mods["RailPowerSystem"] then
  LSlib.item.setSubgroup("rail-planner", "electric-rail", LSlib.item.getSubgroup("rail-planner", "rail"))
  LSlib.item.setSubgroup("item", "prototype-connector"  , LSlib.item.getSubgroup("rail-planner", "rail"))
  LSlib.item.setOrderstring("rail-planner", "electric-rail", "a[rai]-c[RailPowerSystem]-a[rail]")
  LSlib.item.setOrderstring("item", "prototype-connector"  , "a[rai]-c[RailPowerSystem]-b[pole]")
end

if mods["assembler-pipe-passthrough"] then
  if appmod and appmod.blacklist then
    appmod.blacklist["trainassembly-machine"] = true
  end
end

if mods["boblogistics"] then
  if settings.startup["bobmods-logistics-inserteroverhaul"].value == true then
    -- recipe utilizing express inserters -> move over to fast inserter instead
    LSlib.recipe.editIngredient("trainassembly", "fast-inserter", "long-handed-inserter")
  end
end

if mods["bobwarfare"] then
  LSlib.item.setSubgroup("item-with-entity-data", "bob-tank-2", otherVehicleGroup)
  LSlib.item.setSubgroup("item-with-entity-data", "bob-tank-3", otherVehicleGroup)
end