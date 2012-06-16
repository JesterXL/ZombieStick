ButtonSeries = {}

function ButtonSeries:new(series)
	
	local button = display.newGroup()
	button.series = series
	button.currentButton = nil
	button.currentIndex = nil
	button.textPool = {}

	function button:start()
		self.currentIndex = 0
		self:next()
	end

	function button:next()
		local series = self.series
		if series == nil then error("series is nil") end
		if #series < 1 then error("no buttons") end

		if self.currentButton then
			self.currentButton:removeEventListener("touch", self)
			self.currentButton:removeSelf()
		end

		if self.currentIndex + 1 < #series then
			self.currentIndex = self.currentIndex + 1
		else
			self:endButtons()
			return true
		end

		local current = series[self.currentIndex]
		if current == nil then error("current is nil") end

		local currentButton = current:new()
		self:insert(currentButton)
		currentButton:addEventListener("onSwipedCorrectly", self)
		self.currentButton = currentButton
		currentButton.alpha = 0
		if currentButton.tween then
			transition.cancel(currentButton)
		end
		currentButton.tween = transition.to(currentButton, {alpha=1, time=300})
	end
	
	function button:onSwipedCorrectly(event)
		self:showSuccessFailure(60, 0)
		self:next()
		return true
	end

	function button:endButtons()
		self:dispatchEvent({name="onButtonSeriesComplete", target=self})
	end

	function button:showSuccessFailure(targetX, targetY)
		local field
		if self.textPool and table.maxn(self.textPool) > 0 then
			field = self.textPool[1]
			assert(field ~= nil, "Failed to get item from pool")
			table.remove(self.textPool, table.indexOf(self.textPool, field))
			assert(field ~= nil, "After cleanup, field got nil.")
		else
			field = display.newText("", 0, 0, 80, 60, native.systemFont, 16)
			function field:onComplete(obj)
				if self.tween then
					transition.cancel(field.tween)
					field.tween = nil
				end
				if self.alphaTween then
					transition.cancel(field.alphaTween)
					field.alphaTween = nil
				end
				table.insert(button.textPool, field)
			end
		end
		assert(field ~= nil, "After if statement, field is nil.")
		field:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(field)
		field.x = targetX
		field.y = targetY
		field.alpha = 1
		field:setTextColor(0, 255, 0)
		field.text = "Correct!"
		local newTargetY = targetY - 40
		field.tween = transition.to(field, {y=newTargetY, time=500, transition=easing.outExpo})
		field.alphaTween = transition.to(field, {alpha=0, time=200, delay=300, onComplete=field})
	end

	return button
	
end

return ButtonSeries