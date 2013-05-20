require "utils.BaseState"

ReadyState = {}

function ReadyState:new()
	local state = BaseState:new("ready")
	state.recharge = nil
	
	function state:onEnterState(event)
		print("ReadyState::onEnterState")
		local player = self.entity

		player.REST_TIME = 2000
		player.INACTIVE_TIME = 10 * 1000
		player.startRestTime = nil
		player.elapsedRestTime = nil
		
		self.recharge = false

		player:showSprite("stand")

		self:reset()

		Runtime:addEventListener("onMoveLeftStarted", self)
		Runtime:addEventListener("onMoveRightStarted", self)
		Runtime:addEventListener("onJumpStarted", self)
		Runtime:addEventListener("onJumpRightStarted", self)
		Runtime:addEventListener("onJumpLeftStarted", self)
		Runtime:addEventListener("onClimbUpStarted", self)
		Runtime:addEventListener("onClimbDownStarted", self)
		Runtime:addEventListener("onAttackStarted", self)
	end
	
	function state:onExitState(event)
		local player = self.entity
		Runtime:removeEventListener("onMoveLeftStarted", self)
		Runtime:removeEventListener("onMoveRightStarted", self)
		Runtime:removeEventListener("onJumpStarted", self)
		Runtime:removeEventListener("onJumpRightStarted", self)
		Runtime:removeEventListener("onJumpLeftStarted", self)
		Runtime:removeEventListener("onClimbUpStarted", self)
		Runtime:removeEventListener("onClimbDownStarted", self)
		Runtime:removeEventListener("onAttackStarted", self)
	end

	function state:tick(time)
		local player = self.entity
		player.elapsedRestTime = player.elapsedRestTime + time
		if player.elapsedRestTime >= player.INACTIVE_TIME then
			self.stateMachine:changeStateToAtNextTick("resting")
		elseif player.elapsedRestTime >= player.REST_TIME and self.recharge == false then
			self.recharge = true
			player:rechargeStamina()
			player:rechargeHealth()
		end
	end
	
	function state:reset()
		local player = self.entity
		player.startRestTime = system.getTimer()
		player.elapsedRestTime = 0
		self.recharge = false
	end

	function state:onMoveLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("movingLeft")
	end
	
	function state:onMoveRightStarted(event)
		self.stateMachine:changeStateToAtNextTick("movingRight")
	end

	function state:onJumpStarted(event)
		self.stateMachine:changeStateToAtNextTick("jump")
	end

	function state:onJumpRightStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpRight")
	end

	function state:onJumpLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpLeft")
	end

	function state:onClimbUpStarted(event)
		self.entity.climbDirection = "up"
		self.stateMachine:changeStateToAtNextTick("climbLadder")
	end

	function state:onClimbDownStarted(event)
		self.entity.climbDirection = "down"
		self.stateMachine:changeStateToAtNextTick("climbLadder")
	end

	function state:onAttackStarted(event)
		self.stateMachine:changeStateToAtNextTick("attack")
	end

	return state
end

return ReadyState