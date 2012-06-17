require "com.jxl.core.statemachine.BaseState"
HudControlsJXLState = {}

function HudControlsJXLState:new()

	local state = BaseState:new("HudControlsJXL")
	
	function state:onEnterState(event)
		self.entity:showJXLAttackButton(true)
		Runtime:addEventListener("onDoorCollision", self)
		Runtime:addEventListener("onPlayerInjuriesChanged", self)
		Runtime:addEventListener("onLevelViewPlayersChanged", self)
		self:updateBasedOnPlayerInjuries()
	end
	
	function state:onExitState(event)
		self.entity:showJXLAttackButton(false)
		Runtime:removeEventListener("onDoorCollision", self)
		Runtime:removeEventListener("onPlayerInjuriesChanged", self)
		Runtime:removeEventListener("onLevelViewPlayersChanged", self)
	end
	
	function state:onDoorCollision(event)
		if event.phase == "began" then
			self.entity:showDoorButton(true, event.target.name, event.target.targetDoor)
		else
			self.entity:showDoorButton(false)
		end
	end

	function state:onLevelViewPlayersChanged(event)
		self:updateBasedOnPlayerInjuries()
	end

	-- [jwarden 6.17.2012] TODO/WARNING: a race condition could exist if the player has
	-- injuries, but this state doesn't get initialized with that data. Since he doesn't have
	-- a reference to the player/entity, we need some sort of Model to hold this info.
	-- This becomes important when you switch between characters, and one may, and WILL,
	-- have pre-existing injuries.
	-- For now, we use the LevelView Singleton.
	-- Eventually, we'll have to create an Observer pattern around players since the list
	-- of people who need to know about them and their characteristics is increasing.

	function state:onPlayerInjuriesChanged(event)
		self:updateBasedOnPlayerInjuries()
	end

	function state:updateBasedOnPlayerInjuries()
		local player = LevelView.instance:getPlayerType("PlayerJXL")
		if player == nil then
			self.entity:enableHealing(false)
			-- just wait until they're created
			return true
		end

		if table.maxn(player.injuries) > 0 then
			self.entity:enableHealing(true)
		else
			self.entity:enableHealing(false)
		end
	end
	
	return state
	
end

return HudControlsJXLState