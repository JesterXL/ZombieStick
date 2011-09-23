require "sprite"
PlayerFreeman = {}

function PlayerFreeman:new()

	if PlayerFreeman.moveSheet == nil then
		local moveRightSheet = sprite.newSpriteSheet("player_freeman_run_sheet.png", 64, 64)
		local moveRightSet = sprite.newSpriteSet(moveRightSheet, 1, 7)
		sprite.add(moveRightSet, "freemanMoveRight", 1, 7, 500, 0)
		PlayerFreeman.moveRightSheet = moveRightSheet
		PlayerFreeman.moveRightSet = moveRightSet
		
		local jumpRightSheet = sprite.newSpriteSheet("player_freeman_jump_sheet.png", 64, 64)
		local jumpRightSet = sprite.newSpriteSet(jumpRightSheet, 1, 6)
		sprite.add(jumpRightSet, "freemanJumpRight", 1, 6, 500, 1)
		PlayerFreeman.jumpRightSheet = jumpRightSheet
		PlayerFreeman.jumpRightSet = jumpRightSet
		
		local standSheet = sprite.newSpriteSheet("player_freeman_stand_sheet.png", 64, 64)
		local standSet = sprite.newSpriteSet(standSheet, 1, 6)
		sprite.add(standSet, "freemanStand", 1, 6, 1100, 0)
		PlayerFreeman.standSheet = standSheet
		PlayerFreeman.standSet = standSet
		
		local strikeSheet = sprite.newSpriteSheet("player_freeman_shoot_sheet.png", 64, 64)
		local strikeSet = sprite.newSpriteSet(strikeSheet, 1, 5)
		sprite.add(strikeSet, "freemanShoot", 1, 5, 500, 1)
		PlayerFreeman.strikeSheet = strikeSheet
		PlayerFreeman.strikeSet = strikeSet
	end
	
	local player = display.newGroup()
	player.name = "PlayerFreeman"
	player.sprite = nil
	player.direction = "right"
	player.spriteHolder = display.newGroup()
	player:insert(player.spriteHolder)
	player.moving = false
	player.jumping = false
	player.shooting = false
	player.shootingTimer = nil
	player.moveForce = 10
	player.speed = 3
	player.jumpForce = 50
	player.jumpForwardForce = 30
	
	function player:showSprite(name)
		local spriteAnime
		if name == "move" then
			spriteAnime = sprite.newSprite(PlayerFreeman.moveRightSet)
			spriteAnime:prepare("freemanMoveRight")
		elseif name == "jump" then
			spriteAnime = sprite.newSprite(PlayerFreeman.jumpRightSet)
			spriteAnime:prepare("freemanJumpRight")
			spriteAnime:addEventListener("sprite", player.onJumpCompleted)
		elseif name == "stand" then
			spriteAnime = sprite.newSprite(PlayerFreeman.standSet)
			spriteAnime:prepare("freemanStand")
		elseif name == "shoot" then
			spriteAnime = sprite.newSprite(PlayerFreeman.strikeSet)
			spriteAnime:prepare("freemanShoot")
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
		if self.shooting == false and self.jumping == false then
			self:setDirection("right")
			self:showSprite("move")
			self:startMoving()
			return true
		end
	end
	
	function player:moveLeft()
		if self.shooting == false and self.jumping == false then
			self:setDirection("left")
			self:showSprite("move")
			self:startMoving()
			return true
		end
	end
	
	function player:stand()
		if self.shooting == false and self.jumping == false then
			self:stopMoving()
			self:showSprite("stand")
		end
	end
	
	function player:shoot()
		if self.shooting == true or self.jumping == true then
			return
		end
		
		self.shooting = true
		self:showSprite("shoot")
		if self.shootingTimer ~= nil then
			timer.cancel(self.shootingTimer)
		end
		self.shootingTimer = timer.performWithDelay(500, onShootComplete)
	end
	
	
	function onShootComplete(event)
		local self = player
		self:showSprite("stand")
		timer.cancel(self.shootingTimer)
		self.shootingTimer = nil
		self.shooting = false
	end
	
	function player:startMoving()
		if self.moving == false and self.jumping == false then
			self.moving = true
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
	end
	
	function player:enterFrame()
		-- using physics
		--[[
		local force
		if self.direction == "right" then
			force = self.moveForce
		elseif self.direction == "left" then
			force = -self.moveForce
		else
			force = 0
		end
		self:applyForce(force, 0, 40, 32)
		]]--
		
		-- using good ole' x en whuy
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
	
	function player:jump()
		print("freeman jump")
		local score = 0
		local min = 3
		if self.shooting == false then score = score + 1 end
		if self.moving == false then score = score + 1 end
		if self.jumping == false then score = score + 1 end
		
		if score >= min then
			print("\tmade it")
			self.jumping = true
			self:showSprite("jump")
			self:addEventListener("collision", player.onJumpCollision)
			self:applyLinearImpulse(0, self.jumpForce, 40, 32)
		end	
	end
	
	function player:jumpForward()
		if self.shooting == false and self.moving == false and self.jumping == false then
			self.jumping = true
			self:showSprite("jump")
			
			
			
			local xForce
			if self.direction == "right" then
				xForce = self.jumpForwardForce
			else
				xForce = -self.jumpForwardForce
			end
			--[[
			self:applyLinearImpulse(xForce, self.jumpForce, 40, 32)
			]]--
			--print("--------------")
			--self.jumpStartTime = system.getTimer()
			--Runtime:addEventListener("enterFrame", onJumpForward)
			self:addEventListener("collision", player.onJumpCollision)
			local multiplier = 60
			self:applyForce(xForce* multiplier, self.jumpForce * multiplier, 40, 32)
		end
	end
	
	function player.onJumpCompleted(event)
		print("onJumpCompleted, phase: ", event.phase, ", frame: ", event.target.currentFrame)
		if event.phase == "end" then
			if event.target.currentFrame ~= 6 then
				print("What the hell")
			end
			local self = player
			event.target:removeEventListener("sprite", player.onJumpCompleted)
			self:showSprite("stand")
			self.jumping = false
		--[[else
			if event.target.currentFrame >= 4 then
				event.target:pause()
			end
		end]]--
		end
	end
	
	function player.onJumpCollision(event)
		print("onJumpCollision, phase: ", event.phase)
		local self = player
		local anime = self.sprite
		if event.phase == "began" and anime.currentFrame <= 4 then
			anime.currentFrame = 5
			anime:play()
			self:removeEventListener("collision", player.onJumpCollision)
		end
	end
	
	
	player:showSprite("stand")
	
	-- 22, 4, 20, 48
	local playerShape = {22,4, 42,4, 42,52, 22,52}
	assert(physics.addBody( player, "dynamic", 
		{ density=0.8, friction=0.8, bounce=0.1, isBullet=true, shape=playerShape,
			filter = { categoryBits = 4, maskBits = 3 }} ), 
			"player failed to add to physics.")
			
	player.isFixedRotation = true
	
	return player
end

return PlayerFreeman