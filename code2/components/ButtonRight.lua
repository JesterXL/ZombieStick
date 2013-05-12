ButtonRight = {}

function ButtonRight:new()
	local button = display.newImage("assets/buttons/button-move-right.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	
	function button:touch(event)
		if event.phase == "began" then
			print("ButtonRight::onMoveRightStarted")
			Runtime:dispatchEvent({name="onMoveRightStarted"})
		elseif event.phase == "ended" then
			Runtime:dispatchEvent({name="onMoveRightEnded"})
		end
		return true
	end

	button:addEventListener("touch", button)

	return button
end

return ButtonRight