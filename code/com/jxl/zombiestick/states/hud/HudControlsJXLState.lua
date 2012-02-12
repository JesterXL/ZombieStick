require "com.jxl.core.statemachine.BaseState"
HudControlsJXLState = {}

function HudControlsJXLState:new()

	local state = BaseState:new("HudControlsJXL")
	
	function state:onEnterState(event)
		print("HudControlsJXLState::onEnterState")
		self.entity:showJXLAttackButton(true)
		Runtime:addEventListener("onDoorCollision", self)
	end
	
	function state:onExitState(event)
		print("HudControlsJXLState::onExitState")
		self.entity:showJXLAttackButton(false)
		Runtime:removeEventListener("onDoorCollision", self)
	end
	
	function state:onDoorCollision(event)
		if event.phase == "began" then
			self.entity:showDoorButton(true, event.target.name, event.target.targetDoor)
		else
			self.entity:showDoorButton(false)
		end
	end
	
	return state
	
end

return HudControlsJXLState