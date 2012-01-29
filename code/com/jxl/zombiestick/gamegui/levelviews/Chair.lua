require "com.jxl.zombiestick.constants"

Chair = {}

function Chair:new(params, direction)
	local chair
	if direction == "left" then
		chair = display.newImage("chair-left.png")
	elseif direction == "right" then
		chair = display.newImage("chair-right.png")
	end
	--chair:setReferencePoint(display.TopLeftReferencePoint)
	chair.classType = "Table"
	chair.name = "Table"
	chair.x = params.x
	chair.y = params.y
	chair.rotation = params.rotation
	physics.addBody(chair, { density=params.density, friction=params.friction, bounce=params.bounce, 
			filter = { categoryBits = constants.COLLISION_FILTER_TERRAIN_CATEGORY, 
						maskBits = constants.COLLISION_FILTER_TERRAIN_MASK }} )				
	return chair
end

return Chair