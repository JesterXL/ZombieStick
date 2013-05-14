Ladder = {}

function Ladder:new()

	local ladder = display.newImage("assets/sprites/ladder.png")
	ladder.classType = "Ladder"
	ladder.startY = nil
	ladder.targetY = nil
	ladder.reachedTarget = nil

	function ladder:init()
		self:addEventListener("collision", self)
		mainGroup:insert(self)
		physics.addBody(self, "static", {density = 0.6, friction = 0.3, bounce = 0.5, isSensor=true})
	end

	function ladder:collision(event)
		if event.other.classType == "PlayerJXL" then
			if event.phase == "began" then
				Runtime:dispatchEvent({name="onPlayerLadderCollisionBegan", target=self})
			elseif event.phase == "ended" then
				Runtime:dispatchEvent({name="onPlayerLadderCollisionEnded", target=self})
			end
			return true
		end
	end

	function ladder:moveDown()
		if self.reachedTarget == nil then
			self.startY = self.y
			self.targetY = self.y + self.height
			self.reachedTarget = false
			gameLoop:addLoop(self)
		end
	end

	function ladder:stopMoving()
		gameLoop:removeLoop(self)
	end

	function ladder:tick(time)
		if self.reachedTarget then return true end

		local targetY = self.targetY
		local targetX = self.x

		local deltaX = self.x - targetX
		local deltaY = self.y - targetY
		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
		local moveX = speed * (deltaX / dist) * time
		local moveY = speed * (deltaY / dist) * time

		if (math.abs(moveX) > dist or math.abs(moveY) > dist) then
			self.x = targetX
			self.y = targetY
			self.reachedTarget = true
		else
			self.x = self.x - moveX
			self.y = self.y - moveY
		end
	end

	function ladder:destroy()
		physics.removeBody(self)
		self:removeEventListener("collision", self)
		self:removeSelf()
	end

	ladder:init()

	return ladder
end

return Ladder