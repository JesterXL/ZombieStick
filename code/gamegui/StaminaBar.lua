StaminaBar = {}
 
function StaminaBar:new()
	local group = display.newGroup()
 
	local redBar = display.newRect(0, 0, 35, 6)
	group:insert(redBar)
	redBar:setFillColor(255, 0, 0)
 
	local greenBar = display.newRect(0, 0, 35, 6)
	greenBar:setReferencePoint(display.TopLeftReferencePoint)
	group:insert(greenBar)
	greenBar:setFillColor(0, 255, 0)
 
	function group:setStamina(current, max)
		local percent = current / max
		local desiredWidth = 35 * percent
		if percent ~= 0 then
			greenBar.xScale = percent
			greenBar.isVisible = true
		else
			greenBar.isVisible = false
		end
		greenBar.x = redBar.x + greenBar.xReference
	end
 
	return group
end
 
return StaminaBar