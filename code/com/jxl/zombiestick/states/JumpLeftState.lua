require "com.jxl.zombiestick.states.JumpState"

JumpLeftState = {}

function JumpLeftState:new()
	local state = JumpState:new("jumpLeft")
	state.xForce = nil
	
	state.superOnEnterState = state.onEnterState
	function state:onEnterState(event)
		print("JumpLeftState::onEnterState")
		self:superOnEnterState(event)
		
		local player = self.entity
		player:setDirection("left")
		self.xForce = -player.jumpForwardForce
		--local multiplier = 60
		--player:applyForce(xForce* multiplier, self.jumpForce * multiplier, 40, 32)
	end
	
	state.superOnExitState = state.onExitState
	function state:onExitState(event)
		local player = self.entity
		player:applyLinearImpulse(self.xForce / 3, 0, 40, 32)
		self:superOnExitState(event)
	end
	
	state.superTick = state.tick
	function state:tick(time)
		local player = self.entity
		player.x = player.x + self.xForce
		self:superTick(time)
	end
	
	return state
	
end

return JumpLeftState