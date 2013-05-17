ButtonHeal = {}

function ButtonHeal:new()
	local button = display.newImage("assets/buttons/button-heal.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	
	function button:touch(event)
		if event.phase == "ended" then
			Runtime:dispatchEvent({name="onHeal"})
		end
		return true
	end

	button:addEventListener("touch", button)

	return button
end

return ButtonHeal