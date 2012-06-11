require "com.jxl.zombiestick.gamegui.buttons.BaseSwipeButton"
SwipeUpButton = {}


function SwipeUpButton:new()

	if SwipeUpButton.sheet == nil then
		local sheet = sprite.newSpriteSheet("button-swipe-up-sheet.png", 115, 200)
		local set = sprite.newSpriteSet(sheet, 1, 10)
		sprite.add(set, "SwipeUpButton", 1, 10, 500, 0)
		SwipeUpButton.sheet = sheet
		SwipeUpButton.set = set
	end

	local button = BaseSwipeButton:new(60, 140)
	local sprite = sprite.newSprite(SwipeUpButton.set)
	sprite:setReferencePoint(display.TopLeftReferencePoint)
	sprite:prepare("SwipeUpButton")
	sprite:play()
	button:insert(sprite)
	sprite.x = 0
	sprite.y = 0

	function button:onSwipe(event)
		if event.angle == 90 then
			self:dispatchEvent({name="onSwipeUp", target=self})
		end
	end

	button:addEventListener("onSwipe", button)

	return button
end

return SwipeUpButton