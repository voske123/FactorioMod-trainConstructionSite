require 'util'
--require 'lib.util'
--require 'lib.table'

-- Create class
Traincontroller.Builder = {}

--------------------------------------------------------------------------------
-- Initiation of the class
--------------------------------------------------------------------------------
function Traincontroller.Builder:onInit()
  if not global.TC_data.Builder then
    global.TC_data.Builder = self:initGlobalData()
  end
end



function Traincontroller.Builder:onLoad()
  -- sync the on tick event
  if global.TC_data.Builder["onTickActive"] then
    self:activateOnTick()
  else
    self:deactivateOnTick()
  end
end



-- called when a mod setting changed
function Traincontroller.Builder:onSettingChanged(event)
  -- check if the tickrate has changed
  if event.setting_type == "runtime-global" and event.setting == "trainController-tickRate" then
    -- we need to update the on_nth_tick event (step 2), but we fist need to
    -- disable the old one if it was active (step 1), and if it was active,
    -- we have to reactivate it afther updating the settings (step 3)
    local onTickWasActive = global.TC_data.Builder["onTickActive"]

    -- STEP 1: disable the old active on_tick
    if onTickWasActive then
      self:deactivateOnTick()
    end

    -- STEP 2: update the settings
    global.TC_data.Builder["onTickDelay"] = settings.global[event.setting].value

    -- STEP 3: reactivate the on_tick with new settings
    if onTickWasActive then
      self:activateOnTick()
    end
    
  end
end



-- Initiation of the global data
function Traincontroller.Builder:initGlobalData()
  local Builder = {
    ["version"] = 1, -- version of the global data
    ["onTickActive"] = false, -- if the on_tick event is active or not
    ["onTickDelay"] = settings.global["trainController-tickRate"].value,

    ["builderStates"] = { -- states in the builder process
      ["idle"] = 1,       -- waiting till previous train clears the train block
      ["building"] = 1,   -- waiting on resources, building each componennt
      ["connecting"] = 1, -- assembling the train and let it drive off
    },
  }

  return util.table.deepcopy(Builder)
end



--------------------------------------------------------------------------------
-- Behaviour functions
--------------------------------------------------------------------------------
function Traincontroller.Builder:updateController(surfaceIndex, position)
  -- This function will check the update for a single controller
  --game.print("Updating controller @ ["..surfaceIndex..", "..position.x..", "..position.y.."]")
end


--------------------------------------------------------------------------------
-- Event interface
--------------------------------------------------------------------------------
function Traincontroller.Builder:onTick(event)
  game.print(game.tick)

  -- Extract the controller that needs to be updated
  local controller = global.TC_data["nextTrainControllerIterate"]
  local surfaceIndex = controller.surfaceIndex
  local position     = controller.position

  -- Update the controller
  self:updateController(surfaceIndex, position)

  -- Increment the nextController
  global.TC_data["nextTrainControllerIterate"] = util.table.deepcopy(
    global.TC_data["trainControllers"][surfaceIndex][position.y][position.x]["nextController"]
  )
end



function Traincontroller.Builder:activateOnTick()
  -- only need to activate it if its deactivated
  if not global.TC_data.Builder["onTickActive"] then
    --game.print("on_tick activated")
    script.on_nth_tick(global.TC_data.Builder["onTickDelay"], function(event)
      self:onTick(event)
    end)
    global.TC_data.Builder["onTickActive"] = true
  end
end



function Traincontroller.Builder:deactivateOnTick()
  -- only need to deactivate it if its not active
  if global.TC_data.Builder["onTickActive"] then
    --game.print("on_tick deactivated")
    script.on_nth_tick(global.TC_data.Builder["onTickDelay"], nil)
    global.TC_data.Builder["onTickActive"] = false
  end
end
