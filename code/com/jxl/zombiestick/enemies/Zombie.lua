require "com.jxl.core.statemachine.StateMachine"
require "com.jxl.zombiestick.states.enemies.zombie.IdleState"
require "com.jxl.zombiestick.states.enemies.zombie.EatPlayerState"
require "com.jxl.zombiestick.states.enemies.zombie.TemporarilyInjuredState"
require "com.jxl.zombiestick.states.enemies.zombie.GrabPlayerState"
require "com.jxl.zombiestick.states.enemies.zombie.KnockedProneState"

Zombie = {}

function Zombie:new()
	
	if Zombie.sheet == nil then
		local sheet = sprite.newSpriteSheet("enemy_zombie_sheet.png", 64, 64)
		local moveSet = sprite.newSpriteSet(sheet, 8, 14)
		sprite.add(moveSet, "ZombieMoveRight", 1, 7, 1000, 0)
		sprite.add(moveSet, "ZombieMoveLeft", 8, 7, 1000, 0)
		Zombie.sheet = sheet
		Zombie.moveSet = moveSet
	end

	local zombie = display.newGroup()
	zombie.name = "Zombie"
	zombie.classType = "Zombie"
	zombie.targets = nil
	zombie.moving = false
	zombie.speed = .01
	zombie.health = 4
	zombie.maxHealth = 4
	zombie.dead = false
	zombie.targetPlayer = nil
	zombie.collisionTargets = nil
	zombie.healthTextPool = {}
	
	function zombie:showSprite(name)
		local spriteAnime
		if name == "move" then
			spriteAnime = sprite.newSprite(Zombie.moveSet)
			spriteAnime:prepare("ZombieMoveRight")
		end
		spriteAnime:setReferencePoint(display.TopLeftReferencePoint)
		spriteAnime:play()
		if self.sprite ~= nil then
			self.sprite:removeSelf()
		end
		self.sprite = spriteAnime
		self:insert(spriteAnime)
		spriteAnime.x = 0
		spriteAnime.y = 0
	end
	
	function zombie:setTargets(targets)
		self.targets = targets
	end
	
	function zombie:startMoving()
		if self.moving == false then
			self.moving = true
			self.sprite:play()
		end
	end
	
	function zombie:stopMoving()
		if self.moving == true then
			self.moving = false
			self.sprite:pause()
		end
	end
	
	function zombie:moveTowardTargets(time)
		if self.targets == nil then
			return true
		end
		
		local targets = self.targets
		if #targets < 1 then
			return true
		end
		
		
		local i = 1
		local deltaX
		local deltaY
		local distance
		local dTable = {}
		while targets[i] do
			local target = targets[i]
			local node = {}
			table.insert(dTable, i, node)
			node.target = target
			
			deltaX = self.x - target.x
			deltaY = self.y - target.y
			distance = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
			node.distance = distance
			i = i + 1
		end
		
		table.sort(dTable, function(a,b) return a.distance < b.distance end)
		
		local closest = dTable[1]
		target = closest.target
	 	distance = closest.distance
		local moveX = self.speed * (deltaX / distance) * time
		local moveY = self.speed * (deltaY / distance) * time

		if (math.abs(moveX) > distance or math.abs(moveY) > distance) then
			self.x = target.x
			--self.y = self.player.y
			
		else
			self.x = self.x - moveX
			--self.y = self.y - moveY
		end
	end

	function zombie:setHealth(value)
		assert(value ~= nil, "Error: Zombie::setHealth, you cannot pass a nil amount.")
		local oldValue = self.health
		self.health = value
		if self.health < 0 then
			self.health = 0
		end
		-- TODO: put uber slow speeds here if hurt AND/OR tired

		local difference = value - oldValue
		self:showHealthText(25, 0, difference)

		if self.health <= 0 and self.dead == false then
			self.dead = true
			self:destroy()
		end
	end
	
	function zombie:applyDamage(amount)
		if self.dead == true then return true end
		self:setHealth(self.health - amount)
	end
	
	function zombie:updateAnime()
		zombie:prepare("ZombieMoveRight")
		zombie:play()
	end
	
	function zombie:tick(time)
		if self.dead == true then
			return true
		end

		if self.moving == true then
			self:moveTowardTargets(time)
		end

		if self.fsm ~= nil then
			self.fsm:tick(time)
		end
	end

	function zombie:collision(event)
		if self.dead == true then return true end

		--print("))))))))) phase: ", event.phase, ", class: ", event.other.classType)
		if event.phase == "began" then
			if event.other.classType == "PlayerJXL" then
				if self.collisionTargets == nil then
					self.collisionTargets = {}
				end
				if table.indexOf(event.other) == nil then
					table.insert(self.collisionTargets, event.other)
				end
			end
		elseif event.phase == "ended" then
			if event.other.classType == "PlayerJXL" then
				table.remove(self.collisionTargets, table.indexOf(event.other))
				if self.targetPlayer ~= nil and event.other == self.targetPlayer then
					self:dispatchEvent({name="onTargetPlayerRemoved", target=self})
				end
			end
		end
	end

	function zombie:onHit(damage)
		self:applyDamage(damage)
		self:dispatchEvent({name="onZombieHit", target=self, damage=damage})
	end

	-- [jwarden 6.23.2012] TODO: add type of defeat, like throw down or push back
	function zombie:onGrappleDefeated()
		self:dispatchEvent({name="onZombieGrabDefeated", target=self})
	end
	
	function zombie:fallDown()
		self.isFixedRotation = false
		self:applyAngularImpulse(-200)
	end

	function zombie:standUp()
		local oldY = self.y
		self.rotation = 0
		self.isFixedRotation = true
		self.y = oldY - self.height
	end

	function zombie:destroy()
		self.dead = true
		self:stopMoving()
		local t = {zombie = self}
		function t:timer(event)
			self.zombie:removeSelf()
		end
		timer.performWithDelay(300, t)
	end

	function zombie:showHealthText(targetX, targetY, amount)
		local field
		if table.maxn(self.healthTextPool) > 0 then
			field = self.healthTextPool[1]
			assert(field ~= nil, "Failed to get item from pool")
			table.remove(self.healthTextPool, table.indexOf(self.healthTextPool, field))
			assert(field ~= nil, "After cleanup, field got nil.")
		else
			field = display.newText("", 0, 0, 60, 60, native.systemFont, constants.FLOATING_TEXT_FONT_SIZE)
			function field:onComplete(obj)
				if self.tween then
					transition.cancel(field.tween)
					field.tween = nil
				end
				if self.alphaTween then
					transition.cancel(field.alphaTween)
					field.alphaTween = nil
				end
				table.insert(zombie.healthTextPool, field)
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
			
	
	local shape = {22,4, 42,4, 42,55, 22,55}
	assert(physics.addBody( zombie, "dynamic", 
		{ density=.8, friction=.8, bounce=.2, isBullet=true, shape=shape,
			filter = { categoryBits = constants.COLLISION_FILTER_ENEMY_CATEGORY, 
			maskBits = constants.COLLISION_FILTER_ENEMY_MASK,
			}} ), 
			"Zombie failed to add to physics.")
	
	zombie.isFixedRotation = true
	zombie:showSprite("move")

	zombie:addEventListener("collision", zombie)

	-- TODO: finish these; make the Zombie grapple and bite
	zombie.fsm = StateMachine:new(zombie)

	--zombie.fsm:addState2(MovingLeftState:new())
	--zombie.fsm:addState2(MovingRightState:new())
	zombie.fsm:addState2(IdleState:new())
	zombie.fsm:addState2(EatPlayerState:new())
	zombie.fsm:addState2(TemporarilyInjuredState:new())
	zombie.fsm:addState2(GrabPlayerState:new())
	zombie.fsm:addState2(KnockedProneState:new())
	zombie.fsm:setInitialState("idle", zombie)
	
	return zombie
	
end

return Zombie