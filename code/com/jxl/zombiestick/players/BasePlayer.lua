require "com.jxl.core.statemachine.StateMachine"
require "com.jxl.zombiestick.gamegui.StaminaBar"

BasePlayer = {}

function BasePlayer:new()
	local player = display.newGroup()
	
	player.spriteHolder = display.newGroup()
	player:insert(player.spriteHolder)
	player.staminaBar = StaminaBar:new()
	player:insert(player.staminaBar)
	
	player.lastAttack = nil
	player.ATTACK_INTERVAL = 300
	player.direction = "right"
	player.jumpGravity = -3
	player.lastJump = nil
	player.jumpStartY = nil
	player.JUMP_INTERVAL = 100
	
	-- moved from states
	
	-- ready --
	player.REST_TIME = 2000
	player.INACTIVE_TIME = 3000
	player.startRestTime = nil
	player.elapsedRestTime = nil
	player.recharge = false
	
	-- resting --
	--state.REST_TIME = 500
	--state.startTime = nil
	--state.elapsedTime = nil
	
	-- moving --
	player.startMoveTime = nil
	player.MOVE_STAMINA_TIME = 1000
	player.speed = 3
	player.maxSpeed = 3
	player.tiredSpeed = 1
	player.moveStamina = 1
	
	
	
	--
	
	player.fsm = StateMachine:new(player)
	
	function player:tick(time)
		if self.fsm ~= nil then
			self.fsm:tick(time)
		end
		return true
		--[[
		if self.moving == true then
			self:handleMove(time)
			if system.getTimer() - self.startMoveTime >= self.MOVE_STAMINA_TIME then
				self:reduceStamina(self.moveStamina)
				self.startMoveTime = system.getTimer()
			end
		elseif self.attacking == true then
			if system.getTimer() - self.lastAttack >= self.ATTACK_INTERVAL then
				self:onAttackComplete()
			end
		elseif self.jumping == true then
			self.y = self.y + self.jumpGravity
			if system.getTimer() - self.lastJump >= self.JUMP_INTERVAL then
				-- [jwarden 1.2.2012] NOTE: this needs to ease based on time
				self.jumpGravity = self.jumpGravity + .1
				if self.jumpStartY - self.y >= 45 then self.jumpGravity = 0 end
				if self.jumpGravity > 9.8 then self.jumpGravity = 9.8 end
				if self.jumpGravity > 0 then
					self:addEventListener("collision", player.onJumpCollision)
				end
			end
		end
		]]--	
		
	end
	
	function player:handleMove(time)
		local speed = self.speed
		local targetX
		local targetY = self.y
		if self.direction == "right" then
			targetX = self.x + speed
		elseif self.direction == "left" then
			targetX = self.x - speed
		else
			targetX = 0
		end

		local deltaX = self.x - targetX
		local deltaY = self.y - targetY
		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
		local moveX = speed * (deltaX / dist) * time
		local moveY = speed * (deltaY / dist) * time

		if (math.abs(moveX) > dist or math.abs(moveY) > dist) then
			self.x = targetX
			self.y = targetY
		else
			self.x = self.x - moveX
			self.y = self.y - moveY
		end
	end
	
	function player:setDirection(dir)
		self.direction = dir
		assert(self.direction ~= nil, "You cannot set direction to a nil value.")
		local spriteHolder = player.spriteHolder
		if dir == "right" then
			spriteHolder.xScale = 1
			spriteHolder.x = 0
		else
			spriteHolder.xScale = -1
			spriteHolder.x = spriteHolder.width
		end
	end
	
	--[[
	function player:moveRight()
		--print("moveRight: ", self.jumping)
		if self.attacking == false and self.jumping == false then
			self:setDirection("right")
			self:showSprite("move")
			self:performedAction("move")
			self:startMoving()
			return true
		end
	end
	
	function player:moveLeft()
		--print("moveLeft: ", self.jumping)
		if self.attacking == false and self.jumping == false then
			self:setDirection("left")
			self:showSprite("move")
			self:performedAction("move")
			self:startMoving()
			return true
		end
	end
	]]--
	
	--[[
	function player:stand()
		if self.attacking == false and self.jumping == false then
			self:stopMoving()
			self:showSprite("stand")
		end
	end
	]]--
	
	--[[
	function player:attack()
		if self:canAttack() == false then return false end
		
		self.attacking = true
		self:showSprite("attack")
		self.lastAttack = system.getTimer()
		self:performedAction("attack")
		return true
	end
	]]--
	
	function player:canAttack()
		if self.attacking == true then return false end
		if self.jumping == true then return false end
		if self.stamina == 0 then return false end
		if self.stamina - self.attackStamina >= 0 then return true end
		return true
	end
	
	function player:onAttackComplete(event)
		self:showSprite("stand")
		self.attacking = false
	end
	
	function player:startMoving()
		if self.moving == false and self.jumping == false then
			self.moving = true
			self.startMoveTime = system.getTimer()
		end
	end
	
	function player:stopMoving()
		self.moving = false
		local force
		if self.direction == "right" then
			force = self.speed
		else
			force = -self.speed
		end
		self:applyLinearImpulse(force / 3, 0, 40, 32)
		self:dispatchEvent({name="onMoveCompleted", target=self})
	end
	
	function player:canJump()
		local score = 0
		local min = 4
		if self.attacking == false then score = score + 1 end
		if self.moving == false then score = score + 1 end
		if self.jumping == false then score = score + 1 end
		if self.stamina >= self.jumpStamina then score = score + 1 end
		
		if score >= min then
			return true
		else
			return false
		end
	end
	
	-- moved to JumpState
	--[[
	function player:jump()
		if self:canJump() == false then return false end
		
		self.jumping = true
		self:showSprite("jump")
		self:performedAction("jump")
		--self:addEventListener("collision", player.onJumpCollision)
		--self:applyLinearImpulse(0, self.jumpForce, 40, 32)
		self.jumpGravity = -4
		self.jumpStartY = self.y
		self.lastJump = system.getTimer()
	end
	]]--
	
	--[[
	function player:jumpForward()
		if self:canJump() == false then return false end
		
		self.jumping = true
		self:showSprite("jump")
		self:performedAction("jump")
		
		local xForce
		if self.direction == "right" then
			xForce = self.jumpForwardForce
		else
			xForce = -self.jumpForwardForce
		end
		
		self:addEventListener("collision", player.onJumpCollision)
		local multiplier = 60
		self:applyForce(xForce* multiplier, self.jumpForce * multiplier, 40, 32)
	end
	]]--
	
	-- moved to JumpState
	--[[
	function player.onJumpCollision(event)
		local self = player
		local anime = self.sprite
		if event.phase == "began" and anime.currentFrame <= 4 then
			anime.currentFrame = 5
			anime:play()
			self:removeEventListener("collision", player.onJumpCollision)
		end
	end
	]]--
	
	-- called from subclass
	-- moved to JumpState
	--[[
	function player.onJumpCompleted(event)
		if event.phase == "end" then
			if event.target.currentFrame ~= 6 then
				print("What the hell")
			end
			local self = player
			event.target:removeEventListener("sprite", player.onJumpCompleted)
			self:showSprite("stand")
			self.jumping = false
			self:dispatchEvent({name="onJumpCompleted", target=self})
		else
			if event.target.currentFrame == 4 then
				event.target:pause()
			end
		end
	end
	]]--
	
	function player:performedAction(actionType)
		if actionType == "attack" then
			self:reduceStamina(self.attackStamina)
		elseif actionType == "jump" then
			self:reduceStamina(self.jumpStamina)
		end
		self:dispatchEvent({name="onPerformedAction", target=self, action=actionType})
	end
	
	function player:reduceStamina(amount)
		assert(amount ~= nil, "Error: BasePlayer::reduceStamina, You cannot pass a nil amount.")
		self:setStamina(self.stamina - amount)
		if self.stamina < 0 then
			self:setStamina(0)
			print("Warning, someone is writing checks he can't cash.")
		end
	end
	
	function player:rechargeStamina()
		if self.stamina ~= self.maxStamina then
			self:setStamina(self.stamina + 1)
		end
	end
	
	function player:setStamina(value)
		self.stamina = value
		self.staminaBar:setStamina(value, self.maxStamina)
		if self.stamina <= 1 then
			self:setSpeed(self.tiredSpeed)
		else
			self:setSpeed(self.maxSpeed)
		end
	end
	
	function player:setSpeed(value)
		assert(value ~= nil, "You cannot set speed to a nil value.")
		self.speed = value
	end
	
	return player
end

return BasePlayer