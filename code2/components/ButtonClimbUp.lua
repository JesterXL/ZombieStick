ButtonClimbUp = {}

function ButtonClimbUp:new()
	local button = display.newImage("assets/buttons/button-up.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	
	function button:touch(event)
		local p = event.phase
		if p == "began" then
			Runtime:dispatchEvent({name = "onClimbUpStarted"})
		else
			Runtime:dispatchEvent({name = "onClimbUpEnded"})
		end
		return true
	end
	button:addEventListener("touch", button)

	return button
end

return ButtonClimbUp