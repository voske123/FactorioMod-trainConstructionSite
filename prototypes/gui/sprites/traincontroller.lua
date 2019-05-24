
for _,direction in pairs{"L", "R"} do
  data:extend{{
    type     = "sprite",
    name     = string.format("traincontroller-orientation-%s", direction),
    filename = string.format("__trainConstructionSite__/graphics/placeholders/double_arrow_%s.png", direction),
    width    = 64,
    height   = 64,
    scale    = .5,
    --shift    = {0, 32},
    flags    = {
      "icon",
      "no-crop"
    },
  }}
end
