require "players.states.JumpState"

JumpRightState = {}

function JumpRightState:new()
	local state = JumpState:new("jumpRight")
	state.xForce = nil
	
	function state:onEnterState(event)
		print("JumpRightState::onEnterState")
		self.hitLedge = false
		self.readyToLand = false
		self.hitALandableTarget = false
		self.canCheckForCollisions = false
		
		local player = self.entity
		player:addEventListener("collision", self)
		player:showSprite("jump")
		player.lastJump = system.getTimer()
		
		player:applyLinearImpulse(5,-8,player.x, player.y)
	end
	
	
	return state
	
end

return JumpRightState