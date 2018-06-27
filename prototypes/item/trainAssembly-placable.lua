require 'util'

local trainAssemblyRotatable = util.table.deepcopy(data.raw["item"]["rail-signal"])
trainAssemblyRotatable["name"] = "trainassembly-rotatable"
trainAssemblyRotatable["localised_name"] = {"item-name.trainassembly-rotatable"}
trainAssemblyRotatable["localised_description"] = {"item-description.trainassembly-rotatable"}

local trainAssemblyNotRotatable = util.table.deepcopy(data.raw["item"]["rail-chain-signal"])
trainAssemblyNotRotatable["name"] = "trainassembly-notrotatable"
trainAssemblyNotRotatable["localised_name"] = {"item-name.trainassembly-notrotatable"}
trainAssemblyNotRotatable["localised_description"] = {"item-description.trainassembly-notrotatable"}

data:extend({
  trainAssemblyRotatable,
  trainAssemblyNotRotatable,

})
