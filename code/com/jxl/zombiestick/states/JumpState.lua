require "com.jxl.core.statemachine.BaseState"
JumpState = {}

function JumpState:new(stateName)
	if stateName == nil or stateName == "" then
		stateName = "jump"
	end
	local state = BaseState:new(stateName)
	state.player = nil
	state.hitLedge = nil
	state.ledge = nil
	
	function state:onEnterState(event)
		print("JumpState::onEnterState")
		
		self.hitLedge = false
		
		local player = self.entity
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
		self.ledge = nil
		
	end
	
	function state:tick(time)
		local player = self.entity
		if self.hitLedge == false then
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
		else
			local ledge = self.ledge
			player:showSprite("stand")
			print("ledge.exitDirection: ", ledge.exitDirection)
			if ledge.exitDirection == "right" then
				player.x = ledge.x + ledge.width
			else
				player.x = ledge.x - player.width
			end
			player.y = self.ledge.y - player.height
			player.angularVelocity = 0
			player:setLinearVelocity(0, 0)
			self.stateMachine:changeStateToAtNextTick("ready")
		end
	end
	
	function state:collision(event)
		local player = self.entity
		local target = event.other.name
		print("target: ", target)
		if target == "Floor" or target == "Crate" or target == "Table" or target == "Chair" or event.other.classType == "Elevator" then
			player:removeEventListener("collision", self)
			player:showSprite("stand")
			self.stateMachine:changeStateToAtNextTick("ready")
			return true
		elseif event.other.name == "Ledge" then
			self.hitLedge = true
			self.ledge = event.other
			player:removeEventListener("collision", self)
			return true
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