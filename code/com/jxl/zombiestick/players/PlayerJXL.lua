require "sprite"
require "com.jxl.zombiestick.constants"
require "com.jxl.zombiestick.gamegui.StaminaBar"
require "com.jxl.zombiestick.states.StateMachine"
require "com.jxl.zombiestick.states.ReadyState"
PlayerJXL = {}

function PlayerJXL:new(params)

	if PlayerJXL.sheet == nil then
		local sheet = sprite.newSpriteSheet("player_jesterxl_sheet.png", 64, 64)
		local standSet = sprite.newSpriteSet(sheet, 1, 6)
		sprite.add(standSet, "PlayerJXLStand", 1, 6, 1000, 0)
		local moveSet = sprite.newSpriteSet(sheet, 9, 8)
		sprite.add(moveSet, "PlayerJXLMove", 1, 8, 500, 0)
		local jumpSet = sprite.newSpriteSet(sheet, 17, 6)
		sprite.add(jumpSet, "PlayerJXLJump", 1, 6, 600, 1)
		local strikeSet = sprite.newSpriteSet(sheet, 25, 6)
		sprite.add(strikeSet, "PlayerJXLStrike", 1, 6, 300, 1)
		
		PlayerJXL.sheet = sheet
		PlayerJXL.standSet = standSet
		PlayerJXL.moveSet = moveSet
		PlayerJXL.jumpSet = jumpSet
		PlayerJXL.strikeSet = strikeSet
	end
	
	local player = display.newGroup()
	player.name = "JXL"
	player.classType = "PlayerJXL"
	player.sprite = nil
	player.direction = "right"
	player.spriteHolder = display.newGroup()
	player:insert(player.spriteHolder)
	player.staminaBar = StaminaBar:new()
	player:insert(player.staminaBar)
	player.moving = false
	player.jumping = false
	player.striking = false
	player.strikingTimer = nil
	player.moveForce = 10
	player.speed = 3
	player.maxSpeed = 3
	player.tiredSpeed = 1
	player.jumpForce = constants.JUMP_FORCE
	player.jumpForwardForce = constants.JUMP_FORWARD_FORCE
	player.stamina = 10
	player.maxStamina = 10
	player.strikeStamina = 1
	player.jumpStamina = 2
	player.moveStamina = 1
	player.startMoveTime = nil
	player.MOVE_STAMINA_TIME = 1000
	player.fsm = StateMachine:new()
	
	function player:getStateMachine()
		return self.fsm
	end
	
	function player:tick(time)
		if self.moving == true then
			if system.getTimer() - self.startMoveTime >= self.MOVE_STAMINA_TIME then
				self:reduceStamina(self.moveStamina)
				self.startMoveTime = system.getTimer()
			end
		end
			
		if self.fsm ~= nil then
			self.fsm:tick(time)
		end
	end
	
	function player:getBounds()
		return {22,4, 42,4, 42,55, 22,55}
	end
	
	function player:showSprite(name)
		local spriteAnime
		if name == "move" then
			spriteAnime = sprite.newSprite(PlayerJXL.moveSet)
			spriteAnime:prepare("PlayerJXLMove")
		elseif name == "jump" then
			spriteAnime = sprite.newSprite(PlayerJXL.jumpSet)
			spriteAnime:prepare("PlayerJXLJump")
			spriteAnime:addEventListener("sprite", player.onJumpCompleted)
		elseif name == "stand" then
			spriteAnime = sprite.newSprite(PlayerJXL.standSet)
			spriteAnime:prepare("PlayerJXLStand")
		elseif name == "strike" then
			spriteAnime = sprite.newSprite(PlayerJXL.strikeSet)
			spriteAnime:prepare("PlayerJXLStrike")
		end
		spriteAnime:setReferencePoint(display.TopLeftReferencePoint)
		spriteAnime:play()
		if player.sprite ~= nil then
			player.sprite:removeSelf()
		end
		player.sprite = spriteAnime
		player.spriteHolder:insert(spriteAnime)
		spriteAnime.x = 0
		spriteAnime.y = 0
	end
	
	function player:setDirection(dir)
		self.direction = dir
		local spriteHolder = player.spriteHolder
		if dir == "right" then
			spriteHolder.xScale = 1
			spriteHolder.x = 0
		else
			spriteHolder.xScale = -1
			spriteHolder.x = spriteHolder.width
		end
	end
	
	function player:moveRight()
		--print("moveRight: ", self.jumping)
		if self.striking == false and self.jumping == false then
			self:setDirection("right")
			self:showSprite("move")
			self:performedAction("move")
			self:startMoving()
			return true
		end
	end
	
	function player:moveLeft()
		--print("moveLeft: ", self.jumping)
		if self.striking == false and self.jumping == false then
			self:setDirection("left")
			self:showSprite("move")
			self:performedAction("move")
			self:startMoving()
			return true
		end
	end
	
	function player:stand()
		if self.striking == false and self.jumping == false then
			self:stopMoving()
			self:showSprite("stand")
		end
	end
	
	function player:strike()
		if self:canStrike() == false then return false end
		
		self.striking = true
		self:showSprite("strike")
		self:performedAction("strike")
		if self.strikingTimer ~= nil then
			timer.cancel(self.strikingTimer)
		end
		self.strikingTimer = timer.performWithDelay(500, onStrikeComplete)
		return true
	end
	
	function player:canStrike()
		if self.striking == true then return false end
		if self.jumping == true then return false end
		if self.stamina == 0 then return false end
		if self.stamina - self.strikeStamina >= 0 then return true end
		return true
	end
	
	function onStrikeComplete(event)
		local self = player
		self:showSprite("stand")
		timer.cancel(self.strikingTimer)
		self.strikingTimer = nil
		self.striking = false
	end
	
	function player:startMoving()
		if self.moving == false and self.jumping == false then
			self.moving = true
			self.startMoveTime = system.getTimer()
			Runtime:addEventListener("enterFrame", self)
		end
	end
	
	function player:stopMoving()
		self.moving = false
		Runtime:removeEventListener("enterFrame", self)
		local force
		if self.direction == "right" then
			force = self.speed
		else
			force = -self.speed
		end
		self:applyLinearImpulse(force / 3, 0, 40, 32)
		self:dispatchEvent({name="onMoveCompleted", target=self})
	end
	
	function player:enterFrame()
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
		local moveX = speed * (deltaX / dist)
		local moveY = speed * (deltaY / dist)
			
		if (math.abs(moveX) > dist or math.abs(moveY) > dist) then
			self.x = targetX
			self.y = targetY
		else
			self.x = self.x - moveX
			self.y = self.y - moveY
		end
	end
	
	function player:canJump()
		local score = 0
		local min = 4
		if self.striking == false then score = score + 1 end
		if self.moving == false then score = score + 1 end
		if self.jumping == false then score = score + 1 end
		if self.stamina >= self.jumpStamina then score = score + 1 end
		
		if score >= min then
			return true
		else
			return false
		end
	end
	
	function player:jump()
		if self:canJump() == false then return false end
		
		self.jumping = true
		self:showSprite("jump")
		self:performedAction("jump")
		self:addEventListener("collision", player.onJumpCollision)
		self:applyLinearImpulse(0, self.jumpForce, 40, 32)
	end
	
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
	
	function player.onJumpCollision(event)
		local self = player
		local anime = self.sprite
		if event.phase == "began" and anime.currentFrame <= 4 then
			anime.currentFrame = 5
			anime:play()
			self:removeEventListener("collision", player.onJumpCollision)
		end
	end
	
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
	
	function player:performedAction(actionType)
		print("PlayerJXL::performedAction: ", actionType)
		if actionType == "strike" then
			self:reduceStamina(self.strikeStamina)
		elseif actionType == "jump" then
			self:reduceStamina(self.jumpStamina)
		end
		self:dispatchEvent({name="onPerformedAction", target=self, action=actionType})
	end
	
	function player:reduceStamina(amount)
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
			self.speed = self.tiredSpeed
		else
			self.speed = self.maxSpeed
		end
	end
	
	player:showSprite("stand")
	
	player.x = params.x
	player.y = params.y
	
	local playerShape = player:getBounds()
	assert(physics.addBody( player, "dynamic", 
		{ density=params.density, friction=params.friction, bounce=params.bounce, isBullet=true, 
			shape=playerShape,
			filter = { categoryBits = constants.COLLISION_FILTER_PLAYER_CATEGORY, 
			maskBits = constants.COLLISION_FILTER_PLAYER_MASK }} ), 
			"PlayerJXL failed to add to physics.")
			
	player.isFixedRotation = true
	
	player.fsm:changeState(ReadyState:new(player))
	
	return player
end

return PlayerJXL