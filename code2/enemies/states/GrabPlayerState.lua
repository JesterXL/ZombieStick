require "utils.BaseState"

GrabPlayerState = {}

function GrabPlayerState:new()
	local state 		= BaseState:new("grabPlayer")
	state.startTime = nil
	state.MUNCH_TIME = 500
	state.DAMAGE = 1

	function state:onEnterState(event)
		print("GrabPlayerState::onEnterState")
		local zombie = self.entity
		zombie:addEventListener("onZombieGrabDefeated", self)
		self.startTime = 0
		self:exitIfPlayerLost()
	end
	
	function state:onExitState(event)
		print("GrabPlayerState::onExitState")
		local zombie = self.entity
		zombie:removeEventListener("onZombieGrabDefeated", self)
		gGrapplerModel:removeGrappler(self)
	end

	function state:exitIfPlayerLost()
		local zombie = self.entity
		local hits
		local line
		local range = 30
		local bounds = zombie:getBounds()
		if zombie.direction == "left" then
			hits = physics.rayCast(zombie.x + bounds[1], zombie.y, zombie.x + bounds[1] - range, zombie.y, 0)
			line = display.newLine(zombie.x + bounds[1], zombie.y, zombie.x + bounds[1] - range, zombie.y)
		else
			hits = physics.rayCast(zombie.x + bounds[1], zombie.y, zombie.x + bounds[1] + range, zombie.y, 0)
			line = display.newLine(zombie.x + bounds[1], zombie.y, zombie.x + bounds[1] + range, zombie.y)
		end

		mainGroup:insert(line)
		line.x = zombie.x + bounds[1]
		line.y = zombie.y + bounds[2]
		line.tween = transition.to(line, {time = 1000, alpha = 0, onComplete = function(e) line.tween = nil; line:removeSelf() end})

		if hits == nil then
			line:setColor(0, 0, 255)
			self.stateMachine:changeStateToAtNextTick("ready")
			return true
		else
			line:setColor(255, 0, 0)
			local i
			for i=1,#hits do
				local obj = hits[i].object
				if obj == zombie.targetPlayer then
					return false
				end
			end

			self.stateMachine:changeStateToAtNextTick("ready")
			return true
		end
	end

	function state:tick(time)
		if self:exitIfPlayerLost() == true then return true end

		self.startTime = self.startTime + time
		if self.startTime >= self.MUNCH_TIME then
			local zombie = self.entity
			local player = zombie.targetPlayer
			-- print("Zombie bit player...")
			player:setHealth(player.health - self.DAMAGE)
			if gInjuryModel:hasInjuryType(constants.INJURY_BITE) == false then
				-- print("... and added bite injury.")
				gInjuryModel:addInjury(BiteVO:new())
			end
			self.startTime = 0
		end
	end

	function state:onZombieGrabDefeated(event)
		self.stateMachine:changeStateToAtNextTick("stunned")
	end

	return state
end

return GrabPlayerState