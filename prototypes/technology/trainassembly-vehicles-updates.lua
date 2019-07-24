
--Unlocking locomotive manual build in the railway techtree

for _, trainRecipe in pairs ({
  "locomotive-manual-build",
}) do
  if data.raw["recipe"][trainRecipe] then
    table.insert(data.raw["technology"]["railway"].effects,
    {
      type = "unlock-recipe",
      recipe = trainRecipe,
    })
  end
end
