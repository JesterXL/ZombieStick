ProgressBar = {}
 
function ProgressBar:new(backColors, frontColors)
	local group = display.newGroup()
 
	local backBar = display.newRect(0, 0, 35, 6)
	group:insert(backBar)
	backBar:setFillColor(255, 0, 0)
 
	local frontBar = display.newRect(0, 0, 35, 6)
	frontBar:setReferencePoint(display.TopLeftReferencePoint)
	group:insert(frontBar)
	frontBar:setFillColor(0, 255, 0)
 
	function group:setStamina(current, max)
		local percent = current / max
		local desiredWidth = 35 * percent
		if percent ~= 0 then
			frontBar.xScale = percent
			frontBar.isVisible = true
		else
			frontBar.isVisible = false
		end
		frontBar.x = backBar.x + frontBar.xReference
	end
 
	return group
end
 
return ProgressBar