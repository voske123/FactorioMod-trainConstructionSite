require "util"

local trainassembly = util.table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
trainassembly.name = "trainassembly-machine"

trainassembly.minable.result = "trainassembly"

-- copy localisation from the item
trainassembly.localised_name = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].localised_name)
trainassembly.localised_description = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].localised_description)

-- copy the icon over from the item
trainassembly.icon = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icon)
trainassembly.icons = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icons)
trainassembly.icon_size = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icon_size)

-- selection box
trainassembly.selection_box = {{-3, -3}, {3, 3}}

-- collision_mask
trainassembly.collision_mask = util.table.deepcopy(data.raw["locomotive"]["trainassembly-placeable"].collision_mask)

for collisionIndex, collisionLayer in pairs(trainassembly.collision_mask) do
  if collisionLayer == "train-layer" then
    trainassembly.collision_mask[collisionIndex] = nil
  end
end

trainassembly.collision_box = {{-3, -3}, {3, 3}}

trainassembly.fast_replaceable_group = nil

trainassembly.fluid_boxes = nil

trainassembly.max_health = data.raw["locomotive"]["trainassembly-placeable"].max_health



data:extend({
  trainassembly,
})
