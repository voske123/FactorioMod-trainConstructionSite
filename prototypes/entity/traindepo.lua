
local traindepo = util.table.deepcopy(data.raw["train-stop"]["train-stop"])

traindepo.name = "traindepo"

traindepo.minable.result = "traindepo"

traindepo.localised_name = util.table.deepcopy(data.raw["item"][traindepo.minable.result].localised_name)
traindepo.localised_description = util.table.deepcopy(data.raw["item"][traindepo.minable.result].localised_description)

traindepo.icon = util.table.deepcopy(data.raw["item"][traindepo.minable.result].icon)
traindepo.icon_size = util.table.deepcopy(data.raw["item"][traindepo.minable.result].icon_size)
traindepo.icons = util.table.deepcopy(data.raw["item"][traindepo.minable.result].icons)



data:extend{
  traindepo,
}
