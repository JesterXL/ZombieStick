TapButton = {}

function TapButton:new()

	

	if TapButton.sheet == nil then
		local sheet = sprite.newSpriteSheet("button-tap-sheet.png", 60, 65)
		local standSet = sprite.newSpriteSet(sheet, 1, 4)
		sprite.add(standSet, "ButtonTap", 1, 4, 1000, 0)
		TapButton.sheet = sheet
		TapButton.standSet = standSet
	end

	local button = sprite.newSprite(TapButton.standSet)
	button:setReferencePoint(display.TopLeftReferencePoint)
	button:prepare("ButtonTap")
	button:play()

	function button:tap(event)
		local taps = event.numTaps
		if taps == 1 then
			self.timeScale = 1
		elseif taps == 2 then
			self.timeScale = 2
		elseif taps == 3 then
			self.timeScale = 3
		elseif taps > 3 then
			self.timeScale = 4
		end
	end
		
	button:addEventListener("tap", button)

	return button

end

return TapButton