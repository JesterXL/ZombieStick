require "utils.BaseState"

IdleState = {}

function IdleState:new()
	local state = BaseState:new("idle")

	function state:onEnterState(event)
		print("IdleState::onEnterState, zombie")
		local zombie = self.entity
	end
	
	function state:onExitState(event)
		print("IdleState::onExitState, zombie")
	end

	return state
end

return IdleState