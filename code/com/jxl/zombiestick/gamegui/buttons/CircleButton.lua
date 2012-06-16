CircleButton = {}

function CircleButton:new(startWidth, startHeight)

	local buttons 			= display.newGroup()
	buttons.recording 		= false
	buttons.northHit 		= false
	buttons.eastHit 		= false
	buttons.westHit 		= false
	buttons.southHit 		= false
	buttons.hitList			= {}

	local CIRCLE_ALPHA 		= 100
	local BACKGROUND_ALPHA 	= 0

	local CLOCKWISE 		= "clockwise"
	local COUNTER 			= "counterclockwise"
	local NONE 				= "none"
	CircleButton.CLOCKWISE 	= CLOCKWISE
	CircleButton.COUNTER 	= COUNTER
	CircleButton.NONE 		= NONE

	local north, east, south, west

	function buttons:getCircleButton(buttonName)
		local circleSize = ((startWidth + startHeight) / 2) / 6
		local circleButton = display.newCircle(circleSize, circleSize, circleSize)
		circleButton.name = buttonName
		circleButton:setFillColor(255,0,0, CIRCLE_ALPHA)
		circleButton:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(circleButton)
		function circleButton:touch(event)
			if event.phase == "moved" then
				local hitName = self.name .. "Hit"
				local hit = buttons[hitName]
				buttons[hitName] = true
				return buttons:addButton(self)
			end
		end
		circleButton:addEventListener("touch", circleButton)
		return circleButton
	end

	function buttons:setSize(startWidth, startHeight)
		north.x = (startWidth / 2) - (north.width / 2)
	
		east.x = startWidth - east.width
		east.y = (startHeight / 2) - (east.height / 2)

		south.x = (startWidth / 2) - (south.width / 2)
		south.y = startHeight - south.height

		west.x = 0
		west.y = (startHeight / 2) - (west.height / 2)

		self:createBackground(startWidth, startHeight)
	end

	function buttons:createBackground(startWidth, startHeight)
		if self.background ~= nil then
			self.backround:removeSelf()
		end

		local MARGIN = 20

		local background = display.newRect(-MARGIN, -MARGIN, startWidth + MARGIN, startHeight + MARGIN)
		background.strokeWidth = 1
		background:setStrokeColor(255, 0, 0, BACKGROUND_ALPHA)
		background:setFillColor(0, 255, 0, BACKGROUND_ALPHA)
		self:insert(background)
		self.background = background
		background:toBack()

		function background:touch(event)
			if event.phase == "began" then
				buttons:reset()
			end
		end
		background:addEventListener("touch", background)
	end

	function buttons:reset()
		self.northHit 	= false
		self.eastHit	= false
		self.westHit 	= false
		self.southHit	= false
		self.hitList 	= {}
		self:dispatchEvent({name="onHitListChanged", target=self})
	end

	function buttons:allowedInOrder(lastButton, button)
		if button == nil then error("button cannot be nil") end

		local allowed = false
		if lastButton == self.north then
			if button == self.east or button == self.west then allowed = true end
		elseif lastButton == self.east then
			if button == self.north or button == self.south then allowed = true end
		elseif lastButton == self.south then
			if button == self.east or button == self.west then allowed = true end
		elseif lastButton == self.west then
			if button == self.north or button == self.south then allowed = true end
		end
		return allowed
	end

	function buttons:addButton(button)
		local hitList = self.hitList

		if self.northHit and self.eastHit and self.westHit and self.southHit and table.indexOf(hitList, button) == 1 then
			-- we've done a loop
			table.insert(hitList, button)
			return buttons:checkForSwipeAndComplete()
		end

		-- first, check to see if we are allowed to add the button
		-- only certain orders are allowed
		local allowed = false
		if #hitList > 0 then
			local lastButton = hitList[#hitList]
			allowed = self:allowedInOrder(lastButton, button)
			if allowed == false then
				-- if not allowed, then ignore, and pretend the person got off track with their finger dragging
				return false
			else
				-- double check not already added in case the user starts going the other way, if they do, reset
				if table.indexOf(hitList, button) ~= nil then
					print("\tresetting because button is already added and I think you're turning around")
					print("\thits: ", self.northHit, self.eastHit, self.southHit, self.westHit, " and len: ", #hitList)
					self:reset()
				end
				table.insert(hitList, button)
				self:dispatchEvent({name="onHitListChanged", target=self})
			end
		else
			-- this is our first, start
			table.insert(hitList, button)
			self:dispatchEvent({name="onHitListChanged", target=self})
		end

		-- are we done?
		self:checkForSwipeAndComplete()
	end

	function buttons:checkForSwipe()
		local hitList = self.hitList
		if hitList == nil then error("Cannnot check for swipe with a nil hitList.") end
		if #hitList < 5 then error("Cannot check for a swipe with less than 4 button hits.") end

		local first 	= hitList[1]
		local second 	= hitList[2]
		local third 	= hitList[3]
		local fourth 	= hitList[4]
		local fifth 	= hitList[5]

		-- now, check for the order; clockwise or counter clockwise?
		
		local direction = nil
		if first == self.north then
			if second == self.east and third == self.south and fourth == self.west and fifth == self.north then direction = CLOCKWISE
			elseif second == self.west and third == self.south and fourth == self.east then direction = COUNTER end
		elseif first == self.east then
			if second == self.south and third == self.west and fourth == self.north and fifth == self.east then direction = CLOCKWISE
			elseif second == self.north and third == self.west and fourth == self.south then direction = COUNTER end
		elseif first == self.south then
			if second == self.west and third == self.north and fourth == self.east and fifth == self.south then direction = CLOCKWISE
			elseif second == self.east and third == self.north and fourth == self.west then direction = COUNTER end
		elseif first == self.west then
			if second == self.north and third == self.east and fourth == self.south and fifth == self.west then direction = CLOCKWISE
			elseif second == self.south and third == self.east and fourth == self.north then direction = COUNTER end
		else
			direction = NONE
		end

		return direction
	end

	function buttons:checkForSwipeAndComplete()
		local hitList = self.hitList
		if #hitList > 4 then
			-- let's see if the user swiped, and in what direction
			local direction = self:checkForSwipe()
			if direction == CLOCKWISE or direction == COUNTER then
				self:reset()
				self:dispatchEvent({name = "onCircleSwipe", direction=direction, target=self})
				return true
			end
			--else
				-- hrm... we have 4 items, but they aren't in order?
			--	error("Somehow we have 4 items out of order.")
			--end
		end
		return false
	end

	north 				= buttons:getCircleButton("north")
	east 				= buttons:getCircleButton("east")
	south 				= buttons:getCircleButton("south")
	west 				= buttons:getCircleButton("west")

	buttons.north 		= north
	buttons.east 		= east
	buttons.south 		= south
	buttons.west 		= west

	buttons:setSize(startWidth, startHeight)

	return buttons

end

return CircleButton