
if mods["Realistic_Electric_Trains"] then
  for _,locomotive in pairs{
    "ret-electric-locomotive"    ,
    "ret-electric-locomotive-mk2",
    "ret-modular-locomotive"     ,
  } do
    LSlib.recipe.removeIngredient(locomotive .. "-fluid[locomotive]", "trainassembly-recipefuel")
  end
end
