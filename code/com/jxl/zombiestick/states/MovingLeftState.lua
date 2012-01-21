require "com.jxl.zombiestick.states.MovingState"

MovingLeftState = {}

function MovingLeftState:new()
	local state = MovingState:new("movingLeft")
	
	state.superOnEnterState = state.onEnterState
	function state:onEnterState(event)
		print("MovingLeftState::onEnterState")
		self:superOnEnterState(event)
		self.entity:setDirection("left")
		self.entity:showSprite("move")
	end
	
	return state
end

return MovingLeftState