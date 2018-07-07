
  if not data.raw["technology"]["railway"].effects then
    data.raw["technology"]["railway"].effects = {}
  end

  table.insert(data.raw["technology"]["railway"].effects, {
    type = "unlock-recipe",
    recipe = "trainassembly",
  })
