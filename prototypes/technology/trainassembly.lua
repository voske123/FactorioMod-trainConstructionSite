
local trainTechBuilder = util.table.deepcopy(data.raw["technology"]["railway"])

trainTechBuilder.name = "trainassembly-automated-train-assembling"

trainTechBuilder.localised_name = {"technology-name.trainTechBuilder"}
trainTechBuilder.localised_description = {"technology-description.trainTechBuilder"}

trainTechBuilder.icon = "__trainConstructionSite__/graphics/technology/trainassembly.png"
trainTechBuilder.icon_size = 128
trainTechBuilder.icons = nil
trainTechBuilder.icon_mipmaps = 1

trainTechBuilder.effects = {}
trainTechBuilder.prerequisites = {"rail-signals", --[["logistics-2",]] "automation-2",}



for _, recipeName in pairs{
  "trainassembly",
} do
  table.insert(trainTechBuilder.effects,
  {
    type = "unlock-recipe",
    recipe = recipeName,
  })
end



data:extend{ -- add train technology to tech tree
  trainTechBuilder,
}
