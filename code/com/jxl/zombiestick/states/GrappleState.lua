require "com.jxl.core.statemachine.BaseState"
GrappleState = {}

function GrappleState:new()
	
	local state = BaseState:new("grapple")
	state.touchJoint = nil
	
	function state:onEnterState(event)
		print("GrappleState::onEnterState")
		local player = self.entity
		player.isFixedRotation = false
		player.attacking = true
		
		player:showSprite("attack")
		player:performedAction("attack")
		
		local levelView = LevelView.instance
		local lc = levelView.levelChildren
		local grappleTarget = player.lastGrappleTarget
		
		local targetX, targetY
		--print("player.lastAttackX: ", player.lastAttackX)
		local localX, localY = levelView:localToContent(grappleTarget.x, grappleTarget.x)
		local touchJoint = physics.newJoint( "distance", player, grappleTarget, player.x,player.y, grappleTarget.x, grappleTarget.y)
		if touchJoint == nil then
			error("Failed to create touchJoint")
			return false
		end
		self.touchJoint = touchJoint
		--touchJoint.frequency = 0.5
		--touchJoint.dampingRatio = 0
		
		player:setLinearVelocity( 0, 6)
	end
	
	function state:onExitState(event)
		print("GrappleState::onExitState")
		local player = self.entity
		local grappleLine = self.grappleLine
		if grappleLine ~= nil then
			self.grappleLine = nil
			grappleLine:removeSelf()
		end
		self.touchJoint:removeSelf()
		
		player:setLinearVelocity( 0, 0 )
		player.angularVelocity = 0
		player.isFixedRotation = true
		player.rotation = 0
		player:applyLinearImpulse(0, -10, player.width / 2, player.height / 2)
	end
	
	function state:tick(time)
		local touchJoint = self.touchJoint
		if touchJoint == nil then
			return
		end
		
		local minX, minY = touchJoint:getAnchorB()
		local player = self.entity
		
		local grappleLine = self.grappleLine
		if grappleLine ~= nil then
			grappleLine:removeSelf()
		end
		grappleLine = display.newLine(player.x + (player.width / 2), player.y + (player.height / 2), minX, minY)
		grappleLine.width = 3
		grappleLine:setColor(0, 0, 0)
		self.grappleLine = grappleLine
		--LevelView.instance:insertChild(grappleLine)
		
		touchJoint.length = touchJoint.length - 3
		if touchJoint.length < 2 then
			self.stateMachine:changeStateToAtNextTick("ready")
			return
		end
		print("touchJoint.length: ", touchJoint.length)
	end
	
	return state
	
end

return GrappleState