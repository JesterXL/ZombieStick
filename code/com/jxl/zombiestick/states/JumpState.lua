require "com.jxl.core.statemachine.BaseState"
JumpState = {}

function JumpState:new()
	local state = BaseState:new("jump")
	state.player = nil
	
	function state:onEnterState(event)
		print("JumpState::onEnterState")
		local player = event.data[1]
		self.player = player
		
		player:addEventListener("onJumpCompleted", self)
		player:showSprite("jump")
		--player:performedAction("jump")
		--self:addEventListener("collision", player.onJumpCollision)
		--self:applyLinearImpulse(0, self.jumpForce, 40, 32)
		player.jumpGravity = -4
		player.jumpStartY = player.y
		player.lastJump = system.getTimer()
	end
	
	function state:onExitState(event)
		print("JumpState::onEnterState")
		
		local player = self.player
		player:removeEventListener("onJumpCompleted", self)
		player:removeEventListener("collision", self.onJumpCollision)
		self.player = nil
	end
	
	function state:tick(time)
		local player = self.player
		
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
	end
	
	function state.onJumpCollision(event)
		local self = state
		local player = self.player
		local anime = player.sprite
		if event.phase == "began" and anime.currentFrame <= 4 then
			anime.currentFrame = 5
			anime:play()
			player:removeEventListener("collision", self.onJumpCollision)
		end
	end
	
	function state:onJumpCompleted(event)
		if event.phase == "end" then
			if event.target.currentFrame ~= 6 then
				print("What the hell")
			end
			local player = event.target
			--event.target:removeEventListener("sprite", player.onJumpCompleted)
			--self:showSprite("stand")
			--self.jumping = false
			--self:dispatchEvent({name="onJumpCompleted", target=self})
		else
			if event.target.currentFrame == 4 then
				event.target:pause()
			end
		end
	end
	
	
	return state
end

return JumpState