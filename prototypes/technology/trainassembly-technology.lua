
if data.raw["technology"]["railway"].effects then
  for effectIndex, effect in pairs(data.raw["technology"]["railway"].effects) do
    if effect.type == "unlock-recipe"
    and (effect.recipe == "locomotive" or effect.recipe == "cargo-wagon") then
      data.raw["technology"]["railway"].effects[effectIndex] = nil -- this removes that single unlock
    end
  end

else
  data.raw["technology"]["railway"].effects = {}
end

for _, fuelIngredient in pairs ({
  "raw-wood",
  "coal",
}) do
  table.insert(data.raw["technology"]["railway"].effects,
  {
    type = "unlock-recipe",
    recipe = "trainassembly-trainfuel-" .. fuelIngredient,
  })
end

table.insert(data.raw["technology"]["railway"].effects,
{
  type = "unlock-recipe",
  recipe = "trainassembly",
})
