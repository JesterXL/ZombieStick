ButtonSeries = {}

function ButtonSeries:new(series)
	
	local button = display.newGroup()
	button.series = series
	button.currentButton = nil
	button.currentIndex = nil

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

		self.currentButton = current:new()
		self:insert(self.currentButton)
		self.currentButton:addEventListener("touch", self)		
	end

	function button:touch(event)
		if event.phase == "began" then
			self:next()
			return true
		end
	end

	function button:endButtons()
		self:dispatchEvent({name="onButtonSeriesComplete", target=self})
	end

	return button
	
end

return ButtonSeries