
local traincontroller = util.table.deepcopy(data.raw["train-stop"]["train-stop"])

traincontroller.name = "traincontroller"

traincontroller.minable.result = "traincontroller"

traincontroller.localised_name = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].localised_name)
traincontroller.localised_description = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].localised_description)

traincontroller.icon = data.raw["item"][traincontroller.minable.result].icon
traincontroller.icon_size = data.raw["item"][traincontroller.minable.result].icon_size
traincontroller.icons = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].icons)
traincontroller.icon_mipmaps = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].icon_mipmaps)

traincontroller.drawing_box = traincontroller.selection_box

--traincontroller.map_color          = data.raw["utility-constants"]["default"].chart.default_friendly_color
--traincontroller.friendly_map_color = traincontroller.map_color
--traincontroller.enemy_map_color    = data.raw["utility-constants"]["default"].chart.default_enemy_color
traincontroller.chart_name = false

traincontroller.flags = traincontroller.flags or {}
table.insert(traincontroller.flags, "not-on-map")

traincontroller.rail_overlay_animations = {
  filename = "__core__/graphics/empty.png",
  width = 1,
  height = 1,
  hr_version = nil,
}
traincontroller.animations = {
  north =
  {
    filename = "__trainConstructionSite__/graphics/entity/traincontroller/traincontroller-N.png",
    priority = "high",
    width = 192,
    height = 192,
    frame_count = 1,
    line_length = 1,
    scale = 0.59,
    shift = util.by_pixel(12, -12),
    hr_version = nil,
  },
  east =
  {
    filename = "__trainConstructionSite__/graphics/entity/traincontroller/traincontroller-E.png",
    priority = "high",
    width = 192,
    height = 192,
    frame_count = 1,
    line_length = 1,
    scale = 0.59,
    shift = util.by_pixel(12, -12),
    hr_version = nil,
  },
  south =
  {
    filename = "__trainConstructionSite__/graphics/entity/traincontroller/traincontroller-S.png",
    priority = "high",
    width = 192,
    height = 192,
    frame_count = 1,
    line_length = 1,
    scale = 0.59,
    shift = util.by_pixel(12, -12),
    hr_version = nil,
  },
  west =
  {
    filename = "__trainConstructionSite__/graphics/entity/traincontroller/traincontroller-W.png",
    priority = "high",
    width = 192,
    height = 192,
    frame_count = 1,
    line_length = 1,
    scale = 0.59,
    shift = util.by_pixel(14, -12),
    hr_version = nil,
  },
}
traincontroller.top_animations = {
  filename = "__core__/graphics/empty.png",
  width = 1,
  height = 1,
  hr_version = nil,
}
traincontroller.light1 = {
  light = {intensity = 0, size = 0, color = {r = 1.0, g = 1.0, b = 1.0}},
  picture =
    {
      filename = "__core__/graphics/empty.png",
      width = 1,
      height = 1,
      hr_version = nil,
    },
  red_picture =
    {
      filename = "__core__/graphics/empty.png",
      width = 1,
      height = 1,
      hr_version = nil,
    },
}
traincontroller.light2 = {
  light = {intensity = 0, size = 0, color = {r = 1.0, g = 1.0, b = 1.0}},
  picture =
    {
      filename = "__core__/graphics/empty.png",
      width = 1,
      height = 1,
      hr_version = nil,
    },
  red_picture =
    {
      filename = "__core__/graphics/empty.png",
      width = 1,
      height = 1,
      hr_version = nil,
    },
}

traincontroller.circuit_wire_max_distance = 0


table.insert(traincontroller.flags, "not-blueprintable")



-- hidden entities --
local traincontrollerSignal = util.table.deepcopy(data.raw["rail-signal"]["rail-signal"])

traincontrollerSignal.name = traincontroller.name .. "-signal"

traincontrollerSignal.icon = traincontroller.icon
traincontrollerSignal.icon_size = traincontroller.icon_size
traincontrollerSignal.icons = util.table.deepcopy(traincontroller.icons)
traincontrollerSignal.icon_mipmaps = traincontroller.icon_mipmaps

traincontrollerSignal.collision_box  = nil
traincontrollerSignal.collision_mask = {}
traincontrollerSignal.selection_box  = nil

traincontrollerSignal.flags = {
  "not-blueprintable",
  "not-deconstructable",
  "not-on-map",
}

traincontrollerSignal.fast_replaceable_group = nil
traincontrollerSignal.next_upgrade = nil
traincontrollerSignal.minable = nil

traincontrollerSignal.animation = {
  filename = "__core__/graphics/empty.png",
  priority = "low",
  width = 1,
  height = 1,
  frame_count = 1,
  direction_count = 1,
  hr_version = nil,
}

traincontrollerSignal.rail_piece = {
  filename = "__core__/graphics/empty.png",
  line_length = 1,
  width = 1,
  height = 1,
  frame_count = 1,
  axially_symmetrical = false,
  hr_version = nil,
}

traincontrollerSignal.green_light.intensity = 0
traincontrollerSignal.orange_light.intensity = 0
traincontrollerSignal.red_light.intensity = 0

traincontrollerSignal.circuit_wire_connection_points = {circuit_connector_definitions["rail-signal"].points[1]}
traincontrollerSignal.circuit_connector_sprites  = {circuit_connector_definitions["rail-signal"].sprites[1]}

local traincontrollerMapview = {
  type = "simple-entity-with-force",
  name = traincontroller.name .. "-mapview",

  picture = {
    filename = "__core__/graphics/empty.png",
    width = 1,
    height = 1,
    priority = "low",
  },

  selection_box  = nil,
  collision_box  = {{-1,-1},{1,1}},
  collision_mask = {},

  map_color          = data.raw["utility-constants"]["default"].chart.default_friendly_color,
  friendly_map_color = data.raw["utility-constants"]["default"].chart.default_friendly_color,
  enemy_map_color    = data.raw["utility-constants"]["default"].chart.default_enemy_color,
}

data:extend{
  traincontroller,
  traincontrollerSignal,
  traincontrollerMapview,
}
