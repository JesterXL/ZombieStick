ProgressBar = {}
 
function ProgressBar:new(parentGroup, layoutWidth, layoutHeight, backColors, frontColors)
	local group = display.newGroup()
	parentGroup:insert(group)

	local backBar = display.newRect(0, 0, layoutWidth, layoutHeight)
	group:insert(backBar)
	backBar:setFillColor(unpack(backColors))
	backBar:setStrokeColor(0, 0, 0)
	backBar.strokeWidth = 1
 
	local frontBar = display.newRect(0, 0, layoutWidth, layoutHeight)
	frontBar:setReferencePoint(display.TopLeftReferencePoint)
	group:insert(frontBar)
	frontBar:setFillColor(unpack(frontColors))
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
		-- [jwarden 5.15.2013] TODO: Why did I minus 1 here?
		local desiredWidth = (layoutWidth - 1) * percent
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