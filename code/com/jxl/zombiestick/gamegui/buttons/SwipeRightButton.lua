require "com.jxl.zombiestick.gamegui.buttons.BaseSwipeButton"
SwipeRightButton = {}


function SwipeRightButton:new()

	if SwipeRightButton.sheet == nil then
		local sheet = sprite.newSpriteSheet("button-swipe-right-sheet.png", 216, 109)
		local set = sprite.newSpriteSet(sheet, 1, 10)
		sprite.add(set, "SwipeRightButton", 1, 10, 500, 0)
		SwipeRightButton.sheet = sheet
		SwipeRightButton.set = set
	end

	local button = BaseSwipeButton:new(140, 60)
	local sprite = sprite.newSprite(SwipeRightButton.set)
	sprite:setReferencePoint(display.TopLeftReferencePoint)
	sprite:prepare("SwipeRightButton")
	sprite:play()
	button:insert(sprite)
	sprite.x = 0
	sprite.y = 0

	function button:onSwipe(event)
		if event.angle == 180 then
			self:dispatchEvent({name="onSwipeRight", target=self})
		end
	end

	button:addEventListener("onSwipe", button)

	return button
end

return SwipeRightButton