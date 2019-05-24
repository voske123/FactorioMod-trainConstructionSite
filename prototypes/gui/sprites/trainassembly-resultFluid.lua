require "LSlib.lib"

return function(fluidName, makeUtilityDirectionSprites)
  local utilitySprite = {
    type     = "sprite",
    name     = nil     ,
    priority = nil     , -- default to medium
    layers   = {}      ,
  }
  for iconLayerIndex,iconLayer in pairs(LSlib.item.getIcons("fluid", fluidName)) do
    utilitySprite.layers[iconLayerIndex] = {
      filename = iconLayer.icon     ,
      width    = iconLayer.icon_size,
      height   = iconLayer.icon_size,
      flags    = {"icon"}           ,
      tint     = iconLayer.tint     ,
      shift    = iconLayer.shift    ,
      scale    = iconLayer.scale    ,
    }
  end
  for _,direction in pairs{"L", "R"} do
    local utilitySpriteDirection = util.table.deepcopy(utilitySprite)
    utilitySpriteDirection.name = string.format("%s-%s", fluidName, direction)

    if makeUtilityDirectionSprites then
      table.insert(utilitySpriteDirection.layers, {
        filename = string.format("__trainConstructionSite__/graphics/placeholders/double_arrow_%s.png", direction),
        width    = 64,
        height   = 64,
        scale    = .5,
        flags    = {
          "icon",
          "no-crop"
        },
      })
    end

    data:extend{utilitySpriteDirection}
    log(serpent.block(data.raw[utilitySpriteDirection.type][utilitySpriteDirection.name]))
  end
end
