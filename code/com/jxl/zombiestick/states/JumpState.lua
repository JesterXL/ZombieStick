require "com.jxl.core.statemachine.BaseState"
JumpState = {}

function JumpState:new(stateName)
	if stateName == nil or stateName == "" then
		stateName = "jump"
	end
	local state = BaseState:new(stateName)
	state.player = nil
	
	function state:onEnterState(event)
		print("JumpState::onEnterState")
		local player = event.entity
		self.player = player
		player.jumping = true
		player:showSprite("jump")
		player:performedAction("jump")
		--self:addEventListener("collision", player.onJumpCollision)
		--self:applyLinearImpulse(0, self.jumpForce, 40, 32)
		player.jumpGravity = -4
		player.jumpStartY = player.y
		player.lastJump = system.getTimer()
		
		Runtime:addEventListener("onMoveLeftStarted", self)
		Runtime:addEventListener("onMoveRightStarted", self)
	end
	
	function state:onExitState(event)
		print("JumpState::onEnterState")
		
		Runtime:removeEventListener("onMoveLeftStarted", self)
		Runtime:removeEventListener("onMoveRightStarted", self)
		
		self.player.jumping = false
	end
	
	function state:tick(time)
		local player = self.entity
		
		player.y = player.y + player.jumpGravity
		if system.getTimer() - player.lastJump >= player.JUMP_INTERVAL then
			-- [jwarden 1.2.2012] NOTE: this needs to ease based on time
			player.jumpGravity = player.jumpGravity + .1
			if player.jumpStartY - player.y >= 45 then player.jumpGravity = 0 end
			if player.jumpGravity > 9.8 then player.jumpGravity = 9.8 end
			if player.jumpGravity > 0 then
				player:addEventListener("collision", self)
			end
		end
		
		--if self.jumpHeightCheck == false and self.jumpStartY - self.y >= 40 then
		--	self.jumpHeightCheck = true
		--	player:addEventListener("collision", self)
		--end
	end
	
	function state:collision(event)
		if event.other.name == "Floor" then
			local player = self.entity
			player:removeEventListener("collision", self)
			player:showSprite("stand")
			self.stateMachine:changeStateToAtNextTick("ready")
		end
	end
	
	function state:onMoveLeftStarted(event)
		self.entity:setDirection("left")
	end
	
	function state:onMoveRightStarted(event)
		self.entity:setDirection("right")
	end
	
	return state
end

return JumpState