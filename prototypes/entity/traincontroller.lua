
local traincontroller = util.table.deepcopy(data.raw["train-stop"]["train-stop"])

traincontroller.name = "traincontroller"

traincontroller.minable.result = "traincontroller"

traincontroller.localised_name = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].localised_name)
traincontroller.localised_description = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].localised_description)

traincontroller.icon = data.raw["item"][traincontroller.minable.result].icon
traincontroller.icon_size = data.raw["item"][traincontroller.minable.result].icon_size
traincontroller.icons = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].icons)

traincontroller.rail_overlay_animations = {
  filename = "__core__/graphics/empty.png",
  width = 1,
  height = 1,
  hr_version = nil,
}
traincontroller.animations = {
  filename = "__trainConstructionSite__/graphics/placeholders/2x2.png",
  width = 128,
  height = 128,
  hr_version = nil,
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

traincontrollerSignal.collision_box  = nil
traincontrollerSignal.collision_mask = {}
traincontrollerSignal.selection_box  = nil

traincontrollerSignal.flags = {
  "not-blueprintable",
  "not-deconstructable",
}

traincontrollerSignal.fast_replaceable_group = nil
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


data:extend{
  traincontroller,
  traincontrollerSignal,
}
