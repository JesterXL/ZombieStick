require "com.jxl.core.statemachine.BaseState"
IdleState = {}

function IdleState:new()
	local state = BaseState:new("idle")
	
	function state:onEnterState(event)
		
	end
	
	function state:onExitState(event)
		
	end

	return state
end

return IdleState