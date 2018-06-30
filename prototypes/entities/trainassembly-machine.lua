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

-- make sure you can't blueprint it, becose you can't let robots place trains anyway
table.insert(trainassembly.flags, "not-blueprintable")

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

trainassembly.fluid_boxes = -- give it an output pipe so it has a direction
{
  off_when_no_fluid_recipe = false, -- makes sure it is showing the arrow
  {
    production_type = "output",
    pipe_picture = nil,
    pipe_covers = nil,
    base_area = 10,
    base_level = 1,
    pipe_connections = {{ type="output", position = {0, -3.5} }}, -- output on the north side
    --secondary_draw_orders = { north = -1 }
  },
}
-- NOTE: This output is always on a train track, so no worries that a pipe
--       would empty the fluid that is comming out of this.

trainassembly.max_health = data.raw["locomotive"]["trainassembly-placeable"].max_health



data:extend({
  trainassembly,
})
