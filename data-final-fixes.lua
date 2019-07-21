require "prototypes.recipe.trainassembly-trainPlacing-final-fixes"
require "prototypes.technology.trainassembly-trainPlacing-final-fixes"

if mods["FARL"] then
  LSlib.technology.removePrerequisite("rail-signals", "trainassembly-automated-train-assembling")
  LSlib.technology.moveRecipeUnlock("rail-signals", "trainassembly-automated-train-assembling", "farl")
  LSlib.technology.moveRecipeUnlock("rail-signals", "trainassembly-automated-train-assembling", "farl-fluid[locomotive]")
end