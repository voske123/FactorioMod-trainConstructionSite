
-- To make sure everything is inline with the technology tree when the mod is added.
-- This is mainly for when the mod is added into an existing game.
return function(configurationData)
  local modChanges = configurationData.mod_changes["trainConstructionSite"]
  if modChanges and modChanges.new_version ~= (modChanges.old_version or "") then
    -- mod has changed, so we check the progress
    for forceName, force in pairs(game.forces) do
      local technologies = force.technologies
      local recipes      = force.recipes

      -- manual building locomotive --------------------------------------------
      if technologies["railway"].researched then
        recipes["locomotive-manual-build"].enabled = true
      end

      -- train depot -----------------------------------------------------------
      if technologies["automated-rail-transportation"].researched then
        recipes["traindepot"].enabled = true
      end

      -- locomotive ------------------------------------------------------------
      if recipes["locomotive"].enabled then
         technologies["trainassembly-automated-train-assembling"].researched = true
      end

      -- cargo wagon -----------------------------------------------------------
      if recipes["cargo-wagon"].enabled then
         technologies["trainassembly-cargo-wagon"].researched = true
      end

      -- artillery wagon -------------------------------------------------------
      if recipes["artillery-wagon"].enabled then
         technologies["trainassembly-artillery-wagon"].researched = true
      end

      -- fluid wagon -----------------------------------------------------------
      if technologies["fluid-wagon"].researched then
        recipes["fluid-wagon-fluid[fluid-wagon]"].enabled = true
      end

    end
  end
end
