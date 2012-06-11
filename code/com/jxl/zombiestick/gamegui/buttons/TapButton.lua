TapButton = {}

function TapButton:new()

	local button = display.newGroup()

	if TapButton.sheet == nil then
		local sheet = sprite.newSpriteSheet("player_jesterxl_sheet.png", 64, 64)
		local standSet = sprite.newSpriteSet(sheet, 1, 6)
		sprite.add(standSet, "PlayerJXLStand", 1, 6, 1000, 0)
		local moveSet = sprite.newSpriteSet(sheet, 9, 8)
		sprite.add(moveSet, "PlayerJXLMove", 1, 8, 500, 0)
		local jumpSet = sprite.newSpriteSet(sheet, 17, 6)
		sprite.add(jumpSet, "PlayerJXLJump", 1, 6, 600, 1)
		local attackSet = sprite.newSpriteSet(sheet, 25, 6)
		sprite.add(attackSet, "PlayerJXLAttack", 1, 6, 300, 1)
		local hangSet = sprite.newSpriteSet(sheet, 31, 1)
		-- sprite.add( spriteSet, sequenceName, startFrame, frameCount, time, [loopParam] )
		sprite.add(hangSet, "PlayerJXLHang", 1, 1, 1000)
	end
		

	return button

end

return TapButton