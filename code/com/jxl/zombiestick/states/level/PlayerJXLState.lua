PlayerJXLState = {}

function PlayerJXLState:new(levelView)
	local state = {}
	state.levelView = levelView
	state.fsm = levelView:getStateMachine()
	state.lastAttack = nil -- milliseconds
	state.swordPolygon = nil
	
	function state:enter()
		levelView:addEventListener("onTouch", self)
		self.swordPolygon = SwordPolygon:new(-99, -99, 20, 2)
		levelView:insertChild(self.swordPolygon)
	end
	
	function state:exit()	
		levelView:removeEventListener("onTouch", self)
		self.swordPolygon:removeSelf()
		self.swordPolyon = nil
	end
	
	function state:tick(time)
	end
	
	function state:onTouch(event)
		local target = event.target
		local player = levelView.player
		if player == nil then
			return
		end
		
		if event.phase == "began" then
			if target.name == "jump" then
				player:jump()
				return true
			elseif target.name == "jumpForward" then
				player:jumpForward()
				return true
			elseif target.name == "right" then
				player:moveRight()
				return true
			elseif target.name == "left" then
				player:moveLeft()
				return true
			end
		elseif event.phase == "ended" then
			if target.name == "strike" then
				state:attack()
				return true
			elseif target.name == "right" then
				player:stand()
				return true
			elseif target.name == "left" then
				player:stand()
				return true
			end
		end
	end
	
	function state:attack()
		local player = levelView.player
		if player:attack() == false then return false end
		
		if self.lastAttack ~= nil then
			local et = system.getTimer() - self.lastAttack
			if et < 300 then
				return true
			else
				self.lastAttack = system.getTimer()
			end
		else
			self.lastAttack = system.getTimer()
		end
		
		local sword = self.swordPolygon
		
		sword.y = player.y + (player.height / 2)
		
		local targetX
		local playerBounds = player:getBounds()
		if player.direction == "left" then
			sword.x = player.x + playerBounds[1]
			targetX = sword.x - sword.width
		else
			sword.x = player.x + playerBounds[1] + playerBounds[3] + sword.width
			targetX = sword.x + sword.width
		end
		
		if sword.tween ~= nil then
			transition.cancel(sword.tween)
		end
		if sword.onComplete == nil then
			function sword:onComplete(event)
				sword.x = -999
				sword.y = -999
				sword.tween = nil
			end
			function sword:collision(event)
				if event.phase == "began" then
					if event.other.name == "Zombie" then
						event.other:applyDamage(2)
					end
				end
			end
			sword:addEventListener("collision", sword)
		end
		
		sword.tween = transition.to(sword, {time=100, x=targetX, onComplete=sword})
	end
	
	
	return state
end

return PlayerJXLState