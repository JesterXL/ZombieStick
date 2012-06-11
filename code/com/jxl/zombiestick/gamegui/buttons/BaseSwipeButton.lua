BaseSwipeButton = {}

function BaseSwipeButton:new(startWidth, startHeight)
	local button = display.newGroup()
	button.MINIMUM_DISTANCE = 80

	--[[
		right 	= 180
		up 		= 90
		down 	= -90
		left 	= 0
	]]--

	local rect = display.newRect(0, 0, startWidth, startHeight)
	rect:setReferencePoint(display.TopLeftReferencePoint)
	rect:setFillColor(0, 255, 0, 100)
	button:insert(rect)

	function button.touch(event)
		if event.phase == "ended" then
			button:onEndSwipe(event)
		end
		return true
	end

	function button:getDistance(startX, startY, endX, endY)
		local a = startX - endX
		local b = startY - endY
		return math.sqrt(math.pow(a, 2) + math.pow(b, 2));
	end

	function button:getAngle(startX, startY, endX, endY)
		local angle = math.atan2(startY - endY, startX - endX)
		angle = math.deg(angle)
		return angle
	end
	
	function button:calculateEndValue(angle)
		if angle >= 70 and angle <= 110 then
			angle = 90
		elseif (angle >= -180 and angle <= -160) or (angle >= 160 and angle <= 180) then
			angle = 180
		elseif angle >= -110 and angle <= -70 then
			angle = -90
		elseif (angle >= -20 and angle <= 0) or (angle >= 0 and angle <= 20) then
			angle = 0
		elseif angle >= 25 and angle <= 65 then
			angle = 45
		elseif angle >= -65 and angle <= -25 then
			angle = -45
		elseif angle >= 115 and angle <= 155 then
			angle = 135
		elseif angle >= -155 and angle <= -115 then
			angle = -135
		else
			error("Unknown angle")
		end
		
		return angle
	end

	function button:onEndSwipe(event)
		local distance = self:getDistance(event.xStart, event.yStart, event.x, event.y)
		if distance >= self.MINIMUM_DISTANCE then
			local angle = self:getAngle(event.xStart, event.yStart, event.x, event.y)
			angle = self:calculateEndValue(angle)
			self:dispatchEvent({name="onSwipe", angle=angle, distance=distance, target=self})
		end
	end

	button:addEventListener("touch", button.touch)

	return button
end

return BaseSwipeButton