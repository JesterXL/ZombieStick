require "sprite"
PlayerJXL = {}

function PlayerJXL:new()

	if PlayerJXL.moveSheet == nil then
		local moveRightSheet = sprite.newSpriteSheet("player_jxl_run_right_sheet.png", 64, 64)
		local moveRightSet = sprite.newSpriteSet(moveRightSheet, 1, 8)
		sprite.add(moveRightSet, "jxlMoveRight", 1, 8, 500, 0)
		PlayerJXL.moveRightSheet = moveRightSheet
		PlayerJXL.moveRightSet = moveRightSet
		
		local jumpRightSheet = sprite.newSpriteSheet("player_jxl_jump_right_sheet.png", 80, 64)
		local jumpRightSet = sprite.newSpriteSet(jumpRightSheet, 1, 6)
		sprite.add(jumpRightSet, "jxlJumpRight", 1, 6, 500, 1)
		PlayerJXL.jumpRightSheet = jumpRightSheet
		PlayerJXL.jumpRightSet = jumpRightSet
		
		local standSheet = sprite.newSpriteSheet("player_jxl_stand_sheet.png", 64, 64)
		local standSet = sprite.newSpriteSet(standSheet, 1, 4)
		sprite.add(standSet, "jxlStand", 1, 4, 1000, 0)
		PlayerJXL.standSheet = standSheet
		PlayerJXL.standSet = standSet
		
		local strikeSheet = sprite.newSpriteSheet("player_jxl_strike_sheet.png", 80, 64)
		local strikeSet = sprite.newSpriteSet(strikeSheet, 1, 6)
		sprite.add(strikeSet, "jxlStrike", 1, 6, 500, 1)
		PlayerJXL.strikeSheet = strikeSheet
		PlayerJXL.strikeSet = strikeSet
	end
	
	local player = display.newGroup()
	player.sprite = nil
	player.direction = "right"
	player.strikeTime = 500
	player.spriteHolder = display.newGroup()
	player:insert(player.spriteHolder)
	player.moving = false
	player.jumping = false
	player.moveForce = 10
	player.speed = 3
	player.jumpForce = 50
	player.jumpForwardForce = 52
	
	--[[
	local sizeRect = display.newRect(22, 4, 20, 48)
	sizeRect:setReferencePoint(display.TopLeftReferencePoint)
	sizeRect.strokeWidth = 1
	sizeRect:setFillColor(255, 0, 0, 100)
	sizeRect:setStrokeColor(255, 0, 0)
	PlayerJXL.sizeRect = sizeRect
	player:insert(sizeRect)
	sizeRect.isFixedRotation = true
	]]--
	
	local strikeRect = display.newRect(0, 0, 32, 10)
	strikeRect:setReferencePoint(display.TopLeftReferencePoint)
	strikeRect.strokeWidth = 1
	strikeRect:setFillColor(255, 0, 0, 100)
	strikeRect:setStrokeColor(255, 0, 0)
	player.spriteHolder:insert(strikeRect)
	strikeRect.isHitTestable = false
	strikeRect.isVisible = false
	strikeRect.x = 40
	strikeRect.y = 32
	player.strikeRect = strikeRect
	
	function player:showSprite(name)
		local spriteAnime
		if name == "move" then
			spriteAnime = sprite.newSprite(PlayerJXL.moveRightSet)
			spriteAnime:prepare("jxlMoveRight")
		elseif name == "jump" then
			spriteAnime = sprite.newSprite(PlayerJXL.jumpRightSet)
			spriteAnime:prepare("jxlJumpRight")
			spriteAnime:addEventListener("sprite", onJumpCompleted)
		elseif name == "stand" then
			spriteAnime = sprite.newSprite(PlayerJXL.standSet)
			spriteAnime:prepare("jxlStand")
		elseif name == "strike" then
			spriteAnime = sprite.newSprite(PlayerJXL.strikeSet)
			spriteAnime:prepare("jxlStrike")
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
			spriteHolder.x = spriteHolder.width - 9
		end
	end
	
	function player:moveRight()
		print("moveRight: ", self.jumping)
		if self:striking() == false and self.jumping == false then
			self:setDirection("right")
			self:showSprite("move")
			self:startMoving()
			return true
		end
	end
	
	function player:moveLeft()
		print("moveLeft: ", self.jumping)
		if self:striking() == false and self.jumping == false then
			self:setDirection("left")
			self:showSprite("move")
			self:startMoving()
			return true
		end
	end
	
	function player:stand()
		if self:striking() == false and self.jumping == false then
			self:stopMoving()
			self:showSprite("stand")
		end
	end
	
	function player:striking()
		local strikeRect = self.strikeRect
		if strikeRect.tween ~= nil then
			return true
		else
			return false
		end
	end
	
	function player:strike()
		if self.jumping == true then
			return
		end
		
		local strikeRect = self.strikeRect
		if strikeRect.tween ~= nil then
			return
		end
		
		self:showSprite("strike")
		strikeRect.isHitTestable = true
		strikeRect.isVisible = true
		if strikeRect.tween ~= nil then
			transition.cancel(strikeRect.tween)
		end
		
		strikeRect.x = 0
		local halfStrikeTime = self.strikeTime / 2
		strikeRect.tween = transition.to(strikeRect, {time=halfStrikeTime, x=48, onComplete=onStrikeOutComplete})
	end
	
	function onStrikeOutComplete(strikeRect)
		local self = player
		transition.cancel(strikeRect.tween)
		local halfStrikeTime = self.strikeTime / 2
		strikeRect.tween = transition.to(strikeRect, {time=halfStrikeTime, x=0, onComplete=onStrikeOutAndInComplete})
	end
	
	function onStrikeOutAndInComplete(strikeRect)
		local self = player
		self:showSprite("stand")
		transition.cancel(strikeRect.tween)
		strikeRect.tween = nil
		strikeRect.isHitTestable = false
		strikeRect.isVisible = false
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
		local score = 0
		local min = 3
		if self:striking() == false then score = score + 1 end
		if self.moving == false then score = score + 1 end
		if self.jumping == false then score = score + 1 end
		
		if score >= min then
			self.jumping = true
			self:showSprite("jump")
			self:addEventListener("collision", onJumpCollision)
			self:applyLinearImpulse(0, self.jumpForce, 40, 32)
		end	
	end
	
	function player:jumpForward()
		if self:striking() == false and self.moving == false and self.jumping == false then
			self.jumping = true
			self:showSprite("jump")
			self:addEventListener("collision", onJumpCollision)
			local xForce
			if self.direction == "right" then
				xForce = self.jumpForwardForce
			else
				xForce = -self.jumpForwardForce
			end
			self:applyLinearImpulse(xForce, self.jumpForce, 40, 32)
		end
	end
	
	function onJumpCompleted(event)
		if event.phase == "end" then
			if event.target.currentFrame ~= 6 then
				print("What the hell")
			end
			local self = player
			event.target:removeEventListener("sprite", onJumpCompleted)
			self:showSprite("stand")
			self.jumping = false
		else
			if event.target.currentFrame == 4 then
				event.target:pause()
			end
		end
	end
	
	function onJumpCollision(event)
		local self = player
		local anime = self.sprite
		if event.phase == "began" and anime.currentFrame == 4 then
			anime.currentFrame = 5
			anime:play()
			self:removeEventListener("collision", onJumpCollision)
		end
	end
	
	
	player:showSprite("stand")
	
	-- 22, 4, 20, 48
	local playerShape = {22,4, 42,4, 42,52, 22,52}
	assert(physics.addBody( player, "dynamic", { density=0.8, friction=0.8, bounce=0.1, shape=playerShape} ), "SizeRect failed to add to physics.")
	--assert(physics.addBody( strikeRect, "dynamic", { density=4.0, friction=0.2, bounce=0.1, isSensor=true, isBullet=true} ), "StrikeRect failed to add to physics.")
	
	player.isFixedRotation = true
	return player
end

return PlayerJXL