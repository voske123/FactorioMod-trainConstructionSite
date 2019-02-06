require 'util'

-- Create class
Traindepo = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Traindepo:onInit()
  -- Init global data; data stored through the whole map
  if not global.TD_data then
    global.TD_data = self:initGlobalData()
  end

  -- Create new forces for existing forces
  self:createConstructionForces()
end



-- Initiation of the global data
function Traindepo:initGlobalData()
  local TD_data = {
    ["version"]       = 1, -- version of the global data
    ["prototypeData"] = self:initPrototypeData(), -- data storing info about the prototypes

    ["trainDepos"] = {},  -- keep track of all depos
    ["depoNames"]  = {},  -- keep track of all depo names
  }

  return util.table.deepcopy(TD_data)
end



-- Initialisation of the prototye data inside the global data
function Traindepo:initPrototypeData()
  return
  {
    ["traindepoName"] = "traindepo", -- item and entity have same name
    ["traindepoForceName"] = "-construction", -- name for hidden force
  }
end



function Traindepo:createConstructionForces()
  local forcesToCreate = {}

  -- get a list for all the forces to create
  for forceName,_ in pairs(game.forces) do
    if forceName ~= "enemy" and forceName ~= "neutral" then
      table.insert(forcesToCreate, forceName)
    end
  end

  -- create all the forces
  for _,forceName in pairs(forcesToCreate) do
    game.create_force(forceName..global.TD_data["prototypeData"]["traindepoForceName"])
        .set_friend(forceName, true)
  end
end



--------------------------------------------------------------------------------
-- Setter functions to alter data into the data structure
--------------------------------------------------------------------------------
function Traindepo:saveNewStructure(depoEntity)
  -- With this function we save all the data we want about a traindepo

  -- STEP 1: We can already store the entity in the structure
  -- STEP 1a:Make sure we can index it, meaning, check if the table already
  --         excists for the surface, if not, we make one. Afther that we also
  --         have to check if the surface table has a table we can index for
  --         the y-position, if not, we make one.
  local depoSurface  = depoEntity.surface
  local depoPosition = depoEntity.position
  if not global.TD_data["trainDepos"][depoSurface.index] then
    global.TD_data["trainDepos"][depoSurface.index] = {}
  end
  if not global.TD_data["trainDepos"][depoSurface.index][depoPosition.y] then
    global.TD_data["trainDepos"][depoSurface.index][depoPosition.y] = {}
  end

  -- STEP 1b:Now we know we can index (without crashing) to the position as:
  --         dataStructure[surfaceIndex][positionY][positionX]
  --         Now we can store our wanted data at this position
  global.TD_data["trainDepos"][depoSurface.index][depoPosition.y][depoPosition.x] = depoEntity

  -- STEP 2: Save the station name to the list (used in the UI)
  -- STEP 2a:Make sure we can index it (same as step 1a)
  if not global.TD_data["depoNames"][depoEntity.force.name] then
    global.TD_data["depoNames"][depoEntity.force.name] = {}
  end
  if not global.TD_data["depoNames"][depoEntity.force.name][depoSurface.index] then
    global.TD_data["depoNames"][depoEntity.force.name][depoSurface.index] = {}
  end

  -- STEP 2b:Now we know we can index (without crashing) to the position as:
  --         dataStructure[forceName][surfaceIndex]
  --         Now we can store the depoName here
  local stationName = depoEntity.backer_name
  local stationAmount = global.TD_data["depoNames"][depoEntity.force.name][depoSurface.index][stationName]
  if stationAmount then
    global.TD_data["depoNames"][depoEntity.force.name][depoSurface.index][stationName] = stationAmount + 1
  else
    global.TD_data["depoNames"][depoEntity.force.name][depoSurface.index][stationName] = 1
  end
end



--------------------------------------------------------------------------------
-- Getter functions to extract data from the data structure
--------------------------------------------------------------------------------
function Traindepo:getDepoEntityName()
  return global.TD_data["prototypeData"]["traindepoName"]
end




--------------------------------------------------------------------------------
-- Behaviour functions, mostly event handlers
--------------------------------------------------------------------------------
-- When a player builds a new entity
function Traindepo:onBuildEntity(createdEntity)
  if createdEntity and createdEntity.valid and createdEntity.name == self:getDepoEntityName() then
    -- a force created a depo, now we create the one on the construction force
    local constructionEntity = createdEntity.surface.create_entity{
      name      = createdEntity.name .. global.TD_data["prototypeData"]["traindepoForceName"],
      position  = createdEntity.position,
      direction = createdEntity.direction,
      force     = createdEntity.force.name .. global.TD_data["prototypeData"]["traindepoForceName"],
    }
    if not constructionEntity then return end

    -- we give it the same name, station names are set in there backer name
    constructionEntity.backer_name = createdEntity.backer_name

    self:saveNewStructure(constructionEntity)

  end
end



function Traindepo:onRemoveEntity(removedEntity)
  if removedEntity and removedEntity.name == self:getDepoEntityName() then

  end
end
