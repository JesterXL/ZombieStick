require "com.jxl.zombiestick.players.weapons.Freeman9mmBullet"
PlayerFreemanState = {}

function PlayerFreemanState:new(levelView)
	local state = {}
	state.levelView = levelView
	state.fsm = levelView:getStateMachine()
	
	function state:enter()
		levelView:addEventListener("onTouch", self)
		Runtime:addEventListener("touch", self)
	end
	
	function state:exit()	
		levelView:removeEventListener("onTouch", self)
		Runtime:removeEventListener("touch", self)
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
		if event.phase == "began" then
			self:attack(event)
			return true
		end
	end
	
	function state:attack(event)
		local player = levelView.player
		if player:attack() == false then return false end
		
		local lc = levelView.levelChildren
		local targetX, targetY
		local localX, localY = levelView:localToContent(event.x, event.y)
		local variance = 80
		targetX = localX + (lc.x * -1) + (math.random() * variance) - (variance / 2)
		targetY = localY + (lc.y * -1) + (math.random() * variance) - (variance / 2)
		if targetX > player.x and player.direction == "left" then
			player:setDirection("right")
		elseif player.direction == "right" then
			player:setDirection("left")
		end
			
		
		--print("event.x: ", event.x, ", levelView.x: ", levelView.x, ", targetX: ", targetX)
		local bullet = Freeman9mmBullet:new(player.x + 4, player.y + 4, targetX, targetY)
		
		bullet:addEventListener("onRemoveFromGameLoop", self)
		levelView:insertChild(bullet)
		levelView.gameLoop:addLoop(bullet)
		--print("x: ", event.x, ", y: ", event.y, ", bx: ", bullet.x, ", by: ", bullet.y, ", tx: ", targetX, ", ty: ", targetY)
	end
	
	function state:onRemoveFromGameLoop(event)
		levelView.gameLoop:removeLoop(event.target)
	end
	
	return state
end

return PlayerFreemanState