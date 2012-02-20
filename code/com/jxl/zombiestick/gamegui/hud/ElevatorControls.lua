ElevatorControls = {}

function ElevatorControls:new(x, y)
	
	local elevatorControls = display.newGroup()
	elevatorControls.upButton = display.newImage("button-up.png")
	elevatorControls.upButton:addEventListener("touch", elevatorControls)
	elevatorControls:insert(elevatorControls.upButton)
	
	elevatorControls.downButton = display.newImage("button-down.png")
	elevatorControls.downButton:addEventListener("touch", elevatorControls)
	elevatorControls.downButton.y = elevatorControls.upButton.y + elevatorControls.upButton.height + 8
	elevatorControls:insert(elevatorControls.downButton)
	
	function elevatorControls:touch(event)
		if event.phase == "began" then
			if event.target == elevatorControls.upButton then
				self:dispatchEvent({name="onUpElevatorButtonTouched", target=self})
				return true
			elseif event.target == elevatorControls.downButton then
				self:dispatchEvent({name="onDownElevatorButtonTouched", target=self})
				return true
			end
		end
	end
	
	return elevatorControls
end

return ElevatorControls