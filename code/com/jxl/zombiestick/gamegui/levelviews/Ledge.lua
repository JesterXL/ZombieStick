Ledge = {}

function Ledge:new(x, y)
	local ledge = display.newRect(0, 0, 20, 20)
	ledge:setReferencePoint(display.TopLeftReferencePoint)
	ledge.strokeWidth = 2
	ledge:setFillColor(0, 255, 0, 100)
	ledge.classType = "Ledge"
	ledge.name = "Ledge"
	ledge.x = x
	ledge.y = y		
	
	physics.addBody( ledge, {isSensor = true,
								filter = { categoryBits = constants.COLLISION_FILTER_LEDGE_CATEGORY, 
										   maskBits = constants.COLLISION_FILTER_LEDGE_MASK
										 }
							} 
					)
	ledge.bodyType = "kinematic"
	
	return ledge
end

return Ledge