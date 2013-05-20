require "utils.BaseState"
RestState = {}

function RestState:new()
	local state = BaseState:new("resting")
	
	function state:onEnterState(event)
		--print("RestingState::onEnterState")
		local player = self.entity
		player.oldRestTime = player.REST_TIME
		player.REST_TIME = 200
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
		--print("RestingState::onExitState")
		local player = self.entity
		player.REST_TIME = player.oldRestTime
		
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
		if player.elapsedRestTime >= player.REST_TIME then
			player:rechargeStamina()
			player:rechargeHealth()
			self:reset()
		end
	end
	
	function state:reset()
		local player = self.entity
		player.startRestTime = system.getTimer()
		player.elapsedRestTime = 0
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

return RestState