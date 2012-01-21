require "com.jxl.core.statemachine.BaseState"

HudControlsFreemanState = {}

function HudControlsFreemanState:new()

	local state = BaseState:new("HudControlsFreeman")
	
	function state:onEnterState(event)
		self.entity:showFreemanAttackButton(true)
	end
	
	function state:onExitState(event)
		self.entity:showFreemanAttackButton(false)
	end
	
	return state
	
end

return HudControlsFreemanState