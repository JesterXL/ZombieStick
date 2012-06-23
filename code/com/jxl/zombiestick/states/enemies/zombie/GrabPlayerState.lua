require "com.jxl.core.statemachine.BaseState"
require "com.jxl.zombiestick.constants"
require "com.jxl.zombiestick.vo.injuries.BiteVO"
require "com.jxl.zombiestick.vo.injuries.LacerationVO"

GrabPlayerState = {}

function GrabPlayerState:new()
	local state 		= BaseState:new("grabPlayer")

	function state:onEnterState(event)
		print("GrabPlayerState::onEnterState")
		local zombie = self.entity

		zombie:stopMoving()

		zombie:addEventListener("onZombieHit", self)
		zombie:addEventListener("onTargetPlayerRemoved", self)
		zombie:addEventListener("onZombieGrabDefeated", self)

		local targetPlayer = zombie.targetPlayer
		if targetPlayer == nil then
			self.stateMachine:changeStateToAtNextTick("idle")
		else
			targetPlayer:addGrappler(zombie)
		end
	end
	
	function state:onExitState(event)
		print("GrabPlayerState::onExitState")
		local zombie = self.entity
		zombie:removeEventListener("onZombieHit", self)
		zombie:removeEventListener("onTargetPlayerRemoved", self)
		zombie:removeEventListener("onZombieGrabDefeated", self)

		zombie.targetPlayer:removeGrappler(zombie)
		zombie.targetPlayer = nil
	end

	function state:onZombieHit(event)
		self.stateMachine:changeStateToAtNextTick("temporarilyInjured")
	end

	function state:onZombieGrabDefeated(event)
		self.stateMachine:changeStateToAtNextTick("knockedProne")
	end

	function state:onTargetPlayerRemoved(event)
		self.stateMachine:changeStateToAtNextTick("idle")
	end

	return state
end

return GrabPlayerState