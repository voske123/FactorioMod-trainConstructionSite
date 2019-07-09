
-- collision masks
local extraLayer1 = "layer-15" -- for rails
local extraLayer2 = "layer-12" -- for belts

--add collision mask to curved rails
for railName,_ in pairs(data.raw["curved-rail"]) do

  if not data.raw["curved-rail"][railName].collision_mask then -- add default layers
    data.raw["curved-rail"][railName].collision_mask = {"object-layer", "item-layer", "floor-layer", "water-tile"}
  end
  table.insert(data.raw["curved-rail"][railName].collision_mask, extraLayer1)
end

--add collision mask to signals
for _, signalType in pairs({"rail-signal", "rail-chain-signal"}) do
  for signalName,_ in pairs(data.raw[signalType]) do

    if not data.raw[signalType][signalName].collision_mask then -- add default layers
      data.raw[signalType][signalName].collision_mask = {"object-layer", "item-layer", "floor-layer", "water-tile"}
    end
    table.insert(data.raw[signalType][signalName].collision_mask, extraLayer1)
  end
end

--add collision mask to belts
for _, beltType in pairs({
  "transport-belt",
}) do
  for _, beltEntity in pairs(data.raw[beltType]) do

    if not beltEntity.collision_mask then -- add default layers
      beltEntity.collision_mask = {"floor-layer", "object-layer", "water-tile"}
    end
    table.insert(data.raw[beltType][beltEntity.name].collision_mask, extraLayer2)
  end
end
for _, beltType in pairs({
  "underground-belt",
  "splitter",
}) do
  for _, beltEntity in pairs(data.raw[beltType]) do

    if not beltEntity.collision_mask then -- add default layers
      beltEntity.collision_mask = {"item-layer", "object-layer", "water-tile"}
    end
    table.insert(data.raw[beltType][beltEntity.name].collision_mask, extraLayer2)
  end
end
