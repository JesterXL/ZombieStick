require "com.jxl.core.statemachine.BaseState"
IdleState = {}

function IdleState:new()
	local state = BaseState:new("idle")
	
	function state:onEnterState(event)
		local player = self.entity
		--player.angularVelocity = 0

		Runtime:addEventListener("onZombieHit", self)
	end
	
	function state:onExitState(event)
		Runtime:removeEventListener("onZombieHit", self)
	end

	function state:onZombieHit(event)
		if event.zombie == self.entity then
			self.entity:applyDamage(event.damage)
			self.stateMachine:changeStateToAtNextTick("temporarilyInjured")
		end
	end

	return state
end

return IdleState