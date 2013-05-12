Ledge = {}

function Ledge:new(x, y, exitDirection)
	local ledge = display.newRect(0, 0, 20, 20)
	ledge:setReferencePoint(display.TopLeftReferencePoint)
	ledge.strokeWidth = 2
	ledge:setFillColor(0, 255, 0)
	ledge.classType = "Ledge"
	mainGroup:insert(ledge)
	ledge.x = x
	ledge.y = y		
	ledge.exitDirection = exitDirection
	
	-- physics.addBody( ledge, {isSensor = true,
	-- 							filter = { categoryBits = constants.COLLISION_FILTER_LEDGE_CATEGORY, 
	-- 									   maskBits = constants.COLLISION_FILTER_LEDGE_MASK
	-- 									 }
	-- 						} 
	-- 				)
	physics.addBody(ledge, {isSensor=true})
	ledge.bodyType = "static"
	function ledge:collision(event)
		if event.other.classType == "PlayerJXL" then
			if event.phase == "began" then
				Runtime:dispatchEvent({name="onLedgeCollideBegan", target=self})
			elseif event.phase == "ended" then
				Runtime:dispatchEvent({name="onLedgeCollideEnded", target=self})
			end
		end
		return true
	end
	ledge:addEventListener("collision", ledge)
	
	return ledge
end

return Ledge