
table.insert(data.raw["technology"]["automated-rail-transportation"].effects,
{
  type = "unlock-recipe",
  recipe = "traindepot",
})


table.insert(data.raw["technology"]["automated-rail-transportation"].prerequisites, "circuit-network")
