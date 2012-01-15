require "com.jxl.core.statemachine.BaseState"

JXLAttackState = {}

function JXLAttackState:new()
	
	local state = BaseState:new("attack")
	state.player = nil
	
	function state:onEnterState(event)
		print("JumpState::onEnterState")
		local player = event.entity
		self.player = player
		
		--[[
		player:addEventListener("onJumpCompleted", self)
		player:showSprite("jump")
		--player:performedAction("jump")
		--self:addEventListener("collision", player.onJumpCollision)
		--self:applyLinearImpulse(0, self.jumpForce, 40, 32)
		player.jumpGravity = -4
		player.jumpStartY = player.y
		player.lastJump = system.getTimer()
		]]--
		
		self:showSprite("jump")
		self:performedAction("jump")
		self:applyLinearImpulse(0, self.jumpForce, 40, 32)
		self.jumpGravity = -4
		self.jumpStartY = self.y
		self.lastJump = system.getTimer()
		self.jumpHeightCheck = false
	end
	
	function state:onExitState(event)
		print("JumpState::onEnterState")
		
		local player = self.player
		--player:removeEventListener("onJumpCompleted", self)
		--player:removeEventListener("collision", self.onJumpCollision)
		self.player = nil
	end
	
	function state:tick(time)
		local player = self.player
		--[[
		player.y = player.y + player.jumpGravity
		if system.getTimer() - player.lastJump >= player.JUMP_INTERVAL then
			-- [jwarden 1.2.2012] NOTE: this needs to ease based on time
			player.jumpGravity = player.jumpGravity + .1
			if player.jumpStartY - player.y >= 45 then player.jumpGravity = 0 end
			if player.jumpGravity > 9.8 then player.jumpGravity = 9.8 end
			if player.jumpGravity > 0 then
				player:addEventListener("collision", self.onJumpCollision)
			end
		end
		]]--
		if self.jumpHeightCheck == false and self.jumpStartY - self.y >= 40 then
			self.jumpHeightCheck = true
			self:addEventListener("collision", self)
		end
	end
	
	function player:collision(event)
		if event.other.name == "Floor" then
			local player = self.player
			self:removeEventListener("collision", self)
			player:showSprite("stand")
			--self.jumping = false
			player:dispatchEvent({name="onJumpCompleted", target=self})
		end
	end
	
	
	return state
	
end

return JXLAttackState