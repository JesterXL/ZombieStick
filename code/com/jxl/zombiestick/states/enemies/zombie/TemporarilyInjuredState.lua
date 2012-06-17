require "com.jxl.core.statemachine.BaseState"
TemporarilyInjuredState = {}

function TemporarilyInjuredState:new()
	local state = BaseState:new("temporarilyInjured")
	state.startTime = 0
	state.TIMEOUT = 1 * 1000

	function state:onEnterState(event)
		local zombie = self.entity
		zombie:stopMoving()
		state.startTime = 0
		zombie:addEventListener("onZombieHit", self)
	end
	
	function state:onExitState(event)
		local zombie = self.entity
		zombie:removeEventListener("onZombieHit", self)
	end

	function state:tick(time)
		self.startTime = self.startTime + time
		if self.startTime >= self.TIMEOUT then
			self.stateMachine:changeStateToAtNextTick("idle")
			self.startTime = 0
		end
	end

	function state:onZombieHit(event)
		self.startTime = 0
	end

	return state
end

return TemporarilyInjuredState