Freeman9mmBullet = {}

function Freeman9mmBullet:new(x, y, targetX, targetY)
	
	assert(targetX ~= nil, "You cannot pass in a nil targetX.")
	assert(targetY ~= nil, "You cannot pass in a nil targetY.")
	local bullet = display.newImage("bullet.png")
	bullet.x = x
	bullet.y = y
	bullet.targetX = targetX
	bullet.targetY = targetY
	-- TODO: use math.deg vs. manual conversion
	bullet.rot = math.atan2(bullet.y - bullet.targetY, bullet.x - bullet.targetX) / math.pi * 180 -90;
	bullet.angle = (bullet.rot -90) * math.pi / 180;
	bullet.speed = .6
	bullet.destroying = false
	
	if targetX > x then
		bullet.direction = "right"
	else
		bullet.direction = "left"
	end
	
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
				--event.other:applyLinearImpulse(xPower, 0, self.x, self.y)
				self:destroy()
			end
		end
	end
	
	function bullet:destroy()
		if self.destroying == false then
			self.destroying = true
			self.isVisible = false
			self:removeEventListener("collision", self)
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
		
		self.x = self.x + math.cos(self.angle) * self.speed * time
	   	self.y = self.y + math.sin(self.angle) * self.speed * time
	end
	
	bullet:addEventListener("collision", bullet)
	
	physics.addBody(bullet, "kinematic", {density=2, friction=0.1, bounce=0.4, isBullet=true, isSensor=true, isFixedRotation=true})
	
	return bullet
end

return Freeman9mmBullet