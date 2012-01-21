require "com.jxl.zombiestick.states.MovingState"

MovingRightState = {}

function MovingRightState:new()
	local state = MovingState:new("movingRight")
	
	state.superOnEnterState = state.onEnterState
	function state:onEnterState(event)
		print("MovingRightState::onEnterState")
		self:superOnEnterState(event)
		self.entity:setDirection("right")
		self.entity:showSprite("move")
	end
	
	return state
end

return MovingRightState