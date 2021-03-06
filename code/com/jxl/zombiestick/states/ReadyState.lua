require "com.jxl.core.statemachine.BaseState"
ReadyState = {}

function ReadyState:new()
	local state = BaseState:new("ready")
	state.recharge = false
	
	function state:onEnterState(event)
		--print("ReadyState::onEnterState")
		local player = self.entity
		player.REST_TIME = 2000
		player.INACTIVE_TIME = 3000
		player.startRestTime = nil
		player.elapsedRestTime = nil
		
		self.recharge = false
		
		self:reset()
		
		player:showSprite("stand")
		
		Runtime:addEventListener("onMoveLeftStarted", self)
		Runtime:addEventListener("onMoveRightStarted", self)
		Runtime:addEventListener("onAttackStarted", self)
		Runtime:addEventListener("onGrappleTargetTouched", self)
		Runtime:addEventListener("onJumpStarted", self)
		Runtime:addEventListener("onJumpLeftStarted", self)
		Runtime:addEventListener("onJumpRightStarted", self)
		Runtime:addEventListener("onHealButtonTouch", self)
	end
	
	function state:onExitState(event)
		--print("ReadyState::onExitState")
		local player = self.entity
		
		Runtime:removeEventListener("onMoveLeftStarted", self)
		Runtime:removeEventListener("onMoveRightStarted", self)
		Runtime:removeEventListener("onAttackStarted", self)
		Runtime:removeEventListener("onGrappleTargetTouched", self)
		Runtime:removeEventListener("onJumpStarted", self)
		Runtime:removeEventListener("onJumpLeftStarted", self)
		Runtime:removeEventListener("onJumpRightStarted", self)
		Runtime:removeEventListener("onHealButtonTouch", self)
	end
	
	function state:tick(time)
		local player = self.entity
		player.elapsedRestTime = player.elapsedRestTime + time
		if player.elapsedRestTime >= player.INACTIVE_TIME then
			--player.fsm:changeState("resting", player)
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
	
	function state:onAttackStarted(event)
		print("ReadyState::onAttackStarted")
		self.stateMachine:changeStateToAtNextTick("attack")
	end
	
	function state:onGrappleTargetTouched(event)
		print("ReadyState::onGrappleTargetTouched")
		self.stateMachine:changeStateToAtNextTick("grapple")
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
	
	function state:onHealButtonTouch(event)
		self.stateMachine:changeStateToAtNextTick("selfHeal")
	end

	return state
end

return ReadyState