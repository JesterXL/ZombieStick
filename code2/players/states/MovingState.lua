require "utils.BaseState"
MovingState = {}

function MovingState:new(stateName)
	local state = BaseState:new(stateName)
	state.player = nil
	
	
	function state:onEnterState(event)
		local player = self.entity
		
		-- player.startMoveTime = system.getTimer()
		
		Runtime:addEventListener("onMoveLeftEnded", self)
		Runtime:addEventListener("onMoveRightEnded", self)
	end
	
	function state:onExitState(event)
		local player = self.entity
		-- player:stopMoving()
		
		Runtime:removeEventListener("onMoveLeftEnded", self)
		Runtime:removeEventListener("onMoveRightEnded", self)
	end
	
	function state:tick(time)
		local player = self.entity
		self:handleMove(time)
		-- if system.getTimer() - player.startMoveTime >= player.MOVE_STAMINA_TIME then
		-- 	player:reduceStamina(player.moveStamina)
		-- 	player.startMoveTime = system.getTimer()
		-- end
	end
	
	function state:handleMove(time)
		local player = self.entity
		local speed = player.speed
		if speed <= 0 then return true end
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
	
	function state:onMoveLeftEnded(event)
		self.stateMachine:changeStateToAtNextTick("ready")
	end
	
	function state:onMoveRightEnded(event)
		self.stateMachine:changeStateToAtNextTick("ready")
	end
	
	return state
end

return MovingState