require "com.jxl.core.statemachine.BaseState"

IdleState = {}

function IdleState:new()
	local state = BaseState:new("idle")
	state.THINK_TIME = 500
	state.startTime = nil

	function state:onEnterState(event)
		print("IdleState::onEnterState")
		local zombie = self.entity
		zombie:startMoving()
		--player.angularVelocity = 0
		state.startTime = 0
		self:handleCollisionTargets()
	end
	
	function state:onExitState(event)
		print("IdleState::onExitState")
		local player = self.entity
	end

	function state:tick(time)
		self.startTime = self.startTime + time
		if self.startTime >= self.THINK_TIME then
			self.startTime = 0
			self:handleCollisionTargets()
		end
	end

	function state:handleCollisionTargets()
		local zombie = self.entity
		local targets = zombie.collisionTargets
		if targets ~= nil and #targets > 0 then
			local first = targets[1]
			zombie.targetPlayer = first
			self.stateMachine:changeStateToAtNextTick("eatPlayer")
		end
	end

	return state
end

return IdleState