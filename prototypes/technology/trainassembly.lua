require "util"

local trainTechBuilder = util.table.deepcopy(data.raw["technology"]["railway"])

trainTechBuilder.name = "trainassembly-automated-train-assembling"
trainTechBuilder.effects = {}
trainTechBuilder.localised_name = {"technology-name.trainTechBuilder"}
trainTechBuilder.localised_description = {"technology-description.trainTechBuilder"}
trainTechBuilder.prerequisites = {"automated-rail-transportation", "logistics-2", "automation-2", "steel-processing"}



for _, recipeName in pairs{
  "trainassembly",
} do
  table.insert(trainTechBuilder.effects,
  {
    type = "unlock-recipe",
    recipe = recipeName,
  })
end



if data.raw["technology"]["railway"].prerequisites then
  for prerequisitesIndex, prerequisite in pairs(data.raw["technology"]["railway"].prerequisites) do
    if prerequisite == "logistics-2" then
      data.raw["technology"]["railway"].prerequisites[prerequisitesIndex] = "logistics"
    end
  end
end




data:extend{ -- add train technology to tech tree
  trainTechBuilder,
}
