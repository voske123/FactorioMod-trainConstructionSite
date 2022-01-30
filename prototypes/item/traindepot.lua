
local traindepot = util.table.deepcopy(data.raw["item"]["train-stop"])

traindepot.name                   = "traindepot"
traindepot.localised_name         = {"item-name.traindepot"}
traindepot.localised_description  = {"item-description.traindepot"}

traindepot.icon                   = "__trainConstructionSite__/graphics/item/traindepot/traindepot.png"
traindepot.icon_size              = 74
traindepot.icons                  = nil
traindepot.icon_mipmaps           = 1

traindepot.order                  = "b[stop]-b[trainbuilding]"

traindepot.place_result           = traindepot.name

data:extend{
  traindepot,
}
