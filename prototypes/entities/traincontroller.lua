require 'util'

local traincontroller = util.table.deepcopy(data.raw["train-stop"]["train-stop"])

traincontroller.name = "traincontroller"

traincontroller.minable.result = "traincontroller"

traincontroller.localised_name = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].localised_name)
traincontroller.localised_description = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].localised_description)

traincontroller.icon = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].icon)
traincontroller.icon_size = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].icon_size)
traincontroller.icons = util.table.deepcopy(data.raw["item"][traincontroller.minable.result].icons)

table.insert(traincontroller.flags, "not-blueprintable")

data:extend{
  traincontroller,
}
