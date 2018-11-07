require 'util'

-- Create class
Traincontroller = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Traincontroller:onInit()
  -- Init global data; data stored through the whole map
  if not global.TC_data then
    global.TC_data = self:initGlobalData()
  end
end



-- Initiation of the global data
function Traincontroller:initGlobalData()
  local TC_data = {
    ["version"] = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes

    ["trainControllers"] = {}, -- keep track of all controllers
    ["nextTrainControllerIndex"] = 1,
  }

  return util.table.deepcopy(TC_data)
end



-- Initialisation of the prototye data inside the global data
function Traincontroller:initPrototypeData()
  return
  {
    ["trainControllerName"] = "traincontroller", -- item and entity have same name
  }
end



--------------------------------------------------------------------------------
-- Setter functions to alter data into the data structure
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Traincontroller:getControllerEntityName()
  return global.TC_data.prototypeData.trainControllerName
end



function Traincontroller:checkValidPlacement(createdEntity, playerIndex)
  -- Checks the correct placement of the traincontroller, if not validly placed,
  -- it will inform the player with the corresponding message and return the
  -- traincontroller to the player. If no player is found, it will drop the
  -- traincontroller on the ground where the traincontroller was placed.

  local entityDirection = createdEntity.direction -- direction to look for a trainbuilder
  if entityDirection == defines.direction.west then
    entityDirection = {x=1,y=0}
  elseif entityDirection == defines.direction.east then
    entityDirection = {x=-1,y=0}
  elseif entityDirection == defines.direction.north then
    entityDirection = {x=0,y=1}
  elseif entityDirection == defines.direction.south then
    entityDirection = {x=0,y=-1}
  else
    entityDirection = {x=0,y=0} -- invalid direction
  end

  local entityPosition = createdEntity.position
  local entitySurface = createdEntity.surface
  local entitySurfaceIndex = entitySurface.index

  local builderEntity = entitySurface.find_entities_filtered{
    name     = Trainassembly:getMachineEntityName(),
    --type     = createdEntity.type,
    force    = createdEntity.force,
    area     = {
      { entityPosition.x + 3.5*entityDirection.x - 1.5*entityDirection.y , entityPosition.y + 3.5*entityDirection.y + 1.5*entityDirection.x },
      { entityPosition.x + 5.5*entityDirection.x - 2.5*entityDirection.y , entityPosition.y + 5.5*entityDirection.y + 2.5*entityDirection.x },
    },
    limit    = 1,
  }

  game.print(#builderEntity)
  game.print(serpent.block{
    { entityPosition.x + 3.5*entityDirection.x - 1.5*entityDirection.y , entityPosition.y + 3.5*entityDirection.y + 1.5*entityDirection.x },
    { entityPosition.x + 5.5*entityDirection.x - 2.5*entityDirection.y , entityPosition.y + 5.5*entityDirection.y + 2.5*entityDirection.x },
  })

  return true
end



--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player builds a new entity
function Traincontroller:onPlayerBuildEntity(createdEntity, playerIndex)
  -- The player created a new entity, the player can only place the controller
  -- If he configured the trainbuilder correctly. Otherwise we delete it again
  -- and inform the player what went wrong.
  --
  -- Player experience: The player activated the trainbuilder if its valid.
  if createdEntity and createdEntity.valid and createdEntity.name == self:getControllerEntityName()
  and self:checkValidPlacement(createdEntity, playerIndex) then
    -- TODO
    game.players[playerIndex].print("validly placed.")
  end
end
