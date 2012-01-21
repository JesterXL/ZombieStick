require "com.jxl.core.statemachine.BaseState"
HudControlsJXLState = {}

function HudControlsJXLState:new()

	local state = BaseState:new("HudControlsJXL")
	
	function state:onEnterState(event)
		print("HudControlsJXLState::onEnterState")
		self.entity:showJXLAttackButton(true)
	end
	
	function state:onExitState(event)
		print("HudControlsJXLState::onExitState")
		self.entity:showJXLAttackButton(false)
	end
	
	return state
	
end

return HudControlsJXLState