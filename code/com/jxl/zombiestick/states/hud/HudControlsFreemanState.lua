require "com.jxl.core.statemachine.BaseState"

HudControlsFreemanState = {}

function HudControlsFreemanState:new()
	print("HudControlsFreemanState::new")
	
	local state = BaseState:new("HudControlsFreeman")
	
	function state:onEnterState(event)
		print("HudControlsFreemanState::onEnterState")
		self.entity:showFreemanAttackButton(true)
		
		Runtime:addEventListener("onFreemanSelectedWeaponChanged", self)
	end
	
	function state:onExitState(event)
		print("HudControlsFreemanState::onExitState")
		self.entity:showFreemanAttackButton(false)
		Runtime:removeEventListener("onFreemanSelectedWeaponChanged", self)
	end
	
	function state:onFreemanSelectedWeaponChanged(event)
		print("HudControlsFreemanState::onFreemanSelectedWeaponChanged")
		self.entity:setFreemanWeapon(event.target.selectedWeapon)
	end
	
	return state
	
end

return HudControlsFreemanState