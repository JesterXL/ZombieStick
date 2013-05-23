require "utils.BaseState"

ReadyState = {}

function ReadyState:new()
	local state = BaseState:new("ready")
	state.THINK_TIME = 2000
	state.startTime = nil

	function state:onEnterState(event)
		print("IdleState::onEnterState, zombie")
		local zombie = self.entity
		-- zombie:addEventListener("onZombieHit", self)
		-- zombie:startMoving()
		--player.angularVelocity = 0
		state.startTime = 0
		self:handleCollisionTargets()
	end
	
	function state:onExitState(event)
		print("IdleState::onExitState, zombie")
		local zombie = self.entity
		-- zombie:removeEventListener("onZombieHit", self)
	end

	function state:tick(time)
		self.startTime = self.startTime + time
		if self.startTime >= self.THINK_TIME then
			self.startTime = 0
			self:handleCollisionTargets()
		end
	end

	function state:onZombieHit(event)
		self.stateMachine:changeStateToAtNextTick("temporarilyInjured")
	end

	function state:handleCollisionTargets()
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
		else
			line:setColor(255, 0, 0)
			local i
			for i=1,#hits do
				local obj = hits[i].object
				if obj.classType == "PlayerJXL" then
					zombie.targetPlayer = obj
					self.stateMachine:changeStateToAtNextTick("grabPlayer")
					gGrapplerModel:addGrappler(self)
					return true
				end
			end
		end
		
	end

	return state
end

return ReadyState