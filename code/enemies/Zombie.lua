
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
	zombie.speed = .5
	zombie.hitPoints = 4
	zombie.maxHitPoints = 4
	zombie.dead = false
	
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
		if self.targets ~= nil and #self.targets > 0 then
			self:startMoving()
		else
			self:stopMoving()
		end	
	end
	
	function zombie:startMoving()
		if self.moving == false then
			self.moving = true
			Runtime:addEventListener("enterFrame", self)
		end
	end
	
	function zombie:stopMoving()
		if self.moving == true then
			self.moving = false
			Runtime:removeEventListener("enterFrame", self)
		end
	end
	
	function zombie:enterFrame(event)
		if self.moving == true then
			self:moveTowardTargets()
		end
	end
	
	function zombie:moveTowardTargets()
		--print("Zombie::moveTowardTargets")
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
		local moveX = self.speed * (deltaX / distance)
		local moveY = self.speed * (deltaY / distance)

		if (math.abs(moveX) > distance or math.abs(moveY) > distance) then
			self.x = self.player.x
			--self.y = self.player.y
			
		else
			self.x = self.x - moveX
			--self.y = self.y - moveY
		end
	end
	
	function zombie:applyDamage(amount)
		if self.dead == true then return true end
		
		self.hitPoints = self.hitPoints - amount
		if self.hitPoints <= 0 then
			self.dead = true
			self:destroy()
		end
	end
	
	function zombie:updateAnime()
		zombie:prepare("ZombieMoveRight")
		zombie:play()
	end
	
	function zombie:destroy()
		self:stopMoving()
		local t = {zombie = self}
		function t:timer(event)
			self.zombie:removeSelf()
		end
		timer.performWithDelay(300, t)
	end
			
	
	local shape = {22,4, 42,4, 42,55, 22,55}
	assert(physics.addBody( zombie, "dynamic", 
		{ density=.7, friction=.2, bounce=.2, isBullet=true, shape=shape,
			filter = { categoryBits = constants.COLLISION_FILTER_ENEMY_CATEGORY, 
			maskBits = constants.COLLISION_FILTER_ENEMY_MASK }} ), 
			"Zombie failed to add to physics.")
	
	zombie:showSprite("move")
	
	return zombie
	
end

return Zombie