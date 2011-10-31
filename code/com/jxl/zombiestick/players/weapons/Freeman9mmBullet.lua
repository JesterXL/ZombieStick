Freeman9mmBullet = {}

function Freeman9mmBullet:new(x, y, target)
	
	local bullet = display.newImage("bullet.png")
	bullet.target = target
	bullet.x = x
	bullet.y = y
	bullet.speed = .6
	
	function bullet:collision(event)
		if self.destroying == true then return true end
		
		if event.phase == "began" then
			if event.other.name == "Zombie" then
				event.other:applyDamage(1)
				local xPower
				if self.direction == "left" then
					xPower = -50
				else
					xPower = 50
				end
				event.other:applyLinearImpulse(xPower, 0, self.x, self.y)
				self:destroy()
			end
		end
	end
	
	function bullet:destroy()
		if self.destroying == false then
			self.destroying = true
			local t = {}
			t.bullet = self
			function t:timer(event)
				self.bullet:removeSelf()
			end
			timer.performWithDelay(300, t)
		end
	end
	
	function bullet:tick(time)
		if self.destroying == true then return true end
		
		local deltaX = self.x - self.target.x
		local deltaY = self.y - self.target.y
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
	bullet.target = target
	
	physics.addBody(bullet, "kinematic", {density=2, friction=0.1, bounce=0.4, isBullet=true, isSensor=true, isFixedRotation=true})
	
end

return Freeman9mmBullet