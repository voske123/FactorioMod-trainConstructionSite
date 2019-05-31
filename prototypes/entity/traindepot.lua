
local traindepot = util.table.deepcopy(data.raw["train-stop"]["train-stop"])

traindepot.name = "traindepot"

traindepot.minable.result = "traindepot"

traindepot.localised_name = util.table.deepcopy(data.raw["item"][traindepot.minable.result].localised_name)
traindepot.localised_description = util.table.deepcopy(data.raw["item"][traindepot.minable.result].localised_description)

traindepot.icon = util.table.deepcopy(data.raw["item"][traindepot.minable.result].icon)
traindepot.icon_size = util.table.deepcopy(data.raw["item"][traindepot.minable.result].icon_size)
traindepot.icons = util.table.deepcopy(data.raw["item"][traindepot.minable.result].icons)



data:extend{
  traindepot,
}
