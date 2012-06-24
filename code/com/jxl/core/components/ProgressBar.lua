ProgressBar = {}
 
function ProgressBar:new(backRed, backGreen, backBlue, frontRed, frontGreen, frontBlue)
	local group = display.newGroup()

	local backBar = display.newRect(0, 0, 35, 6)
	group:insert(backBar)
	backBar:setFillColor(backRed, backGreen, backBlue)
	backBar:setStrokeColor(0, 0, 0)
	backBar.strokeWidth = 1
 
	local frontBar = display.newRect(0, 0, 35, 6)
	frontBar:setReferencePoint(display.TopLeftReferencePoint)
	group:insert(frontBar)
	frontBar:setFillColor(frontRed, frontGreen, frontBlue)
	frontBar:setStrokeColor(0, 0, 0)
	frontBar.strokeWidth = 1
 
	function group:setProgress(current, max)
		if current == nil then
			error("parameter 'current' cannot be nil.")
		end

		if max == nil then
			error("parameter 'max' cannot be nil")
		end
		
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