
-- Create class
TrainFuel = {}

--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player/robot removes the building
function TrainFuel:onRemoveEntity(removedEntity, removedInventory)
  -- In some way a train was removed. If it is done by the player, he could 
  -- obtain the 'wrong' trainfuel type.
  --
  -- Player experience: Do not obtain any train fuel at all
  if removedEntity.type == "locomotive" then
    removedInventory.remove{
      name = "trainassembly-trainfuel",
      amount = 100 -- all the fuel
    }
  end
end