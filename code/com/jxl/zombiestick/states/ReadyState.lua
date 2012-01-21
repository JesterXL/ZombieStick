require "com.jxl.core.statemachine.BaseState"
ReadyState = {}

function ReadyState:new()
	local state = BaseState:new("ready")
	
	function state:onEnterState(event)
		print("ReadyState::onEnterState")
		local player = self.player
		player.REST_TIME = 2000
		player.INACTIVE_TIME = 3000
		player.startRestTime = nil
		player.elapsedRestTime = nil
		player.recharge = false
		
		self:reset()
		
		player:showSprite("stand")
		
		Runtime:addEventListener("onMoveLeftStarted", self)
		Runtime:addEventListener("onMoveRightStarted", self)
		Runtime:addEventListener("onAttackStarted", self)
		Runtime:addEventListener("onJumpStarted", self)
		Runtime:addEventListener("onJumpLeftStarted", self)
		Runtime:addEventListener("onJumpRightStarted", self)
	end
	
	function state:onExitState(event)
		print("ReadyState::onExitState")
		
		Runtime:removeEventListener("onMoveLeftStarted", self)
		Runtime:removeEventListener("onMoveRightStarted", self)
		Runtime:removeEventListener("onAttackStarted", self)
		Runtime:removeEventListener("onJumpStarted", self)
		Runtime:removeEventListener("onJumpLeftStarted", self)
		Runtime:removeEventListener("onJumpRightStarted", self)
	end
	
	function state:tick(time)
		local player = self.player
		player.elapsedRestTime = player.elapsedRestTime + time
		if player.elapsedRestTime >= player.INACTIVE_TIME then
			--player.fsm:changeState("resting", player)
			self.stateMachine:changeStateToAtNextTick("resting")
		elseif player.elapsedRestTime >= player.REST_TIME and player.recharge == false then
			player.recharge = true
			player:rechargeStamina()
		end
	end
	
	function state:reset()
		local player = self.player
		player.startRestTime = system.getTimer()
		player.elapsedRestTime = 0
		player.recharge = false
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

return ReadyState