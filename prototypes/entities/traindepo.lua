require 'util'

local traindepo = util.table.deepcopy(data.raw["train-stop"]["train-stop"])

traindepo.name = "traindepo"

traindepo.minable.result = "traindepo"

traindepo.localised_name = util.table.deepcopy(data.raw["item"][traindepo.minable.result].localised_name)
traindepo.localised_description = util.table.deepcopy(data.raw["item"][traindepo.minable.result].localised_description)

traindepo.icon = util.table.deepcopy(data.raw["item"][traindepo.minable.result].icon)
traindepo.icon_size = util.table.deepcopy(data.raw["item"][traindepo.minable.result].icon_size)
traindepo.icons = util.table.deepcopy(data.raw["item"][traindepo.minable.result].icons)



local traindepoConstruction = util.table.deepcopy(traindepo)
traindepoConstruction.name = traindepoConstruction.name .. "-construction"

traindepoConstruction.collision_mask = nil

for _,flag in pairs{
  "placeable-neutral",
  "player-creation",
} do
  for flagIndex,flagName in pairs(traindepoConstruction.flags) do
    if flag == flagName then
      table.remove(traindepoConstruction.flags, flagIndex)
      break
    end
  end
end
table.insert(traindepoConstruction.flags, "not-blueprintable")



data:extend{
  traindepo,
  traindepoConstruction,
}
