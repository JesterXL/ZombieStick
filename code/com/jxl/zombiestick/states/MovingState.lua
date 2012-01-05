require "com.jxl.core.statemachine.BaseState"
MovingState = {}

function MovingState:new()
	local state = BaseState:new("moving")
	state.player = nil
	
	
	function state:onEnterState(event)
		print("MovingState::onEnterState")
		local player = event.data[1]
		local direction = event.data[2]
		self.player = player
		player.startMoveTime = system.getTimer()
		player:setDirection(direction)
		player:showSprite("move")
	end
	
	function state:onExitState(event)
		print("MovingState::onEnterState")
		
		local player = self.player
		local force
		if player.direction == "right" then
			force = player.speed
		else
			force = -player.speed
		end
		player:applyLinearImpulse(force / 3, 0, 40, 32)
		
		self.player = nil
	end
	
	function state:tick(time)
		local player = self.player
		self:handleMove(time)
		if system.getTimer() - player.startMoveTime >= player.MOVE_STAMINA_TIME then
			player:reduceStamina(player.moveStamina)
			player.startMoveTime = system.getTimer()
		end
		
	end
	
	function state:handleMove(time)
		local player = self.player
		local speed = player.speed
		local targetX
		local targetY = player.y
		if player.direction == "right" then
			targetX = player.x + speed
		elseif player.direction == "left" then
			targetX = player.x - speed
		else
			targetX = 0
		end

		local deltaX = player.x - targetX
		local deltaY = player.y - targetY
		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
		local moveX = speed * (deltaX / dist) * time
		local moveY = speed * (deltaY / dist) * time

		if (math.abs(moveX) > dist or math.abs(moveY) > dist) then
			player.x = targetX
			player.y = targetY
		else
			player.x = player.x - moveX
			player.y = player.y - moveY
		end
	end
	
	return state
end

return MovingState