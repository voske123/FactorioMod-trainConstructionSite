
-- To make sure everything is inline with the technology tree when the mod is added.
-- This is for when the mod is added into an existing game or when the mod is updated.
return function(configurationData)
  local modChanges = configurationData.mod_changes["trainConstructionSite"]
  if modChanges and modChanges.new_version ~= (modChanges.old_version or "") then
    log(string.format("Updating trainConstructionSite from version %q to version %q", modChanges.old_version or "nil", modChanges.new_version))

    --------------------------------------------------
    -- Prototype data                               --
    --------------------------------------------------
    for forceName, force in pairs(game.forces) do
      local technologies = force.technologies
      local recipes      = force.recipes

      if recipes["locomotive"].enabled then
        technologies["trainassembly-automated-train-assembling"].researched = true
      end

      if recipes["cargo-wagon"].enabled then
        technologies["trainassembly-cargo-wagon"].researched = true
     end

      if recipes["artillery-wagon"].enabled then
        technologies["trainassembly-artillery-wagon"].researched = true
      end

      force.reset_technology_effects()
    end

    --------------------------------------------------
    -- Trainassembly script                         --
    --------------------------------------------------
    if global.TA_data.version == 1 then
      log("Updating Trainassembly from version 1 to version 2.")
      global.TA_data.prototypeData.trainTint = {}
      global.TA_data.version = 2
    end

    if global.TA_data.version == 2 then
      log("Updating Trainassembly from version 2 to version 3.")
      global.TA_data.prototypeData.rollingStock =
      {
        ["locomotive"     ] = true,
        ["cargo-wagon"    ] = true,
        ["fluid-wagon"    ] = true,
        ["artillery-wagon"] = true,
      }
      global.TA_data.version = 3
    end

  end
end
