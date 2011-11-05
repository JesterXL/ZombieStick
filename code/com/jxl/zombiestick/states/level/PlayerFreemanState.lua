require "com.jxl.zombiestick.players.weapons.Freeman9mmBullet"
PlayerFreemanState = {}

function PlayerFreemanState:new(levelView)
	local state = {}
	state.levelView = levelView
	state.fsm = levelView:getStateMachine()
	state.lastAttack = nil -- milliseconds
	
	function state:enter()
		levelView:addEventListener("onTouch", self)
	end
	
	function state:exit()	
		levelView:removeEventListener("onTouch", self)
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
				state:attack(event)
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
	
	function state:attack(event)
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
		
		local targetX, targetY
		if player.direction == "left" then
			targetX = -4
		else
			targetX = display.getCurrentStage().width + 4
		end
		targetY = player.y
		
		local bullet = Freeman9mmBullet:new(player.x + 4, player.y + 4, targetX, targetY, self.direction)
		bullet:addEventListener("onRemoveFromGameLoop", self)
		levelView:insertChild(bullet)
		levelView.gameLoop:addLoop(bullet)
	end
	
	function state:onRemoveFromGameLoop(event)
		levelView.gameLoop:removeLoop(event.target)
	end
	
	return state
end

return PlayerFreemanState