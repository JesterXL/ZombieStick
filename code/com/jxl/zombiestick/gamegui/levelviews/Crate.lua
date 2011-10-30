require "com.jxl.zombiestick.constants"

Crate = {}

function Crate:new(params)
	local crate = display.newImage("crate.png")
	crate.classType = "Crate"
	crate.name = "Crate"
	crate.x = params.x
	crate.y = params.y
	crate.rotation = params.rotation
	physics.addBody(crate, { density=params.density, friction=params.friction, bounce=params.bounce, 
			filter = { categoryBits = constants.COLLISION_FILTER_TERRAIN_CATEGORY, 
						maskBits = constants.COLLISION_FILTER_TERRAIN_MASK }} )				
	return crate
end

return Crate