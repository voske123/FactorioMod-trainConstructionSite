
local traindepot = util.table.deepcopy(data.raw["item"]["train-stop"])

traindepot.name                   = "traindepot"
traindepot.localised_name         = {"item-name.traindepot"}
traindepot.localised_description  = {"item-description.traindepot"}

traindepot.icon                   = nil
traindepot.icon_size              = nil
traindepot.icons                  = LSlib.item.getIcons(traindepot.type, "train-stop", nil, {-6, 0}, {r=40/255, g=190/255, b=220/255})
table.insert(traindepot.icons, {
  icon = "__trainConstructionSite__/graphics/item/traindepot/depot-128.png",
  icon_size = 128,
  scale = 16/128,
  shift = {8, 8},
})
traindepot.icon_mipmaps           = 1

traindepot.order                  = "b[stop]-b[trainbuilding]"

traindepot.place_result           = traindepot.name

data:extend{
  traindepot,
}
