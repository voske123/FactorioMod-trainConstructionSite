local tooltipCategoryColor = { r = 255, g = 210, b = 73 }
local tooltipParameterColor = { r = 255, g = 230, b = 192 }

local convertEnergyStringToValue = function(str)
  local powers = {
    ['0'] = 1, ['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1,
    ['5'] = 1, ['6'] = 1, ['7'] = 1, ['8'] = 1, ['9'] = 1,
    ['k'] = 1000,
    ['M'] = 1000000,
    ['G'] = 1000000000
  }

  while not powers[string.sub(str, -1,-1)] do
    str = string.sub(str, 1, -2) -- maybe use this to convert J to W?
  end

  if powers[string.sub(str, -1,-1)] > 1 then
    str = tonumber(string.sub(str, 1, -2)) * powers[string.sub(str, -1,-1)]
  else
    str = tonumber(str)
  end
  return str
end

local createTooltipCategory = function(spriteName, categoryName, categoryAdditionalLocalisation, addLeadingNewLine)
  local tooltipCategory = {""}

  if addLeadingNewLine then
    table.insert(tooltipCategory, "\n")
  end

  table.insert(tooltipCategory, string.format("[font=default-bold][color=%i,%i,%i]",
    tooltipCategoryColor.r, tooltipCategoryColor.g, tooltipCategoryColor.b))
  table.insert(tooltipCategory, string.format("[img=%s] ", spriteName))
  table.insert(tooltipCategory, {string.format("tooltip-category.%s", categoryName)})
  if categoryAdditionalLocalisation then
    table.insert(tooltipCategory, categoryAdditionalLocalisation)
  end
  table.insert(tooltipCategory, "[/color][/font]")

  return tooltipCategory
end

local createTooltipParameter = function(parameterName, localisedParameterValue, addLeadingNewLine)
  local tooltipParameter = {""}

  if addLeadingNewLine then
    table.insert(tooltipParameter, "\n")
  end

  table.insert(tooltipParameter, string.format("[font=default-semibold][color=%i,%i,%i]",
  tooltipParameterColor.r, tooltipParameterColor.g, tooltipParameterColor.b))
  table.insert(tooltipParameter, {string.format("description.%s", parameterName)})
  table.insert(tooltipParameter, {"", {"colon"}, " "})
  table.insert(tooltipParameter, "[/color][/font]")
  table.insert(tooltipParameter, localisedParameterValue)

  return tooltipParameter
end

local createStorageLocalisedDescription = function(trainType, trainName, addLeadingNewLine)
  if not data.raw[trainType] then return {""} end
  local entityPrototype = data.raw[trainType][trainName]
  if not entityPrototype then return {""} end

  local localised_description = {""}

  if trainType == "cargo-wagon" then
    table.insert(localised_description, createTooltipParameter("storage-size", LSlib.utils.units.getLocalisedUnit(entityPrototype.inventory_size, {""}), nil, addLeadingNewLine))
  elseif trainType == "fluid-wagon" then
    table.insert(localised_description, createTooltipParameter("fluid-capacity", LSlib.utils.units.getLocalisedUnit(entityPrototype.capacity, {""}), nil, addLeadingNewLine))
  end

  return localised_description
end

local createEquipmentLocalisedDescription = function(trainType, trainName, addLeadingNewLine)
  if not data.raw[trainType] then return {""} end
  local entityPrototype = data.raw[trainType][trainName]
  if not entityPrototype then return {""} end

  local equipmentGrid = entityPrototype.equipment_grid
  if not equipmentGrid then return {""} end
  equipmentGrid = data.raw["equipment-grid"][equipmentGrid]
  if not equipmentGrid then return {""} end

  local localised_description = {""}
  table.insert(localised_description, createTooltipCategory("tooltip-category-equipment-grid", "equipment-grid", nil, addLeadingNewLine))
  table.insert(localised_description, createTooltipParameter("grid-size", {"description.creates-number-entities-value", string.format("%i", equipmentGrid.width), string.format("%i", equipmentGrid.height)}, true))
  table.insert(localised_description, createTooltipParameter("accepted-equipment", "\n", true))

  local equipment = {}
  for _, equipmentCategory in pairs(equipmentGrid.equipment_categories) do
    for _, equipmentType in pairs{
      "night-vision-equipment", "belt-immunity-equipment", "roboport-equipment",
      "solar-panel-equipment", "generator-equipment", "battery-equipment",
      "active-defense-equipment", "energy-shield-equipment", "movement-bonus-equipment",
    } do
      for _, equipmentPrototype in pairs(data.raw[equipmentType]) do
        local containsCategory = false
        for _, equipmentPrototypeCategory in pairs(equipmentPrototype.categories) do
          if equipmentPrototypeCategory == equipmentCategory then
            containsCategory = true
          end
        end
        if containsCategory then
          equipment[equipmentType] = equipment[equipmentType] or {}
          equipment[equipmentType][equipmentPrototype.name] = equipmentPrototype.take_result or equipmentPrototype.name
        end
      end
    end
  end
  local items = {}
  local itemsCount = 0
  for equipmentType, equipmentTypeData in pairs(equipment) do
    for equipmentName, itemName in pairs(equipmentTypeData) do
      local item = data.raw["item"][itemName]
      if item then
        local itemSubgroup =  data.raw["item-subgroup"][item.subgroup or ""] or {}
        local itemGroup = data.raw["item-group"][itemSubgroup.group or ""] or {}
        local orderString = string.format("%s-%s-%s", itemGroup.order or "z", itemSubgroup.order or "z", item.order or "z")
        if items[orderString] then
          local orderIndex = 1
          while items[string.format("%s-%i", orderString, orderIndex)] do
            orderIndex = orderIndex + 1
          end
          orderString = string.format("%s-%i", orderString, orderIndex)
        end
        items[orderString] = itemName
        itemsCount = itemsCount + 1
      end
    end
  end
  local localised_items = {""}
  local localised_itemsRow = {""}
  local localised_itemsCount = 0
  table.insert(localised_itemsRow, "[font=default-game][color=#00000000]")
  for _,itemName in pairs(items) do
    table.insert(localised_itemsRow, string.format(" [img=item/%s]", itemName))
    localised_itemsCount = localised_itemsCount + 1
    if localised_itemsCount % 10 == 0 or localised_itemsCount == itemsCount then
      if localised_itemsCount == itemsCount then
        table.insert(localised_itemsRow, "[/color][/font]")
      end
      table.insert(localised_items, util.table.deepcopy(localised_itemsRow))
      localised_itemsRow = {"", "[font=default-tiny-bold]\n \n[/font]"}
    end
  end
  table.insert(localised_description, localised_items)
  table.insert(localised_description, "[font=default-tiny-bold]\n[/font]")

  return localised_description
end

local createVehicleLocalisedDescription = function(trainType, trainName, addLeadingNewLine)
  if not data.raw[trainType] then return {""} end
  local entityPrototype = data.raw[trainType][trainName]
  if not entityPrototype then return {""} end

  local localised_description = {""}

  table.insert(localised_description, createTooltipCategory("tooltip-category-vehicle", "vehicle", nil, addLeadingNewLine))
  if trainType == "locomotive" then
    table.insert(localised_description, createTooltipParameter("max-speed", {"", string.format("%.0f", entityPrototype.max_speed * 259/1.2), {"si-unit-kilometer-per-hour"}}, true))
    table.insert(localised_description, createTooltipParameter("acceleration-power", LSlib.utils.units.getLocalisedUnit(convertEnergyStringToValue(entityPrototype.max_power), {"si-unit-symbol-watt"}, 2), true))
  end
  table.insert(localised_description, createTooltipParameter("weight", {"", string.format("%i", entityPrototype.weight)}, true))

  return localised_description
end

local createEnergySourceLocalisedDescription = function(trainType, trainName, addLeadingNewLine)
  if not data.raw[trainType] then return {""} end
  local entityPrototype = data.raw[trainType][trainName]
  if not entityPrototype then return {""} end

  local localised_description = {""}

  if entityPrototype.burner or (entityPrototype.energy_source and entityPrototype.energy_source.type == "burner") then
    local containsCategory = function(categoryName)
      if entityPrototype.burner.fuel_category then
        return entityPrototype.burner.fuel_category == categoryName
      end
      if entityPrototype.burner.fuel_categories then
        for _,category in pairs(entityPrototype.burner.fuel_categories) do
          if category == categoryName then return true end
        end
      end
      return false
    end
    if containsCategory("chemical") then
      table.insert(localised_description, createTooltipCategory("tooltip-category-chemical", "consumes", {"", " ", {"fuel-category-name.chemical"}}, addLeadingNewLine))
    elseif containsCategory("nuclear") then
      table.insert(localised_description, createTooltipCategory("tooltip-category-nuclear", "consumes", {"", " ", {"fuel-category-name.nuclear"}}, addLeadingNewLine))
    else
      table.insert(localised_description, createTooltipCategory("tooltip-category-consumes", "consumes", {"", " ", {string.format("fuel-category-name.%s", entityPrototype.burner.fuel_category or (entityPrototype.burner.fuel_categories and next(entityPrototype.burner.fuel_categories)) or "TCS-none")}}, addLeadingNewLine))
    end
    table.insert(localised_description, createTooltipParameter("max-energy-consumption", LSlib.utils.units.getLocalisedUnit(convertEnergyStringToValue(entityPrototype.max_power), {"si-unit-symbol-watt"}, 2), true))

  elseif entityPrototype.energy_source and entityPrototype.energy_source.type == "electric" then
    table.insert(localised_description, createTooltipCategory("tooltip-category-electricity", "consumes", {"", " ", {"tooltip-category.electricity"}}, addLeadingNewLine))
    table.insert(localised_description, createTooltipParameter("max-energy-consumption", LSlib.utils.units.getLocalisedUnit(convertEnergyStringToValue(entityPrototype.max_power), {"si-unit-symbol-watt"}, 2), true))
  end

  return localised_description
end

local createTrainLocalisedDescription = function(trainType, trainName, addLeadingNewLine)
  local localised_description = {""}
  local requireNewLine = addLeadingNewLine

  -- inventory size
  if trainType == "cargo-wagon" or trainType == "fluid-wagon" then
    table.insert(localised_description, createStorageLocalisedDescription(trainType, trainName, requireNewLine))
    requireNewLine = true
  end
  -- equipment grid
  if data.raw[trainType] and data.raw[trainType][trainName] and data.raw[trainType][trainName].equipment_grid then
    table.insert(localised_description, createEquipmentLocalisedDescription(trainType, trainName, requireNewLine))
    requireNewLine = true
  end
  -- vehicle stats
  table.insert(localised_description, createVehicleLocalisedDescription(trainType, trainName, requireNewLine))
  requireNewLine = true
  -- energy source
  if trainType == "locomotive" then
    table.insert(localised_description, createEnergySourceLocalisedDescription(trainType, trainName, requireNewLine))
    requireNewLine = true
  end

  return localised_description
end

return {
  createTrainLocalisedDescription = createTrainLocalisedDescription
}
