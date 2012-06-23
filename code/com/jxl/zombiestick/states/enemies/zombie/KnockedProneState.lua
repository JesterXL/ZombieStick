require "com.jxl.core.statemachine.BaseState"
KnockedProneState = {}

function KnockedProneState:new()
	local state = BaseState:new("knockedProne")
	state.startTime = 0
	state.TIMEOUT = nil
	state.standingUp = nil

	function state:onEnterState(event)
		local zombie = self.entity
		zombie:stopMoving()
		zombie:fallDown()

		state.TIMEOUT = 5 * 1000
		state.startTime = 0
		state.standingUp = false

		zombie:addEventListener("onZombieHit", self)
	end
	
	function state:onExitState(event)
		local zombie = self.entity
		zombie:removeEventListener("onZombieHit", self)
		zombie:startMoving()
	end

	function state:tick(time)
		self.startTime = self.startTime + time
		if self.startTime >= self.TIMEOUT then
			if state.standingUp == false then
				state.standingUp = true
				self.startTime = 0
				self.entity:standUp()
				self.TIMEOUT = 300
			elseif state.standingUp == true then
				self.stateMachine:changeStateToAtNextTick("idle")
			end
		end
	end

	function state:onZombieHit(event)
		self.startTime = 0
	end

	return state
end

return KnockedProneState