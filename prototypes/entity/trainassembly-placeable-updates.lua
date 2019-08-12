
-- collision masks
local extraLayer1 = "layer-15" -- for rails
local extraLayer2 = "layer-12" -- for belts

--add collision mask to the trainassembler itself
for _,extraLayer in pairs{extraLayer1, extraLayer2} do
  table.insert(data.raw["locomotive"]["trainassembly-placeable"].collision_mask, extraLayer)
end

--add collision mask to curved rails
for _, railData in pairs(data.raw["curved-rail"]) do
  railData.collision_mask = util.table.deepcopy(railData.collision_mask or {"object-layer", "item-layer", "floor-layer", "water-tile"})
  table.insert(railData.collision_mask, extraLayer1)
end

--add collision mask to signals
for _, signalType in pairs({"rail-signal", "rail-chain-signal"}) do
  for _, signalData in pairs(data.raw[signalType]) do
    signalData.collision_mask = util.table.deepcopy(signalData.collision_mask or {"object-layer", "item-layer", "floor-layer", "water-tile"})
    table.insert(signalData.collision_mask, extraLayer1)
  end
end

--add collision mask to belts
for _, beltType in pairs({
  "transport-belt",
}) do
  for _, beltEntity in pairs(data.raw[beltType]) do
    beltEntity.collision_mask = util.table.deepcopy(beltEntity.collision_mask or {"floor-layer", "object-layer", "water-tile"})
    table.insert(beltEntity.collision_mask, extraLayer2)
  end
end
for _, beltType in pairs({
  "underground-belt",
  "splitter",
}) do
  for _, beltEntity in pairs(data.raw[beltType]) do
    beltEntity.collision_mask = util.table.deepcopy(beltEntity.collision_mask or {"item-layer", "object-layer", "water-tile"})
    table.insert(beltEntity.collision_mask, extraLayer2)
  end
end
