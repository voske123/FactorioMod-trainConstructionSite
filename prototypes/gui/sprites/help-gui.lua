local guiName = "trainConstructionSite-help-content"
data:extend{
  {
    type     = "sprite",
    name     = guiName.."-icon1",
    filename = "__trainConstructionSite__/graphics/sprite/misaligned-icon.png",
    width    = 64,
    height   = 64,
    scale    = .5,
    --shift    = {0, 32},
    flags    = {
      "icon",
      "no-crop"
    },
  },
  {
    type     = "sprite",
    name     = guiName.."-icon2",
    filename = "__trainConstructionSite__/graphics/sprite/fuel-icon-yellow.png",
    width    = 64,
    height   = 64,
    scale    = .5,
    --shift    = {0, 32},
    flags    = {
      "icon",
      "no-crop"
    },
  },
}

-- Introduction ----------------------------------------------------------------
local introductionName = guiName.."-introduction"
data:extend{
  {
    type     = "sprite",
    name     = introductionName.."-sprite1",
    filename = "__trainConstructionSite__/graphics/screenshots/introduction-preview.png",
    width    = 2129,
    height   = 491,
    scale    = .5,
    --shift    = {0, 32},
    flags    = {
      "icon",
      "no-crop"
    },
  },
}

-- Traindepot ------------------------------------------------------------------
local traindepotName = guiName.."-traindepot"
data:extend{
  {
    type     = "sprite",
    name     = traindepotName.."-sprite1",
    filename = "__trainConstructionSite__/graphics/screenshots/traindepot-creation.png",
    width    = 1645,
    height   = 600,
    scale    = .5,
    --shift    = {0, 32},
    flags    = {
      "icon",
      "no-crop"
    },
  },
}

-- Trainbuilder ----------------------------------------------------------------
local trainassemblyName = guiName.."-trainbuilder"
data:extend{
  {
    type     = "sprite",
    name     = trainassemblyName.."-sprite1",
    filename = "__trainConstructionSite__/graphics/screenshots/trainassembly-placement.png",
    width    = 1009,
    height   = 445,
    scale    = .5,
    --shift    = {0, 32},
    flags    = {
      "icon",
      "no-crop"
    },
  },
  {
    type     = "sprite",
    name     = trainassemblyName.."-sprite2",
    filename = "__trainConstructionSite__/graphics/screenshots/trainassembly-direction.png",
    width    = 1896,
    height   = 489,
    scale    = .5,
    --shift    = {0, 32},
    flags    = {
      "icon",
      "no-crop"
    },
  },
}

-- Traincontroller -------------------------------------------------------------
local traincontrollerName = guiName.."-traincontroller"
data:extend{
  {
    type     = "sprite",
    name     = traincontrollerName.."-sprite1",
    filename = "__trainConstructionSite__/graphics/screenshots/traincontroller-placement.png",
    width    = 2090,
    height   = 497,
    scale    = .5,
    --shift    = {0, 32},
    flags    = {
      "icon",
      "no-crop"
    },
  },
  {
    type     = "sprite",
    name     = traincontrollerName.."-sprite2",
    filename = "__trainConstructionSite__/graphics/screenshots/traincontroller-configuration.png",
    width    = 2760,
    height   = 948,
    scale    = .5,
    --shift    = {0, 32},
    flags    = {
      "icon",
      "no-crop"
    },
  },
}
