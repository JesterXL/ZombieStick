require "com.jxl.zombiestick.states.MovingState"

MovingLeftState = {}

function MovingLeftState:new()
	local state = MovingState:new("movingLeft")
	
	state.superOnEnterState = state.onEnterState
	function state:onEnterState(event)
		print("MovingLeftState::onEnterState")
		self:superOnEnterState(event)
		self.player:setDirection("left")
		self.player:showSprite("move")
	end
	
	return state
end

return MovingLeftState