ButtonJumpRight = {}

function ButtonJumpRight:new()
	local button = display.newImage("assets/buttons/button-jump-right.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	
	function button:touch(event)
		if event.phase == "began" then
			Runtime:dispatchEvent({name="onJumpRightStarted"})
		elseif event.phase == "ended" then
			Runtime:dispatchEvent({name="onJumpRightEnded"})
		end
		return true
	end

	button:addEventListener("touch", button)

	return button
end

return ButtonJumpRight