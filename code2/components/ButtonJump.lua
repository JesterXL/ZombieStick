ButtonJump = {}

function ButtonJump:new()
	local button = display.newImage("assets/buttons/button-jump.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	
	function button:touch(event)
		if event.phase == "began" then
			Runtime:dispatchEvent({name="onJumpStarted"})
		elseif event.phase == "ended" then
			Runtime:dispatchEvent({name="onJumpEnded"})
		end
		return true
	end

	button:addEventListener("touch", button)

	return button
end

return ButtonJump