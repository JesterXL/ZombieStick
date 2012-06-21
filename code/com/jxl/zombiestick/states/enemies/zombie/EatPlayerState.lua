require "com.jxl.core.statemachine.BaseState"
require "com.jxl.zombiestick.constants"
require "com.jxl.zombiestick.vo.injuries.BiteVO"
require "com.jxl.zombiestick.vo.injuries.LacerationVO"

EatPlayerState = {}

function EatPlayerState:new()
	local state 		= BaseState:new("eatPlayer")
	state.MUNCH_TIME 	= 1 * 1000
	state.DAMAGE 		= 1
	state.startTime 	= 0

	function state:onEnterState(event)
		print("EatPlayerState::onEnterState")
		local zombie = self.entity
		self.startTime = self.MUNCH_TIME

		zombie:stopMoving()

		zombie:addEventListener("onZombieHit", self)
		zombie:addEventListener("onTargetPlayerRemoved", self)

		local targetPlayer = zombie.targetPlayer
		if targetPlayer == nil then
			self.stateMachine:changeStateToAtNextTick("idle")
		else
			targetPlayer:addGrappler(zombie)
		end
	end
	
	function state:onExitState(event)
		print("EatPlayerState::onExitState")
		local zombie = self.entity
		zombie:removeEventListener("onZombieHit", self)
		zombie:removeEventListener("onTargetPlayerRemoved", self)
		zombie.targetPlayer:removeGrappler(zombie)
		zombie.targetPlayer = nil
	end

	function state:tick(time)
		self.startTime = self.startTime + time
		if self.startTime >= self.MUNCH_TIME then
			local zombie = self.entity
			local player = zombie.targetPlayer
			if player then
				player:reduceHealth(self.DAMAGE)
				if player:hasInjury(constants.INJURY_BITE) == false then
					-- let's wound that mofo!
					player:addInjury(LacerationVO:new())
				end
				self.startTime = 0
			end
		end
	end

	function state:onZombieHit(event)
		self.stateMachine:changeStateToAtNextTick("temporarilyInjured")
	end

	function state:onTargetPlayerRemoved(event)
		self.startTime = 0
		self.stateMachine:changeStateToAtNextTick("idle")
	end

	return state
end

return EatPlayerState