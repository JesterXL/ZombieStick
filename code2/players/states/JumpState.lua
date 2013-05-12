require "utils.BaseState"
JumpState = {}

function JumpState:new(stateName)
	if stateName == nil or stateName == "" then
		stateName = "jump"
	end
	local state = BaseState:new(stateName)
	state.readyToLand = nil
	state.hitALandableTarget = nil
	state.canCheckForCollisions = nil
	
	function state:onEnterState(event)
		print("JumpState::onEnterState")
		self.readyToLand = false
		self.hitALandableTarget = false
		self.canCheckForCollisions = false
		
		local player = self.entity
		player:addEventListener("collision", self)
		player:showSprite("jump")
		player.lastJump = system.getTimer()
		
		player:applyLinearImpulse(0,-10,player.x, player.y)

		self:checkForLedgeHit()
	end
	
	function state:onExitState(event)
		print("JumpState::onExitState")
		local player = self.entity
		player:removeEventListener("collision", self)
	end
	
	function state:tick(time)
		local player = self.entity
		if self.canCheckForCollisions == false then
			if system.getTimer() - player.lastJump >= 300 then
				self.canCheckForCollisions = true
			end
		end

		if self:checkForLedgeHit() then
			return true
		end

		if self.readyToLand == false and system.getTimer() - player.lastJump >= player.JUMP_INTERVAL then
			self.readyToLand = true
			self:resolveEndJump()
		end
	end
	
	function state:collision(event)
		--print("JumpState::collision")
		local player = self.entity
		local target = event.other.classType
		-- print(target)
		if self:checkForLedgeHit() then
			return true
		end

		if self.canCheckForCollisions == false then return true end

		
		--showProps(event.other)
		-- print("target:", target)
		
		if target == "Floor" or target == "Crate" or target == "Table" or target == "Chair" or target == "Elevator" then
			-- print("hit a floor")
			--player:removeEventListener("collision", self)
			self.hitALandableTarget = true
			self:resolveEndJump()
			return true
		end
	end

	function state:resolveEndJump()
		if self.readyToLand and self.hitALandableTarget then
			local player = self.entity
			player:showSprite("stand")
			self.stateMachine:changeStateToAtNextTick("ready")
		end
	end

	function state:checkForLedgeHit()
		local player = self.entity
		if player.lastLedge ~= nil then
			self.stateMachine:changeStateToAtNextTick("climbLedge")
			return true
		end
		return false
	end
	
	return state
end

return JumpState