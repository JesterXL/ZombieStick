require "com.jxl.core.statemachine.BaseState"

IdleState = {}

function IdleState:new()
	local state = BaseState:new("idle")
	state.THINK_TIME = 500
	state.startTime = nil

	function state:onEnterState(event)
		print("IdleState::onEnterState, zombie")
		local zombie = self.entity
		zombie:addEventListener("onZombieHit", self)
		zombie:startMoving()
		--player.angularVelocity = 0
		state.startTime = 0
		self:handleCollisionTargets()
	end
	
	function state:onExitState(event)
		print("IdleState::onExitState, zombie")
		local zombie = self.entity
		zombie:removeEventListener("onZombieHit", self)
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
		local targets = zombie.collisionTargets
		if targets ~= nil and #targets > 0 then
			local first = targets[1]
			zombie.targetPlayer = first
			--self.stateMachine:changeStateToAtNextTick("eatPlayer")
			self.stateMachine:changeStateToAtNextTick("grabPlayer")
		end
	end

	return state
end

return IdleState