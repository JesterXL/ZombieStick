Freeman9mmBullet = {}

function Freeman9mmBullet:new(x, y, targetX, targetY, direction)
	
	assert(targetX ~= nil, "You cannot pass in a nil targetX.")
	assert(targetY ~= nil, "You cannot pass in a nil targetY.")
	local bullet = display.newImage("bullet.png")
	bullet.x = x
	bullet.y = y
	bullet.targetX = targetX
	bullet.targetY = targetY
	bullet.speed = .6
	bullet.direction = direction
	
	function bullet:collision(event)
		if self.destroying == true then return true end
		
		if event.phase == "began" then
			if event.other.name == "Zombie" then
				event.other:applyDamage(1)
				local force = 2
				local xPower
				if self.direction == "left" then
					xPower = force
				else
					xPower = -force
				end
				event.other:applyLinearImpulse(xPower, 0, self.x, self.y)
				self:destroy()
			end
		end
	end
	
	function bullet:destroy()
		if self.destroying == false then
			self.destroying = true
			self:removeEventListener("postCollision", self)
			local t = {}
			t.bullet = self
			function t:timer(event)
				self.bullet:removeSelf()
			end
			timer.performWithDelay(300, t)
			self:dispatchEvent({name="onRemoveFromGameLoop", target=self})
		end
	end
	
	function bullet:tick(time)
		if self.destroying == true then return true end
		
		local deltaX = self.x - self.targetX
		local deltaY = self.y - self.targetY
		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))

		local moveX = self.speed * (deltaX / dist) * time
		local moveY = self.speed * (deltaY / dist) * time
		
		if (math.abs(moveX) > dist or math.abs(moveY) > dist) then
			self:destroy()
		else
			self.x = self.x - moveX
			self.y = self.y - moveY
		end
	end
	
	bullet:addEventListener("collision", bullet)
	
	physics.addBody(bullet, "kinematic", {density=2, friction=0.1, bounce=0.4, isBullet=true, isSensor=true, isFixedRotation=true})
	
	return bullet
end

return Freeman9mmBullet