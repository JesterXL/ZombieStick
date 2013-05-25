require "utils.BaseState"
StunnedState = {}

function StunnedState:new()
	local state = BaseState:new("stunned")
	state.startTime = 0
	state.TIMEOUT = 4 * 1000

	function state:onEnterState(event)
		local zombie = self.entity
		-- zombie:stopMoving()
		state.startTime = 0
	end
	
	function state:onExitState(event)
		local zombie = self.entity
	end

	function state:tick(time)
		self.startTime = self.startTime + time
		if self.startTime >= self.TIMEOUT then
			self.stateMachine:changeStateToAtNextTick("ready")
			self.startTime = 0
		end
	end

	return state
end

return StunnedState