require 'util'

local traincontroller = util.table.deepcopy(data.raw["train-stop"]["train-stop"])

traincontroller.name = "traincontroller"

traincontroller.minable.result = "traincontroller"

traincontroller.localised_name = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].localised_name)
traincontroller.localised_description = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].localised_description)

traincontroller.icon = data.raw["item"][traincontroller.minable.result].icon
traincontroller.icon_size = data.raw["item"][traincontroller.minable.result].icon_size
traincontroller.icons = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].icons)

table.insert(traincontroller.flags, "not-blueprintable")



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


data:extend{
  traincontroller,
  traincontrollerSignal,
}
