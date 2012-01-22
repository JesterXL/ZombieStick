GrappleTarget = {}

function GrappleTarget:new(x, y)
	local grappleTarget = display.newCircle(0, 0, 20)
	grappleTarget.strokeWidth = 2
	grappleTarget:setFillColor(0, 255, 0, 100)
	grappleTarget.classType = "GrappleTarget"
	grappleTarget.x = x
	grappleTarget.y = y		
	
	physics.addBody( grappleTarget, {isSensor = true } )
	grappleTarget.bodyType = "kinematic"
	
	return grappleTarget
end

return GrappleTarget