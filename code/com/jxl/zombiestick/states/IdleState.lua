require "com.jxl.core.statemachine.BaseState"
IdleState = {}

function IdleState:new()
	local state = BaseState:new("idle")
	
	function state:onEnterState(event)
		local player = self.entity
		player.angularVelocity = 0
	end
	
	function state:onExitState(event)
		
	end

	return state
end

return IdleState