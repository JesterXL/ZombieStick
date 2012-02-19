Door = {}

function Door:new(params)
	local door = display.newRect(0, 0, params.width, params.height)
	door:setReferencePoint(display.TopLeftReferencePoint)
	door.strokeWidth = 2
	door:setFillColor(255, 0, 0, 100)
	door.classType = "Door"
	door.name = params.customName
	door.targetDoor = params.targetDoor
	--print("Door, name: ", params.customName, ", targetDoor: ", params.targetDoor)
	door.x = params.x
	door.y = params.y
	
	function door:collision(event)
		--print("*** collision, classType: ", event.other.classType, ", phase: ", event.phase)
		if event.other.classType == "PlayerJXL" or event.other.classType == "PlayerFreeman" then
			Runtime:dispatchEvent({name="onDoorCollision", target=self, other=event.other, phase=event.phase})
			return true
		end
	end
	door:addEventListener("collision", door)
	
	physics.addBody( door, {isSensor = true, filter = { 
														categoryBits = constants.COLLISION_FILTER_TERRAIN_CATEGORY, 
														maskBits = constants.COLLISION_FILTER_TERRAIN_MASK
													}
									}
					)
	door.bodyType = "kinematic"
	
	return door
end

return Door