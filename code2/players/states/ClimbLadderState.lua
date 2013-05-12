require "utils.BaseState"
ClimbLadderState = {}

function ClimbLadderState:new()
	local state = BaseState:new("climbLadder")
	
	function state:onEnterState(event)
		print("ClimbLadderState::onEnterState")
		local player = self.entity
		
		player:showSprite("climb")
		
		Runtime:addEventListener("onMoveLeftStarted", self)
		Runtime:addEventListener("onMoveRightStarted", self)
		
		Runtime:addEventListener("onJumpRightStarted", self)
		Runtime:addEventListener("onJumpLeftStarted", self)

		Runtime:addEventListener("onClimbUpStarted", self)
		Runtime:addEventListener("onClimbDownStarted", self)
		Runtime:addEventListener("onClimbUpEnded", self)
		Runtime:addEventListener("onClimbDownEnded", self)

		player.bodyType = "kinematic"
	end
	
	function state:onExitState(event)
		local player = self.entity
		player.climbDirection = nil
		player.bodyType = "dynamic"
		
		Runtime:removeEventListener("onMoveLeftStarted", self)
		Runtime:removeEventListener("onMoveRightStarted", self)
		
		Runtime:removeEventListener("onJumpRightStarted", self)
		Runtime:removeEventListener("onJumpLeftStarted", self)

		Runtime:removeEventListener("onClimbUpStarted", self)
		Runtime:removeEventListener("onClimbDownStarted", self)
		Runtime:removeEventListener("onClimbUpEnded", self)
		Runtime:removeEventListener("onClimbDownEnded", self)
	end
	
	function state:tick(time)
		local player = self.entity
		if player.climbDirection == nil then
			return true
		end
		self:handleClimb(time)
	end
	
	function state:handleClimb(time)
		local player = self.entity
		local speed = player.climbSpeed
		if speed <= 0 then return true end

		local lastLadder = player.lastLadder
		if lastLadder == nil then
			error("ERROR: last ladder is nil.")
			return true
		end

		local ladderTop = (lastLadder.y - lastLadder.height / 2) - (player.height / 2)
		local ladderBottom = lastLadder.y + lastLadder.height / 2
		local targetX = lastLadder.x
		local targetY
		if player.climbDirection == "down" then
			targetY = player.y + speed
		elseif player.climbDirection == "up" then
			targetY = player.y - speed
		else
			targetY = 0
		end

		if targetY < ladderTop then
			player.y = ladderTop
			return true
		end

		print("targetY:", targetY, ", ladderBottom:", ladderBottom, ", player.y:", player.y, ", ladder.y:", lastLadder.y)
		if targetY + player.height > ladderBottom then
			print("player.height:", player.height)
			player.y = ladderBottom - player.height
			return true
		end

		local deltaX = player.x - targetX
		local deltaY = player.y - targetY

		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
		print("dist:", dist)
		if dist == 0 then return true end
		local moveX = speed * (deltaX / dist) * time
		local moveY = speed * (deltaY / dist) * time
		print("moveY:", moveY)

		if math.abs(moveX) > dist then
			player.x = targetX
		else
			player.x = player.x - moveX
		end

		if math.abs(moveY) > dist then
			player.y = targetY
		else
			player.y = player.y - moveY
		end
	end
	
	function state:onClimbUpStarted(event)
		self.entity.climbDirection = "up"
	end

	function state:onClimbUpEnded(event)
		self.entity.climbDirection = nil
	end

	function state:onClimbDownStarted(event)
		self.entity.climbDirection = "down"
	end

	function state:onClimbDownEnded(event)
		self.entity.climbDirection = nil
	end


	function state:onMoveLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("movingLeft")
	end
	
	function state:onMoveRightStarted(event)
		self.stateMachine:changeStateToAtNextTick("movingRight")
	end
	
	function state:onJumpLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpLeft")
	end
	
	function state:onJumpRightStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpRight")
	end

	
	return state
end

return ClimbLadderState