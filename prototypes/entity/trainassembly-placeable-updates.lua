local collision_mask_util = require "collision-mask-util"

-- collision masks
local extraLayer1 = collision_mask_util.get_first_unused_layer() -- for rails
local extraLayer2 = "transport-belt-layer" -- for belts

--add collision mask to the trainassembler itself
for _,extraLayer in pairs{extraLayer1, extraLayer2} do
  collision_mask_util.add_layer(data.raw["locomotive"]["trainassembly-placeable"].collision_mask, extraLayer)
  if mods["trainDeconstructionSite"] then
    collision_mask_util.add_layer(data.raw["locomotive"]["traindisassembly-placeable"].collision_mask, extraLayer)
  end
end

--add collision mask to curved rails
for _, railData in pairs(data.raw["curved-rail"]) do
  railData.collision_mask = util.table.deepcopy(collision_mask_util.get_mask(railData))
  collision_mask_util.add_layer(railData.collision_mask, extraLayer1)
  railData.selection_priority = 49 -- default is 50
end

--add collision mask to signals
for _, signalType in pairs({"rail-signal", "rail-chain-signal"}) do
  for _, signalData in pairs(data.raw[signalType]) do
    signalData.collision_mask = util.table.deepcopy(collision_mask_util.get_mask(signalData))
    collision_mask_util.add_layer(signalData.collision_mask, extraLayer1)
  end
end

--add collision mask to belts
for _, beltType in pairs({
  "transport-belt",
}) do
    for _, beltEntity in pairs(data.raw[beltType]) do
      beltEntity.collision_mask = util.table.deepcopy(collision_mask_util.get_mask(beltEntity))
      collision_mask_util.add_layer(beltEntity.collision_mask, extraLayer2)
  end
end
for _, beltType in pairs({
  "underground-belt",
  "splitter",
}) do
  for _, beltEntity in pairs(data.raw[beltType]) do
    beltEntity.collision_mask = util.table.deepcopy(collision_mask_util.get_mask(beltEntity))
    collision_mask_util.add_layer(beltEntity.collision_mask, extraLayer2)
  end
end

