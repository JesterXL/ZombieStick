require "com.jxl.zombiestick.constants"
Floor = {}

function Floor:new(params)
	local floor = display.newRect(0, 0, params.width, params.height)
	floor.name = params.name
	floor:setReferencePoint(display.TopLeftReferencePoint)
	floor:setFillColor(0, 255, 0, 100)
	assert(physics.addBody(floor, "static", 
		{friction=.3, bounce=0,
			filter = { categoryBits = constants.COLLISION_FILTER_GROUND_CATEGORY,
			 maskBits = constants.COLLISION_FILTER_GROUND_MASK }}), 
			"Floor failed to add to physics.")
	floor.x = params.x
	floor.y = params.y
	return floor
end

return Floor