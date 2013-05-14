GenericSensor = {}

function GenericSensor:new(params)
	local genericSensor = display.newRect(0, 0, params.width, params.height)
	genericSensor:setReferencePoint(display.TopLeftReferencePoint)
	genericSensor.strokeWidth = 2
	genericSensor:setFillColor(255, 0, 0)
	genericSensor.classType = "GenericSensor"
	genericSensor.customName = params.customName
	genericSensor.x = params.x
	genericSensor.y = params.y
	genericSensor.targetDoor = params.targetDoor
	genericSensor.targetMovie = params.targetMovie
	mainGroup:insert(genericSensor)
	
	function genericSensor:collision(event)
		if event.other.classType == "PlayerJXL" then
			Runtime:dispatchEvent({name="onGenericSensorCollision", target=self, other=event.other, phase=event.phase})
			return true
		end
	end
	genericSensor:addEventListener("collision", genericSensor)
	
	-- physics.addBody( genericSensor, {isSensor = true, 
	-- 	filter = { 
	-- 																categoryBits = constants.COLLISION_FILTER_TERRAIN_CATEGORY, 
	-- 																maskBits = constants.COLLISION_FILTER_TERRAIN_MASK
	-- 															}
	-- 								}
	-- 				)
	physics.addBody(genericSensor, "static", {isSensor=true})
	
	return genericSensor
end

return GenericSensor