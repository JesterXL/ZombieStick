require "utils.BaseState"
JumpState = {}

function JumpState:new(stateName)
	if stateName == nil or stateName == "" then
		stateName = "jump"
	end
	local state = BaseState:new(stateName)
	state.hitLedge = nil
	state.ledge = nil
	state.readyToLand = nil
	state.hitALandableTarget = nil
	state.canCheckForCollisions = nil
	
	function state:onEnterState(event)
		print("JumpState::onEnterState")
		self.hitLedge = false
		self.readyToLand = false
		self.hitALandableTarget = false
		self.canCheckForCollisions = false
		
		local player = self.entity
		player:addEventListener("collision", self)
		player:showSprite("jump")
		player.lastJump = system.getTimer()
		
		player:applyLinearImpulse(0,-10,player.x, player.y)
	end
	
	function state:onExitState(event)
		print("JumpState::onExitState")
		local player = self.entity
		player:removeEventListener("collision", self)
		self.ledge = nil
	end
	
	function state:tick(time)
		local player = self.entity
		if self.canCheckForCollisions == false then
			if system.getTimer() - player.lastJump >= 300 then
				self.canCheckForCollisions = true
			end
		end

		if self.hitLedge == false then
			if self.readyToLand == false and system.getTimer() - player.lastJump >= player.JUMP_INTERVAL then
				self.readyToLand = true
				self:resolveEndJump()
			end
		else
			local ledge = self.ledge
			print("ledge.exitDirection: ", ledge.exitDirection)
			if ledge.exitDirection == "right" then
				player.x = ledge.x + ledge.width
			else
				player.x = ledge.x - player.width
			end
			player.y = self.ledge.y - player.height
			player.angularVelocity = 0
			player:setLinearVelocity(0, 0)
			self.stateMachine:changeStateToAtNextTick("ready")
		end
	end
	
	function state:collision(event)
		print("JumpState::collision")
		if self.canCheckForCollisions == false then return true end
		
		local player = self.entity
		local target = event.other.classType
		--showProps(event.other)
		print("target:", target)
		if target == "Floor" or target == "Crate" or target == "Table" or target == "Chair" or target == "Elevator" then
			print("hit a floor")
			player:removeEventListener("collision", self)
			self.hitALandableTarget = true
			self:resolveEndJump()
			return true
		elseif event.other.name == "Ledge" then
			self.hitLedge = true
			self.ledge = event.other
			player:removeEventListener("collision", self)
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
	
	return state
end

return JumpState