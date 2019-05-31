
local traindepot = util.table.deepcopy(data.raw["item"]["train-stop"])

traindepot.name                  = "traindepot"
traindepot.localised_name        = {"item-name.traindepot"}
traindepot.localised_description = {"item-description.traindepot"}

traindepot.icon = "__trainConstructionSite__/graphics/placeholders/icon.png"
traindepot.icons = nil
traindepot.icon_size = 32

traindepot.order = traindepot.order .. "-tb[trainbuilding]-a"

traindepot.place_result = traindepot.name

data:extend{
  traindepot,
}
