ButtonClimbDown = {}

function ButtonClimbDown:new()
	local button = display.newImage("assets/buttons/button-down.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	
	function button:touch(event)
		local p = event.phase
		if p == "began" then
			Runtime:dispatchEvent({name = "onClimbDownStarted"})
		else
			Runtime:dispatchEvent({name = "onClimbDownEnded"})
		end
		return true
	end
	button:addEventListener("touch", button)

	return button
end

return ButtonClimbDown