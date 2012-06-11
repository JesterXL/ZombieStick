require "com.jxl.zombiestick.gamegui.buttons.CircleButton"
CounterclockwiseSwipeButton = {}

function CounterclockwiseSwipeButton:new()

	if CounterclockwiseSwipeButton.sheet == nil then
		local sheet = sprite.newSpriteSheet("button-counterclockwise-swipe-sheet.png", 198, 184)
		local set = sprite.newSpriteSet(sheet, 1, 15)
		sprite.add(set, "CounterclockwiseSwipeButton", 1, 15, 500, 0)
		CounterclockwiseSwipeButton.sheet = sheet
		CounterclockwiseSwipeButton.set = set
	end

	local button = display.newGroup()


	local sprite = sprite.newSprite(CounterclockwiseSwipeButton.set)
	sprite:setReferencePoint(display.TopLeftReferencePoint)
	sprite:prepare("CounterclockwiseSwipeButton")
	sprite:play()
	button:insert(sprite)
	sprite.x = 0
	sprite.y = 0
	
	local circleButton = CircleButton:new(120, 120)
	button:insert(circleButton)

	function button:onCircleSwipe(event)
		print("onCircleSwipe")
		if event.direction == CircleButton.COUNTER then
			self:dispatchEvent({name="onCounterclockwiseSwipe", target=self})
		end
	end

	circleButton:addEventListener("onCircleSwipe", button)

	return button
end

return CounterclockwiseSwipeButton