require "com.jxl.zombiestick.constants"

Firehose = {}

function Firehose:new(params, direction)
	local firehose = display.newImage("firehose.png")
	firehose:setReferencePoint(display.TopLeftReferencePoint)
	firehose.classType = "Firehose"
	firehose.name = "Firehose"
	firehose.x = params.x
	firehose.y = params.y
	firehose.rotation = params.rotation
	physics.addBody(firehose, "static", { density=params.density, friction=params.friction, bounce=params.bounce,
	 		isSensor = true,
			filter = { categoryBits = constants.COLLISION_FILTER_TERRAIN_CATEGORY, 
						maskBits = constants.COLLISION_FILTER_TERRAIN_MASK }} )				
	return firehose
end

return Firehose