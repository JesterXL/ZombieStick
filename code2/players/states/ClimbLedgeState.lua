require "utils.BaseState"

ClimbLedgeState = {}

function ClimbLedgeState:new()
	local state = BaseState:new("climbLedge")
	state.reachedYTarget = nil
	state.currentLedge = nil
	
	function state:onEnterState(event)
		print("climbLedgeState::onEnterState")
		local player = self.entity
		player:showSprite("climb")
		player.bodyType = "kinematic"
		self.reachedYTarget = false
		player.angularVelocity = 0
		player:setLinearVelocity(0, 0)
		self.currentLedge = player.lastLedge
	end
	
	function state:onExitState(event)
		local player = self.entity
		player.bodyType = "dynamic"
		player.lastLedge = nil
		self.currentLedge = nil
	end

	function state:tick(time)
		local player = self.entity
		local speed = player.climbSpeed
		if speed <= 0 then
			error("Speed cannot be less than or equal to 0")
		end

		-- local ledge = player.lastLedge
		local ledge = self.currentLedge
		if ledge == nil then
			error("Ledge is nil.")
		end

		local targetX = ledge.x
		local targetY = ledge.y - ledge.height / 2 - player.height / 2

		local deltaX = player.x - targetX
		local deltaY = player.y - targetY
		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
		local moveX = speed * (deltaX / dist) * time
		local moveY = speed * (deltaY / dist) * time

		if (math.abs(moveX) > dist or math.abs(moveY) > dist) then
			player.x = targetX
			player.y = targetY
			self.stateMachine:changeStateToAtNextTick("ready")
		else
			-- if self.reachedYTarget then
				player.x = player.x - moveX
			-- end
			player.y = player.y - moveY
		end
	end

	return state
end

return ClimbLedgeState