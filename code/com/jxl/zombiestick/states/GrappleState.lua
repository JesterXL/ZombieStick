require "com.jxl.core.statemachine.BaseState"
GrappleState = {}

function GrappleState:new()
	
	local state = BaseState:new("grapple")
	state.touchJoint = nil
	
	function state:onEnterState(event)
		print("GrappleState::onEnterState")
		local player = self.entity
		
		player.attacking = true
		
		player:showSprite("attack")
		player:performedAction("attack")
		
		local levelView = LevelView.instance
		local lc = levelView.levelChildren
		
		local targetX, targetY
		--print("player.lastAttackX: ", player.lastAttackX)
		local localX, localY = levelView:localToContent(player.lastAttackX, player.lastAttackY)
		local variance = 80
		targetX = localX + (lc.x * -1) + (math.random() * variance) - (variance / 2)
		targetY = localY + (lc.y * -1) + (math.random() * variance) - (variance / 2)
		-- SWALLOWS exception in here somewhere.....
		local touchJoint = physics.newJoint( "touch", player, targetX, targetY )
		self.touchJoint = touchJoint
		
	end
	
	function state:onExitState(event)
		print("GrappleState::onExitState")
		local grappleLine = self.grappleLine
		if grappleLine ~= nil then
			self.grappleLine = nil
			grappleLine:removeSelf()
		end
		self.touchJoint:removeSelf()
	end
	
	function state:tick(time)
		
		local touchJoint = self.touchJoint
		if touchJoint == nil then
			return
		end
		
		local minX, minY = touchJoint:getAnchorA()
	 	local maxX, maxY = touchJoint:getAnchorB()
		local player = self.entity
		local levelView = LevelView.instance
		
		local grappleLine = self.grappleLine
		if grappleLine ~= nil then
			grappleLine:removeSelf()
		end
		
		grappleLine = display.newLine(levelView, minX, minY, maxX, maxY)
		grappleLine.width = 2
		grappleLine:setColor(0, 0, 0)
		self.grappleLine = grappleLine
	end
	
	return state
	
end

return GrappleState