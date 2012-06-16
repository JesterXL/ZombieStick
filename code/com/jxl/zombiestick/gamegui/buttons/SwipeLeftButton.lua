require "com.jxl.zombiestick.gamegui.buttons.BaseSwipeButton"
SwipeLeftButton = {}


function SwipeLeftButton:new()

	if SwipeLeftButton.sheet == nil then
		local sheet = sprite.newSpriteSheet("button-swipe-left-sheet.png", 206, 109)
		local set = sprite.newSpriteSet(sheet, 1, 10)
		sprite.add(set, "SwipeLeftButton", 1, 10, 500, 0)
		SwipeLeftButton.sheet = sheet
		SwipeLeftButton.set = set
	end

	local button = BaseSwipeButton:new(140, 60)
	local sprite = sprite.newSprite(SwipeLeftButton.set)
	sprite:setReferencePoint(display.TopLeftReferencePoint)
	sprite:prepare("SwipeLeftButton")
	sprite:play()
	button:insert(sprite)
	sprite.x = 0
	sprite.y = 0

	function button:onSwipe(event)
		if event.angle == 0 then
			self:dispatchEvent({name="onSwipedCorrectly", target=self})
		end
	end

	button:addEventListener("onSwipe", button)

	return button
end

return SwipeLeftButton