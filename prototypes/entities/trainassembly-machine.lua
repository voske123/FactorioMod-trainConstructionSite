require "util"

local trainassembly = util.table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
trainassembly.name = "trainassembly-machine"

-- adjusting minable time/hardness/result and pipette tool
trainassembly.minable.mining_time = 5
trainassembly.minable.hardness = 0.5
trainassembly.minable.result = "trainassembly" -- name of the item
trainassembly.placeable_by = {item=trainassembly.minable.result, count= 1}

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
trainassembly.collision_box = {{-2.95, -2.95}, {2.95, 2.95}}

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

trainassembly.crafting_categories = {"trainassembling",}
trainassembly.crafting_speed = 0.20
trainassembly.energy_usage = "500kW"
trainassembly.module_specification.module_slots = 5
trainassembly.allowed_effects = {"consumption",}
trainassembly.scale_entity_info_icon = true

-- 4 way animation
trainassembly.animation =
{
  north =
  {
    layers =
    {
      {
        filename = "__trainConstructionSite__/graphics/placeholders/6x6.png",
        priority = "high",
        width = 256,
        height = 256,
        frame_count = 1,
        line_length = 1,
        --shift = util.by_pixel(0, 4),
        hr_version = nil,
      },
      {
        filename = "__trainConstructionSite__/graphics/placeholders/direction_north.png",
        width = 82,
        height = 82,
        frame_count = 1,
        line_length = 1,
        shift = util.by_pixel(0, -32*1.25),
        hr_version = nil,
      },
    },
  },
  east =
  {
    layers =
    {
      {
        filename = "__trainConstructionSite__/graphics/placeholders/6x6.png",
        priority = "high",
        width = 256,
        height = 256,
        frame_count = 1,
        line_length = 1,
        --shift = util.by_pixel(0, 4),
        hr_version = nil,
      },
      {
        filename = "__trainConstructionSite__/graphics/placeholders/direction_east.png",
        width = 82,
        height = 82,
        frame_count = 1,
        line_length = 1,
        shift = util.by_pixel(0, -32*1.25),
        hr_version = nil,
      },
    },
  },
  south =
  {
    layers =
    {
      {
        filename = "__trainConstructionSite__/graphics/placeholders/6x6.png",
        priority = "high",
        width = 256,
        height = 256,
        frame_count = 1,
        line_length = 1,
        --shift = util.by_pixel(0, 4),
        hr_version = nil,
      },
      {
        filename = "__trainConstructionSite__/graphics/placeholders/direction_south.png",
        width = 82,
        height = 82,
        frame_count = 1,
        line_length = 1,
        shift = util.by_pixel(0, -32*1.25),
        hr_version = nil,
      },
    },
  },
  west =
  {
    layers =
    {
      {
        filename = "__trainConstructionSite__/graphics/placeholders/6x6.png",
        priority = "high",
        width = 256,
        height = 256,
        frame_count = 1,
        line_length = 1,
        --shift = util.by_pixel(0, 4),
        hr_version = nil,
      },
      {
        filename = "__trainConstructionSite__/graphics/placeholders/direction_west.png",
        width = 82,
        height = 82,
        frame_count = 1,
        line_length = 1,
        shift = util.by_pixel(0, -32*1.25),
        hr_version = nil,
      },
    },
  },
}



data:extend{
  trainassembly,
}
