require "players.states.JumpState"

JumpLeftState = {}

function JumpLeftState:new()
	local state = JumpState:new("jumpLeft")
	state.xForce = nil
	
	function state:onEnterState(event)
		print("JumpLeftState::onEnterState")
		self.hitLedge = false
		self.readyToLand = false
		self.hitALandableTarget = false
		self.canCheckForCollisions = false
		
		local player = self.entity
		player:addEventListener("collision", self)
		player:showSprite("jump")
		player.lastJump = system.getTimer()
		
		player:applyLinearImpulse(-1 * constants.PLAYER_JUMP_XFORCE, constants.PLAYER_JUMP_YFORCE,player.x, player.y)
	end
	
	
	return state
	
end

return JumpLeftState