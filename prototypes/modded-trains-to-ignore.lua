local trainsToIgnore = {
  ["locomotive"     ] = {},
  ["cargo-wagon"    ] = {},
  ["fluid-wagon"    ] = {},
  ["artillery-wagon"] = {},
}

trainsToIgnore["locomotive"]["trainassembly-placeable"] = true -- trainassembly
trainsToIgnore["locomotive"]["traindisassembly-placeable"] = true -- traindisassembly
--if mods["trainDeconstructionSite"] then 
--  trainsToIgnore["locomotive"]["traindisassembly-placeable"] = true -- traindisassembly
--end

if mods["creative-mod"] then
  for _,cargowagon in pairs{
    "creative-mod_creative-cargo-wagon"   ,
    "creative-mod_duplicating-cargo-wagon",
    "creative-mod_void-cargo-wagon"       ,
  } do
    trainsToIgnore["cargo-wagon"][cargowagon] = true
  end
end

if mods["cargo-ships"] then
  for _,cargowagon in pairs{
    "cargo_ship",
    "boat"      ,
  } do
    trainsToIgnore["cargo-wagon"][cargowagon] = true
  end
  for _,fluidwagon in pairs{
    "oil_tanker",
  } do
    trainsToIgnore["fluid-wagon"][fluidwagon] = true
  end
end

if mods["Armored-train"] then
  for _,cargowagon in pairs{
    "armored-platform-radar-mk1",
  } do
    trainsToIgnore["cargo-wagon"][cargowagon] = true
  end
end

if mods["MultipleUnitTrainControl"] then
  for locomotive,_ in pairs(data.raw["locomotive"]) do
    if string.sub(locomotive, -3) == "-mu" then
      trainsToIgnore["locomotive"][locomotive] = true
    end
  end
end

if mods["VehicleWagon2"] then
  for _,cargowagon in pairs{
    "loaded-vehicle-wagon-tank",
    "loaded-vehicle-wagon-car",
    "loaded-vehicle-wagon-tarp",
  } do
    trainsToIgnore["cargo-wagon"][cargowagon] = true
  end
end

if mods["JunkTrain3"] then
  for _,locomotive in pairs{
    "JunkTrain",
  } do
    trainsToIgnore["locomotive"][locomotive] = true
  end
  for _,cargowagon in pairs{
    "ScrapTrailer",
  } do
    trainsToIgnore["cargo-wagon"][cargowagon] = true
  end
end

return trainsToIgnore
