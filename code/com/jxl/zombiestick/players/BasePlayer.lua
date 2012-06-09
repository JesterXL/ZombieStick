require "com.jxl.core.statemachine.StateMachine"

BasePlayer = {}

function BasePlayer:new()
	local player = display.newGroup()
	
	player.spriteHolder = display.newGroup()
	player:insert(player.spriteHolder)
	
	player.lastAttack = nil
	player.ATTACK_INTERVAL = 300
	player.direction = "right"
	player.jumpGravity = -3
	player.lastJump = nil
	player.jumpStartY = nil
	player.JUMP_INTERVAL = 100
	
	-- ready --
	player.REST_TIME = 2000
	player.INACTIVE_TIME = 3000
	player.startRestTime = nil
	player.elapsedRestTime = nil
	player.recharge = false
	
	-- moving --
	player.startMoveTime = nil
	player.MOVE_STAMINA_TIME = 1000
	player.speed = 3
	player.maxSpeed = 3
	player.tiredSpeed = 1
	player.moveStamina = 1
	player.stamina = 10
	player.maxStamina = 10
	
	player.fsm = StateMachine:new(player)
	
	function player:tick(time)
		if self.fsm ~= nil then
			self.fsm:tick(time)
		end
		return true
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
		if self.stamina <= 1 then
			self:setSpeed(self.tiredSpeed)
		else
			self:setSpeed(self.maxSpeed)
		end
		Runtime:dispatchEvent({name="onPlayerStaminaChanged", target=self, maxStamina = self.maxStamina, oldValue=oldValue, value=value})
	end
	
	function player:setSpeed(value)
		assert(value ~= nil, "You cannot set speed to a nil value.")
		self.speed = value
	end
	
	return player
end

return BasePlayer