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
		
		player:showSprite("climb")
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
		
		player:applyLinearImpulse(0, -.5, player.width / 2, player.height / 2)
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
		
		--player:setLinearVelocity( 0, 0 )
		player.angularVelocity = 0
		player.isFixedRotation = true
		player.rotation = 0
		--player:applyLinearImpulse(0, -10, player.width / 2, player.height / 2)
	end
	
	function state:tick(time)
		local touchJoint = self.touchJoint
		if touchJoint == nil then
			return
		end
		
		local player = self.entity
		--local minX, minY = touchJoint:getAnchorB()
		local grappleTarget = player.lastGrappleTarget
		--local grappleX, grappleY = grappleTarget:localToContent(grappleTarget.x, grappleTarget.y)
		--local targetX, targetY = player:localToContent(player.x, player.y)
		--grappleX, grappleY = LevelView.instance:contentToLocal(grappleX, grappleY)
		--targetX, targetY = LevelView.instance:contentToLocal(targetX, targetY)
		local grappleX = grappleTarget.x
		local grappleY = grappleTarget.y
		local targetX = player.x - (player.width / 2)
		local targetY = player.y + (player.height / 4)
		grappleX, grappleY = LevelView.instance.levelChildren:localToContent(grappleX, grappleY)
		targetX, targetY = LevelView.instance.levelChildren:localToContent(targetX, targetY)
		
		--print("player.x: ", player.x, ", player.y: ", player.y, ", minX: ", minX, ", minY: ", minY)
		local grappleLine = self.grappleLine
		if grappleLine ~= nil then
			grappleLine:removeSelf()
		end
		grappleLine = display.newLine(grappleX, grappleY, targetX + (player.width / 2), targetY + (player.height / 2))
		grappleLine.width = 2
		grappleLine:setColor(0, 0, 0)
		self.grappleLine = grappleLine
		--LevelView.instance:insertChild(grappleLine)
		
		touchJoint.length = touchJoint.length - 1
		if touchJoint.length < 2 then
			self.stateMachine:changeStateToAtNextTick("ready")
			return
		end
		--print("touchJoint.length: ", touchJoint.length)
	end
	
	return state
	
end

return GrappleState