require "com.jxl.zombiestick.gamegui.buttons.BaseSwipeButton"
SwipeDownButton = {}


function SwipeDownButton:new()

	if SwipeDownButton.sheet == nil then
		local sheet = sprite.newSpriteSheet("button-swipe-down-sheet.png", 115, 206)
		local set = sprite.newSpriteSet(sheet, 1, 10)
		sprite.add(set, "SwipeDownButton", 1, 10, 500, 0)
		SwipeDownButton.sheet = sheet
		SwipeDownButton.set = set
	end

	local button = BaseSwipeButton:new(60, 200)
	local sprite = sprite.newSprite(SwipeDownButton.set)
	sprite:setReferencePoint(display.TopLeftReferencePoint)
	sprite:prepare("SwipeDownButton")
	sprite:play()
	button:insert(sprite)
	sprite.x = 0
	sprite.y = 0

	function button:onSwipe(event)
		if event.angle == -90 then
			self:dispatchEvent({name="onSwipeDown", target=self})
		end
	end

	button:addEventListener("onSwipe", button)

	return button
end

return SwipeDownButton