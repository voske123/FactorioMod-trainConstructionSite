require 'util'

local traincontroller = util.table.deepcopy(data.raw["item"]["train-stop"])

traincontroller.name                  = "traincontroller"
traincontroller.localised_name        = {"item-name.traincontroller", {[1] = "item-name.trainassembly"}}
traincontroller.localised_description = {"item-description.traincontroller", {[1] = "item-name.trainassembly"}}

traincontroller.icon = "__trainConstructionSite__/graphics/placeholders/icon.png"
traincontroller.icons = nil
traincontroller.icon_size = 32

traincontroller.order = traincontroller.order .. "-a"

traincontroller.place_result = traincontroller.name



data:extend{
  traincontroller,
}
