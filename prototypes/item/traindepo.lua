require 'util'

local traindepo = util.table.deepcopy(data.raw["item"]["train-stop"])

traindepo.name                  = "traindepo"
traindepo.localised_name        = {"item-name.traindepo"}
traindepo.localised_description = {"item-description.traindepo"}

traindepo.icon = "__trainConstructionSite__/graphics/placeholders/icon.png"
traindepo.icons = nil
traindepo.icon_size = 32

traindepo.order = traindepo.order .. "-tb[trainbuilding]-a"

traindepo.place_result = traindepo.name

data:extend{
  traindepo,
}
