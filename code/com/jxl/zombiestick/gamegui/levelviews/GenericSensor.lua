GenericSensor = {}

function GenericSensor:new(params)
	local genericSensor = display.newRect(0, 0, params.width, params.height)
	genericSensor:setReferencePoint(display.TopLeftReferencePoint)
	genericSensor.strokeWidth = 2
	genericSensor:setFillColor(255, 0, 0, 0)
	genericSensor.classType = "GenericSensor"
	genericSensor.name = params.name
	genericSensor.x = params.x
	genericSensor.y = params.y
	
	function genericSensor:collision(event)
		if event.other.name == "JXL" then
			Runtime:dispatchEvent({name="onGenericSensorCollision", target=self, other=event.other})
			return true
		end
	end
	genericSensor:addEventListener("collision", genericSensor)
	
	physics.addBody( genericSensor, {isSensor = true, filter = { 
																	categoryBits = constants.COLLISION_FILTER_TERRAIN_CATEGORY, 
																	maskBits = constants.COLLISION_FILTER_TERRAIN_MASK
																}
									}
					)
	genericSensor.bodyType = "kinematic"
	
	return genericSensor
end

return GenericSensor