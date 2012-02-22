ElevatorSwitch = {}

function ElevatorSwitch:new(params)

	--local switch = display.newImage("elevator-switch.png")
	local switch = display.newRect(0, 0, 20, 20)
	switch.x = params.x
	switch.y = params.y
	switch.classType = "ElevatorSwitch"
	switch.targetElevator = params.targetElevator
	
	function switch:collision(event)
		if event.other.classType == "PlayerJXL" or event.other.classType == "PlayerFreeman" then
			Runtime:dispatchEvent({name="onElevatorSwitchCollision", target=self, phase=event.phase})
		end
	end
	
	physics.addBody(switch, "kinematic", {filter = { categoryBits = constants.COLLISION_FILTER_TERRAIN_CATEGORY,
				maskBits = constants.COLLISION_FILTER_TERRAIN_MASK
			 }})
	switch.isSensor = true 
	switch:addEventListener("collision", switch)
	
	return switch
	
end


return ElevatorSwitch