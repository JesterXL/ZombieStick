ButtonLeft = {}

function ButtonLeft:new()
	local button = display.newImage("assets/buttons/button-move-left.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	
	function button:touch(event)
		if event.phase == "began" then
			Runtime:dispatchEvent({name="onMoveLeftStarted"})
		elseif event.phase == "ended" then
			Runtime:dispatchEvent({name="onMoveLeftEnded"})
		end
		return true
	end

	button:addEventListener("touch", button)

	return button
end

return ButtonLeft