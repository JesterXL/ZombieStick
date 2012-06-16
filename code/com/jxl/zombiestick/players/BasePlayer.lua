require "com.jxl.core.statemachine.StateMachine"
require "com.jxl.zombiestick.constants"

BasePlayer = {}

function BasePlayer:new()
	local player = display.newGroup()
	
	--player.classType = "BasePlayer"

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
	
	-- moving --
	player.startMoveTime = nil
	player.MOVE_STAMINA_TIME = 1000
	player.speed = 3
	player.maxSpeed = 3
	player.tiredSpeed = 1
	player.moveStamina = 1
	player.stamina = 10
	player.maxStamina = 10
	player.health = 10
	player.maxHealth = 10

	player.staminaTextPool = {}
	player.healthTextPool = {}
	player.injuries = {}
	
	function player:init()
		self.fsm = StateMachine:new(self)
	end
	
	
	function player:tick(time)

		local injuries = self.injuries
		if injuries and #injuries > 0 then
			local i = 1
			while injuries[i] do
				local vo = injuries[i]
				local destroyIt = false
				vo.currentTime = vo.currentTime + time
				vo.totalTimeAlive = vo.totalTimeAlive + time
				if vo.currentTime >= vo.applyInterval then
					if vo.liveForever == false and vo.totalTimeAlive >= vo.lifetime then
						destroyIt = true
					end

					-- time's up, time to apply the injury
					vo.currentTime = 0
					-- for now we use a switch statement
					local injuryType = vo.injuryType
					if injuryType == constants.INJURY_BITE then
						self:setHealth(self.health + vo.amount)
					end
				end
				if destroyIt == true then
					table.remove(injuries, vo)
				else
					i = i + 1
				end
			end
		end

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
		local oldValue = self.stamina
		self.stamina = value
		if self.stamina <= 1 then
			self:setSpeed(self.tiredSpeed)
		else
			self:setSpeed(self.maxSpeed)
		end

		local difference = value - oldValue
		self:showStaminaText(25, 0, difference)

		Runtime:dispatchEvent({name="onPlayerStaminaChanged", target=self, maxStamina = self.maxStamina, oldValue=oldValue, value=value})
	end

	function player:reduceHealth(amount)
		assert(amount ~= nil, "Error: BasePlayer::reduceHealth, You cannot pass a nil amount.")
		self:setHealth(self.health - amount)
	end

	function player:rechargeHealth()
		local injuries = self.injuries
		if #injuries > 0 then return false end
		
		if self.health ~= self.maxHealth then
			self:setHealth(self.health + 1)
		end
	end

	function player:setHealth(value)
		assert(value ~= nil, "Error: BasePlayer::setHealth, you cannot pass a nil amount.")
		local oldValue = self.health
		self.health = value
		if self.health < 0 then
			self.health = 0
		end
		-- TODO: put uber slow speeds here if hurt AND/OR tired

		local difference = value - oldValue
		self:showHealthText(25, 0, difference)

		Runtime:dispatchEvent({name="onPlayerHealthChanged", target=self, maxHealth = self.maxHealth, oldValue = oldValue, value=value})
	end
	
	function player:setSpeed(value)
		assert(value ~= nil, "You cannot set speed to a nil value.")
		self.speed = value
	end

	function player:showStaminaText(targetX, targetY, amount)
		local field
		if table.maxn(self.staminaTextPool) > 0 then
			field = self.staminaTextPool[1]
			assert(field ~= nil, "Failed to get item from pool")
			table.remove(self.staminaTextPool, table.indexOf(self.staminaTextPool, field))
			assert(field ~= nil, "After cleanup, field got nil.")
		else
			field = display.newText("", 0, 0, 60, 60)
			function field:onComplete(obj)
				if self.tween then
					transition.cancel(field.tween)
					field.tween = nil
				end
				if self.alphaTween then
					transition.cancel(field.alphaTween)
					field.alphaTween = nil
				end
				table.insert(player.staminaTextPool, field)
			end
		end
		assert(field ~= nil, "After if statement, field is nil.")
		field:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(field)
		field.x = targetX
		field.y = targetY
		field.alpha = 1
		local amountText = tostring(amount)
		if amount > 0 then
			amountText = "+" .. amountText
			field:setTextColor(unpack(constants.STAMINA_FIELD_POSITIVE_COLOR))
		else
			field:setTextColor(unpack(constants.STAMINA_FIELD_NEGATIVE_COLOR))
		end
		field.text = amountText
		local newTargetY = targetY - 40
		field.tween = transition.to(field, {y=newTargetY, time=500, transition=easing.outExpo})
		field.alphaTween = transition.to(field, {alpha=0, time=200, delay=300, onComplete=field})
	end

	function player:showHealthText(targetX, targetY, amount)
		local field
		if table.maxn(self.healthTextPool) > 0 then
			field = self.healthTextPool[1]
			assert(field ~= nil, "Failed to get item from pool")
			table.remove(self.healthTextPool, table.indexOf(self.healthTextPool, field))
			assert(field ~= nil, "After cleanup, field got nil.")
		else
			field = display.newText("", 0, 0, 60, 60)
			function field:onComplete(obj)
				if self.tween then
					transition.cancel(field.tween)
					field.tween = nil
				end
				if self.alphaTween then
					transition.cancel(field.alphaTween)
					field.alphaTween = nil
				end
				table.insert(player.healthTextPool, field)
			end
		end
		assert(field ~= nil, "After if statement, field is nil.")
		field:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(field)
		field.x = targetX
		field.y = targetY
		field.alpha = 1
		local amountText = tostring(amount)
		if amount > 0 then
			amountText = "+" .. amountText
			field:setTextColor(unpack(constants.HEALTH_FIELD_POSITIVE_COLOR))
		else
			field:setTextColor(unpack(constants.HEALTH_FIELD_NEGATIVE_COLOR))
		end
		field.text = amountText
		local newTargetY = targetY - 40
		field.tween = transition.to(field, {y=newTargetY, time=500, transition=easing.outExpo})
		field.alphaTween = transition.to(field, {alpha=0, time=200, delay=300, onComplete=field})
	end

	function player:addInjury(injuryVO)
		local injuries = self.injuries
		if table.indexOf(injuries, injuryVO) == nil then
			table.insert(self.injuries, injuryVO)
			return true
		else
			error("injuryVO already added to array")
		end
	end

	function player:hasInjury(injuryType)
		assert(injuryType ~= nil, "You cannot pass a nil injuryType.")
		local injuries = self.injuries
		if injuries == nil then return false end
		if #injuries < 1 then return false end

		local i = 1
		while injuries[i] do
			local vo = injuries[i]
			if vo.type == injuryType then return true end
			i = i + 1
		end
	end

	function player:removeLatestInjury()
		local injuries = self.injuries
		if injuries == nil then return false end
		if #injuries < 1 then return false end

		table.remove(injuries, #injuries)
	end
	
	return player
end

return BasePlayer