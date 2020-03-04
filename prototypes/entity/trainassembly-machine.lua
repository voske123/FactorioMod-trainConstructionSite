
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

--delete train-layer so it doesn't collide with trains
for collisionIndex, collisionLayer in pairs(trainassembly.collision_mask) do
  if collisionLayer == "train-layer" then
    table.remove(trainassembly.collision_mask, collisionIndex)
  end
end

trainassembly.fast_replaceable_group = nil
trainassembly.next_upgrade = nil

trainassembly.fluid_boxes = -- give it an output pipe so it has a direction
{
  { -- NOTE: This output is always on a train track, so no worries that a pipe
    --       would empty the fluid that is comming out of this.
    production_type = "output",
    pipe_picture = nil,
    pipe_covers = nil, -- The pictures to show when another fluid box connects to this one.
    base_area = 0.01,  -- A base area of 1 will hold 100 units of water, 2 will hold 200, etc...
    base_level = 0,    -- the 'Starting height' of the fluidbox
    pipe_connections = {{ type="output", position = {0, -3.5} }}, -- output on the north side
    --secondary_draw_orders = { north = -1 }
  },
  off_when_no_fluid_recipe = false, -- makes sure it is showing the arrow
}

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
      --[[{
        filename = "__trainConstructionSite__/graphics/placeholders/direction_north.png",
        width = 82,
        height = 82,
        frame_count = 1,
        line_length = 1,
        shift = util.by_pixel(0, -32*1.25),
        hr_version = nil,
      },]]
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
      --[[{
        filename = "__trainConstructionSite__/graphics/placeholders/direction_east.png",
        width = 82,
        height = 82,
        frame_count = 1,
        line_length = 1,
        shift = util.by_pixel(0, -32*1.25),
        hr_version = nil,
      },]]
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
      --[[{
        filename = "__trainConstructionSite__/graphics/placeholders/direction_south.png",
        width = 82,
        height = 82,
        frame_count = 1,
        line_length = 1,
        shift = util.by_pixel(0, -32*1.25),
        hr_version = nil,
      },]]
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
      --[[{
        filename = "__trainConstructionSite__/graphics/placeholders/direction_west.png",
        width = 82,
        height = 82,
        frame_count = 1,
        line_length = 1,
        shift = util.by_pixel(0, -32*1.25),
        hr_version = nil,
      },]]
    },
  },
}

-- split the rendering from the machine
for _,orientation in pairs{"north", "east", "south", "west"} do
  data:extend{{
    type = "animation",
    name = trainassembly.name .. "-" .. orientation,
    layers = util.table.deepcopy(trainassembly.animation[orientation].layers),
  }}
  trainassembly.animation[orientation] =
  {
    filename = "__core__/graphics/empty.png",
    priorit = "very-low",
    width = 1,
    height = 1,
    frame_count = 1,
  }
end

data:extend{
  util.table.deepcopy(trainassembly),
}

-- now create the selector
trainassembly.name = trainassembly.name .. "-recipe-selector"

for _,flag in pairs{
  "player-creation"  ,
  "placeable-enemy"  ,
  "placeable-neutral",
  "placeable-player" ,
} do
  for flagIndex,f in pairs(trainassembly.flags) do
    if flag == f then
      table.remove(trainassembly.flags, flagIndex)
    end
  end
end
for _,flag in pairs{
  "hidden"                     ,
  "hide-alt-info"              ,
  "not-blueprintable"          ,
  "not-deconstructable"        ,
  "no-copy-paste"              ,
  "not-selectable-in-game"     ,
  "not-upgradable"             ,
  "not-flammable"              ,
  "no-automated-item-insertion",
} do
  table.insert(trainassembly.flags, flag)
end

trainassembly.selection_box = nil
trainassembly.collision_mask = {}
trainassembly.collision_box = {{-.49, -.49}, {.49, .49}}

trainassembly.fluid_boxes[1].pipe_connections[1].position = {0, -1}

trainassembly.energy_source.render_no_power_icon = false
trainassembly.energy_source.render_no_network_icon = false

trainassembly.animation =
{
  filename = "__core__/graphics/empty.png",
  priorit = "very-low",
  width = 1,
  height = 1,
  frame_count = 1,
}

data:extend{
  trainassembly,
}
