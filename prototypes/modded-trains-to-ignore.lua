local trainsToIgnore = {
  ["locomotive"     ] = {},
  ["cargo-wagon"    ] = {},
  ["fluid-wagon"    ] = {},
  ["artillery-wagon"] = {},
}

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

return trainsToIgnore
