
Zombie = {}

function Zombie:new()

	local zombie = display.newGroup()
	zombie.name = "Zombie"
	zombie.classType = "Zombie"
	zombie.targets = nil
	zombie.moving = false
	zombie.speed = 1
	
	local rect = display.newRect(0, 0, 30, 30)
	rect:setReferencePoint(display.TopLeftReferencePoint)
	rect:setFillColor(255, 0, 0)
	zombie:insert(rect)
	
	function zombie:setTargets(targets)
		print("Zombie::setTargets, #targets: ", #targets)
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
	
	assert(physics.addBody( zombie, "dynamic", 
		{ density=.7, friction=.2, bounce=.2, isBullet=true,
			filter = { categoryBits = constants.COLLISION_FILTER_ENEMY_CATEGORY, 
			maskBits = constants.COLLISION_FILTER_ENEMY_MASK }} ), 
			"Zombie failed to add to physics.")
			
	return zombie
	
end

return Zombie