local guiName = "trainConstructionSite-help-content"
data:extend{
  {
    type     = "sprite",
    name     = guiName.."-icon1",
    filename = "__core__/graphics/misaligned-icon.png",
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
    width    = 2535,
    height   = 592,
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
    width    = 2440,
    height   = 886,
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
    width    = 1644,
    height   = 716,
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
    width    = 2353,
    height   = 595,
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
    width    = 2013,
    height   = 487,
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
    width    = 2491,
    height   = 869,
    scale    = .5,
    --shift    = {0, 32},
    flags    = {
      "icon",
      "no-crop"
    },
  },
}
