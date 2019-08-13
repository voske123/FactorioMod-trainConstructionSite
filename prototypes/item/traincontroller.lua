
local traincontroller = util.table.deepcopy(data.raw["item"]["rail-chain-signal"])

traincontroller.name                  = "traincontroller"
traincontroller.localised_name        = {"item-name.traincontroller", {[1] = "item-name.trainassembly"}}
traincontroller.localised_description = {"item-description.traincontroller", {[1] = "item-name.trainassembly"}}

traincontroller.icon = "__trainConstructionSite__/graphics/placeholders/icon.png"
traincontroller.icons = nil
traincontroller.icon_size = 32

traincontroller.order = "d[trainbuilder]-c[controller]"

traincontroller.place_result = traincontroller.name

traincontroller.stack_size = data.raw["item"]["train-stop"].stack_size



data:extend{
  traincontroller,
}
