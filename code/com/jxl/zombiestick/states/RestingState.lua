require "com.jxl.core.statemachine.BaseState"
RestingState = {}

function RestingState:new()
	local state = BaseState:new("resting")
	
	function state:onEnterState(event)
		print("RestingState::onEnterState")
		local player = self.entity
		player.oldRestTime = player.REST_TIME
		player.REST_TIME = 200
		self:reset()
		
		Runtime:addEventListener("onMoveLeftStarted", self)
		Runtime:addEventListener("onMoveRightStarted", self)
		Runtime:addEventListener("onAttackStarted", self)
		Runtime:addEventListener("onJumpStarted", self)
		Runtime:addEventListener("onJumpLeftStarted", self)
		Runtime:addEventListener("onJumpRightStarted", self)
	end
	
	function state:onExitState(event)
		print("RestingState::onExitState")
		local player = self.entity
		player.REST_TIME = player.oldRestTime
		
		Runtime:removeEventListener("onMoveLeftStarted", self)
		Runtime:removeEventListener("onMoveRightStarted", self)
		Runtime:removeEventListener("onAttackStarted", self)
		Runtime:removeEventListener("onJumpStarted", self)
		Runtime:removeEventListener("onJumpLeftStarted", self)
		Runtime:removeEventListener("onJumpRightStarted", self)
	end
	
	function state:tick(time)
		local player = self.entity
		local vx, vy = player:getLinearVelocity()
		local speed = 5
		if player.isFixedRotation == false and vx <= speed and vy <= speed then
			local originalPos = {x = player.x, y = player.y}
			player.rotation = 0
			player.isFixedRotation = true
			player.y = originalPos.y - player.height
		end
		player.elapsedRestTime = player.elapsedRestTime + time
		--print("elapsed rest time: ", player.elapsedRestTime)
		if player.elapsedRestTime >= player.REST_TIME then
			player:rechargeStamina()
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
	
	function state:onAttackStarted(event)
		self.stateMachine:changeStateToAtNextTick("attack")
	end
	
	function state:onJumpStarted(event)
		self.stateMachine:changeStateToAtNextTick("jump")
	end
	
	function state:onJumpLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpLeft")
	end
	
	function state:onJumpRightStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpRight")
	end
	
	return state
end

return RestingState