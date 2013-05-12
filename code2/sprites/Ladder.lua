Ladder = {}

function Ladder:new()

	local ladder = display.newImage("assets/sprites/ladder.png")
	ladder.classType = "Ladder"

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

	function ladder:destroy()
		physics.removeBody(self)
		self:removeEventListener("collision", self)
		self:removeSelf()
	end

	ladder:init()

	return ladder
end

return Ladder