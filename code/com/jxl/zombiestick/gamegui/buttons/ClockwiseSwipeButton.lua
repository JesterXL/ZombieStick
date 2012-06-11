require "com.jxl.zombiestick.gamegui.buttons.CircleButton"
ClockwiseSwipeButton = {}

function ClockwiseSwipeButton:new()

	if ClockwiseSwipeButton.sheet == nil then
		local sheet = sprite.newSpriteSheet("button-clockwise-swipe-sheet.png", 198, 184)
		local set = sprite.newSpriteSet(sheet, 1, 15)
		sprite.add(set, "ClockwiseSwipeButton", 1, 15, 500, 0)
		ClockwiseSwipeButton.sheet = sheet
		ClockwiseSwipeButton.set = set
	end

	local button = display.newGroup()


	local sprite = sprite.newSprite(ClockwiseSwipeButton.set)
	sprite:setReferencePoint(display.TopLeftReferencePoint)
	sprite:prepare("ClockwiseSwipeButton")
	sprite:play()
	button:insert(sprite)
	sprite.x = 0
	sprite.y = 0
	
	local circleButton = CircleButton:new(120, 120)
	button:insert(circleButton)

	function button:onCircleSwipe(event)
		print("onCircleSwipe")
		if event.direction == CircleButton.CLOCKWISE then
			self:dispatchEvent({name="onClockwiseSwipe", target=self})
		end
	end

	circleButton:addEventListener("onCircleSwipe", button)

	return button
end

return ClockwiseSwipeButton