ButtonJumpLeft = {}

function ButtonJumpLeft:new()
	local button = display.newImage("assets/buttons/button-jump-left.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	
	function button:touch(event)
		if event.phase == "began" then
			Runtime:dispatchEvent({name="onJumpLeftStarted"})
		elseif event.phase == "ended" then
			Runtime:dispatchEvent({name="onJumpLeftEnded"})
		end
		return true
	end

	button:addEventListener("touch", button)

	return button
end

return ButtonJumpLeft