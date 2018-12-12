require "util"

local trainassembly = util.table.deepcopy(data.raw["locomotive"]["locomotive"])
trainassembly.name = "trainassembly-placeable"

trainassembly.minable.result = "trainassembly" -- name of the item

-- copy localisation from the item
trainassembly.localised_name = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].localised_name)
trainassembly.localised_description = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].localised_description)

-- copy the icon over from the item
trainassembly.icon = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icon)
trainassembly.icons = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icons)
trainassembly.icon_size = util.table.deepcopy(data.raw["item"][trainassembly.minable.result].icon_size)

-- remove the placeable_off_grid flag
for flagIndex, flagName in pairs(trainassembly.flags) do
  if flagName == "placeable-off-grid" then
    trainassembly.flags[flagIndex] = nil
  end
end

-- selection box
trainassembly.selection_box = {{-3, -3}, {3, 3}} -- when train is facing north
trainassembly.vertical_selection_shift = -.5 -- correction for vertical tracks

-- collision masks
trainassembly.collision_mask =
{
  "train-layer", "player-layer", -- default layers
  "layer-13", -- curved rails
}
trainassembly.collision_box = {{-3, -3.3}, {3, 3.5}} -- when train is facing north

--add collision mask to curved rails
local defaultRailMask = {"object-layer", "item-layer", "floor-layer", "water-tile"}
for railName,_ in pairs(data.raw["curved-rail"]) do
  if not data.raw["curved-rail"][railName].collision_mask then
    data.raw["curved-rail"][railName].collision_mask = util.table.deepcopy(defaultRailMask)
  end
  table.insert(data.raw["curved-rail"][railName].collision_mask, "layer-13")
end

--add collision mask to signals
local defaultSignalMask = {"object-layer", "item-layer", "floor-layer", "water-tile"}
for _, signalType in pairs({"rail-signal", "rail-chain-signal"}) do
  for signalName,_ in pairs(data.raw[signalType]) do
    if not data.raw[signalType][signalName].collision_mask then
      data.raw[signalType][signalName].collision_mask = util.table.deepcopy(defaultSignalMask)
    end
    table.insert(data.raw[signalType][signalName].collision_mask, "layer-13")
  end
end

trainassembly.fast_replaceable_group = nil
trainassembly.max_health = data.raw["assembling-machine"]["assembling-machine-2"].max_health

-- make sure tracks are comming out on both sides
trainassembly.joint_distance = 5
-- make sure you cannot connect it to an actual train
trainassembly.connection_distance = -5
-- you can still connect a train to this, but not this to a train
-- no need to fix this becose this item gets replaced when its build.

-- drawing box (for graphics)
trainassembly.drawing_box = {{-3, -3}, {3, 3}} -- drawing box covering the extra tile

-- graphics
trainassembly.front_light = nil
trainassembly.back_light = nil
trainassembly.stand_by_light = nil
trainassembly.wheels = -- invisible wheels
{
  priority = "very-low",
  width = 1,
  height = 1,
  direction_count = 4,
  frame_count = 1,
  line_length = 1,
  lines_per_file = 1,
  filenames =
  {
    "__core__/graphics/empty.png",
    "__core__/graphics/empty.png",
    "__core__/graphics/empty.png",
    "__core__/graphics/empty.png",
  },
  hr_version = nil,
}
trainassembly.pictures =
{
  layers =
  {
    {
      width = 256,
      height = 256,
      direction_count = 4,
      allow_low_quality_rotation = true,
      frame_count = 1,
      line_length = 4,
      lines_per_file = 1,
      filename = "__trainConstructionSite__/graphics/placeholders/6x6-4.png",
      --[[
      filenames =
      {
        "__trainConstructionSite__/graphics/placeholders/6x6.png",
        "__trainConstructionSite__/graphics/placeholders/6x6.png",
        "__trainConstructionSite__/graphics/placeholders/6x6.png",
        "__trainConstructionSite__/graphics/placeholders/6x6.png",
      },
      ]]--
      hr_version = nil,
    },
    {
      width = 82,
      height = 82,
      direction_count = 4,
      allow_low_quality_rotation = true,
      frame_count = 1,
      line_length = 4,
      lines_per_file = 1,
      filename = "__trainConstructionSite__/graphics/placeholders/directions.png",
      --[[
      filenames =
      {
        "__trainConstructionSite__/graphics/placeholders/direction_north.png",
        "__trainConstructionSite__/graphics/placeholders/direction_east.png",
        "__trainConstructionSite__/graphics/placeholders/direction_south.png",
        "__trainConstructionSite__/graphics/placeholders/direction_west.png",
      },
      ]]--
      hr_version = nil,
    },
  },
}

for _, beltType in pairs({
  "transport-belt",
  "underground-belt",
  "splitter",
}) do
  for _, beltEntity in pairs(data.raw[beltType]) do

    if not beltEntity.collision_mask then
      beltEntity.collision_mask = {}
    end
    table.insert(data.raw[beltType][beltEntity.name].collision_mask, "layer-13")
  end
end


data:extend({
  trainassembly,
})
