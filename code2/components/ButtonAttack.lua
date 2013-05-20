ButtonAttack = {}

function ButtonAttack:new()
	
	local button = display.newImage("assets/buttons/button-attack.png")
	button:setReferencePoint(display.TopLeftReferencePoint)

	function button:touch(event)
		if event.phase == "ended" then
			Runtime:dispatchEvent({name="onAttackStarted"})
		end
		return true
	end

	button:addEventListener("touch", button)
	
	return button
	
end

return ButtonAttack