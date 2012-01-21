require "com.jxl.core.statemachine.BaseState"
HudControlsJXLState = {}

function HudControlsJXLState:new()

	local state = BaseState:new("HudControlsJXL")
	
	function state:onEnterState(event)
		self.entity:showJXLAttackButton(true)
	end
	
	function state:onExitState(event)
		self.entity:showJXLAttackButton(false)
	end
	
	return state
	
end

return HudControlsJXLState