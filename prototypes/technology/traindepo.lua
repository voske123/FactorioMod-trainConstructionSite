
table.insert(data.raw["technology"]["automated-rail-transportation"].effects,
{
  type = "unlock-recipe",
  recipe = "traindepo",
})


table.insert(data.raw["technology"]["automated-rail-transportation"].prerequisites, "circuit-network")
