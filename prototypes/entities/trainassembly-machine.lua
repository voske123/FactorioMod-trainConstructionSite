require "util"

local trainassembly = util.table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
trainassembly.name = "trainassembly-machine"

trainassembly.minable.result = "trainassembly" -- name of the item

-- copy localisation from the item
trainassembly.localised_name = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].localised_name)
trainassembly.localised_description = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].localised_description)

-- copy the icon over from the item
trainassembly.icon = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icon)
trainassembly.icons = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icons)
trainassembly.icon_size = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icon_size)

-- define the order since this entity doesn't have a dedicated item
trainassembly.order = data.raw["item"][trainassembly.minable.result].order

-- selection box
trainassembly.selection_box = {{-3, -3}, {3, 3}}

-- collision mask & box
trainassembly.collision_mask = util.table.deepcopy(data.raw["locomotive"]["trainassembly-placeable"].collision_mask)
trainassembly.collision_box = {{-3, -3}, {3, 3}}

-- delete train-layer so it doesn't collide with trains
for collisionIndex, collisionLayer in pairs(trainassembly.collision_mask) do
  if collisionLayer == "train-layer" then
    trainassembly.collision_mask[collisionIndex] = nil
  end
end

trainassembly.fast_replaceable_group = nil

trainassembly.fluid_boxes = nil

trainassembly.max_health = data.raw["locomotive"]["trainassembly-placeable"].max_health



data:extend({
  trainassembly,
})
