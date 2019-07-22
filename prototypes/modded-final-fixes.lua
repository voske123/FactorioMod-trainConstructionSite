-- removing trainfuel from the electric trains
local trainfuel = "trainassembly-recipefuel"

if mods["Realistic_Electric_Trains"] then
  for _,locomotive in pairs{
    "ret-electric-locomotive"    ,
    "ret-electric-locomotive-mk2",
    "ret-modular-locomotive"     ,
  } do
    LSlib.recipe.removeIngredient(locomotive .. "-fluid[locomotive]", trainfuel)
  end
end

if mods["Electronic_Locomotives"] then
  for _,locomotive in pairs{
    "Senpais-Electric-Train"      ,
    "Senpais-Electric-Train-Heavy",
  } do
    LSlib.recipe.removeIngredient(locomotive .. "-fluid[locomotive]", trainfuel)
  end
end

if mods["Electronic_Battle_Locomotives"] then
  for _,locomotive in pairs{
    "Elec-Battle-Loco-1",
    "Elec-Battle-Loco-2",
    "Elec-Battle-Loco-3",
  } do
    LSlib.recipe.removeIngredient(locomotive .. "-fluid[locomotive]", trainfuel)
  end
end

-- Other changes
if mods["FARL"] then
    LSlib.technology.removePrerequisite("rail-signals", "trainassembly-automated-train-assembling")
    LSlib.technology.moveRecipeUnlock("rail-signals", "trainassembly-automated-train-assembling", "farl")
    LSlib.technology.addRecipeUnlock("trainassembly-automated-train-assembling", "farl-fluid[locomotive]")
end

if mods["TrainOverhaul"] then
    LSlib.technology.addRecipeUnlock("nuclear-locomotive", "nuclear-locomotive-fluid[locomotive]")
  end