-- Other mod items related to trains to be sorted
require "prototypes/modded-updates-trainfuel"
local otherVehicleGroup = "manual-buildable-vehicles"

if mods["concreted-rails"] then
  LSlib.item.setSubgroup("rail-planner", "concrete-rail", LSlib.item.getSubgroup("rail-planner", "rail"))
  LSlib.item.setOrderstring("rail-planner", "concrete-rail", "a[rail]-b[concreted-rails]")
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
  LSlib.item.setOrderstring("rail-planner", "electric-rail", "a[rail]-c[RailPowerSystem]-a[rail]")
  LSlib.item.setOrderstring("item", "prototype-connector"  , "a[rail]-c[RailPowerSystem]-b[pole]")
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

if mods["bobwarfare"] and (not mods["angelsindustries"]) then
  LSlib.item.setSubgroup("item-with-entity-data", "bob-tank-2", otherVehicleGroup)
  LSlib.item.setSubgroup("item-with-entity-data", "bob-tank-3", otherVehicleGroup)
end

if mods["FactorioExtended-Plus-Transport"] then
  LSlib.item.setSubgroup("item-with-entity-data", "car-mk2", otherVehicleGroup)
  LSlib.item.setSubgroup("item-with-entity-data", "car-mk3", otherVehicleGroup)
  LSlib.item.setSubgroup("item-with-entity-data", "tank-mk2", otherVehicleGroup)
  LSlib.item.setSubgroup("item-with-entity-data", "tank-mk3", otherVehicleGroup)
  LSlib.item.setOrderstring("item-with-entity-data", "car", "b-aa")
  LSlib.item.setOrderstring("item-with-entity-data", "car-mk2", "b-ab")
  LSlib.item.setOrderstring("item-with-entity-data", "car-mk3", "b-ac")
  LSlib.item.setOrderstring("item-with-entity-data", "tank", "b-ba")
  LSlib.item.setOrderstring("item-with-entity-data", "tank-mk2", "b-bb")
  LSlib.item.setOrderstring("item-with-entity-data", "tank-mk3", "b-bc")
end

if mods["Krastorio2"] then
  LSlib.item.setSubgroup("item-with-entity-data", "kr-advanced-tank", otherVehicleGroup)
  LSlib.item.setOrderstring("item-with-entity-data", "kr-advanced-tank", "c")
end

if mods["LogisticTrainNetwork"] then
  LSlib.item.setSubgroup("item", "logistic-train-stop", "transport-railway")
  LSlib.item.setOrderstring("item", "logistic-train-stop", "b[stop]-c[LTN]")
end

if mods["Hovercrafts"] then
  local hovercraftVehicleGroup = "hovercrafts"
  LSlib.item.setSubgroup("item-with-entity-data", "hcraft-item", hovercraftVehicleGroup)
  LSlib.item.setSubgroup("item-with-entity-data", "hcraft-entity", hovercraftVehicleGroup)
  LSlib.item.setOrderstring("item-with-entity-data", "hcraft-item", "y[hover]-a[regular]")
  LSlib.item.setOrderstring("item-with-entity-data", "hcraft-entity", "y[hover]-a[regular]")

  LSlib.item.setSubgroup("item-with-entity-data", "mcraft-item", hovercraftVehicleGroup)
  LSlib.item.setSubgroup("item-with-entity-data", "mcraft-entity", hovercraftVehicleGroup)
  LSlib.item.setOrderstring("item-with-entity-data", "mcraft-item", "y[hover]-b[missile]")
  LSlib.item.setOrderstring("item-with-entity-data", "mcraft-entity", "y[hover]-b[missile]")

  if data.raw["item-with-entity-data"]["ecraft-entity"] then
    LSlib.item.setSubgroup("item-with-entity-data", "ecraft-item", hovercraftVehicleGroup)
    LSlib.item.setSubgroup("item-with-entity-data", "ecraft-entity", hovercraftVehicleGroup)
    LSlib.item.setOrderstring("item-with-entity-data", "ecraft-item", "y[hover]-c[electric]")
    LSlib.item.setOrderstring("item-with-entity-data", "ecraft-entity", "y[hover]-c[electric]")
  end

  if data.raw["item-with-entity-data"]["lcraft-entity"] then
    LSlib.item.setSubgroup("item-with-entity-data", "lcraft-item", hovercraftVehicleGroup)
    LSlib.item.setSubgroup("item-with-entity-data", "lcraft-entity", hovercraftVehicleGroup)
    LSlib.item.setOrderstring("item-with-entity-data", "lcraft-item", "y[hover]-d[laser]")
    LSlib.item.setOrderstring("item-with-entity-data", "lcraft-entity", "y[hover]-d[laser]")
  end
end

if mods["laser_tanks"] then
  LSlib.item.setSubgroup("item-with-entity-data", "lasercar", otherVehicleGroup)
  LSlib.item.setOrderstring("item-with-entity-data", "car", "b-aa")
  LSlib.item.setOrderstring("item-with-entity-data", "lasercar", "b-ad")

  LSlib.item.setSubgroup("item-with-entity-data", "lasertank", otherVehicleGroup)
  LSlib.item.setOrderstring("item-with-entity-data", "tank", "b-ba")
  LSlib.item.setOrderstring("item-with-entity-data", "lasertank", "b-bd")
end

if mods["Transport_Drones"] then
  data.raw["item-subgroup"]["transport-drones"].group = "transport-logistics"
  data.raw["item-subgroup"]["transport-drones"].order = "aa"
end

if mods["aai-programmable-vehicles"] then
  data.raw["item-subgroup"]["programmable-structures"].group = "transport-logistics"
  data.raw["item-subgroup"]["programmable-structures"].order = "ab"

  data.raw["item-subgroup"]["ai-vehicles"].group = "transport-logistics"
  data.raw["item-subgroup"]["ai-vehicles"].order = "cc-a"
  
  data.raw["item-subgroup"]["ai-vehicles-reverse"].group = "transport-logistics"
  data.raw["item-subgroup"]["ai-vehicles-reverse"].order = "cc-b"
end