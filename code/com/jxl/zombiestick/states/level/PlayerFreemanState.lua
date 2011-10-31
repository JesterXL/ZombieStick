require "com.jxl.zombiestick.players.weapons.Freeman9mmBullet"
PlayerFreemanState = {}

function PlayerJXLState:new(levelView)
	local state = {}
	state.levelView = levelView
	state.fsm = levelView:getStateMachine()
	state.lastAttack = nil -- milliseconds
	
	function state:enter()
		levelView:addEventListener("onTouch", self)
		local enemies = levelView.enemies
		local i = 1
		while enemies[i] do
			local enemy = enemies[i]
			enemy:addEventListener("touch", self)
			i = i + 1
		end
	end
	
	function state:exit()	
		levelView:removeEventListener("onTouch", self)
		local enemies = levelView.enemies
		local i = 1
		while enemies[i] do
			local enemy = enemies[i]
			enemy:removeEventListener("touch", self)
			i = i + 1
		end
	end
	
	function state:tick(time)
	end
	
	function state:onTouch(event)
		local target = event.touchTarget
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
			if target.name == "right" then
				player:stand()
				return true
			elseif target.name == "left" then
				player:stand()
				return true
			end
		end
	end
	
	function state:touch(event)
		if event.phase == "ended" then
			self:attack(event.target)
			return true
		end
	end
	
	function state:attack(target)
		local player = levelView.player
		if player:attack() == false then return false end
		
		if self.lastAttack ~= nil then
			local et = system.getTimer() - self.lastAttack
			if et < 1200 then
				return true
			else
				self.lastAttack = system.getTimer()
			end
		else
			self.lastAttack = system.getTimer()
		end
		
		local bullet = Freeman9mmBullet:new(player.x, player.y, target)
		levelView:insertChild(bullet)
		levelView.gameLoop:addLoop(bullet)
	end
	
	return state
end

return PlayerFreemanState