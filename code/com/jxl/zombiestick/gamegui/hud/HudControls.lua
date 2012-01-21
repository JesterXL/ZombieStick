require "com.jxl.zombiestick.gamegui.hud.MoveLeftButton"
require "com.jxl.zombiestick.gamegui.hud.MoveRightButton"
require "com.jxl.zombiestick.gamegui.hud.JumpButton"
require "com.jxl.zombiestick.gamegui.hud.AttackButton"
require "com.jxl.zombiestick.gamegui.hud.JumpRightButton"
require "com.jxl.zombiestick.gamegui.hud.JumpLeftButton"

HudControls = {}

function HudControls:new(width, height)

	local controls = display.newGroup()
	
	local leftButton = MoveLeftButton:new()
	leftButton.name = "left"
	leftButton.x = 4
	leftButton.y = height - (leftButton.height + 4)
	controls:insert(leftButton)

	local rightButton = MoveRightButton:new()
	rightButton.name = "right"
	rightButton.x = leftButton.x + leftButton.width + 4
	rightButton.y = leftButton.y
	controls:insert(rightButton)

	local strikeButton = AttackButton:new()
	strikeButton.name = "strike"
	strikeButton.x = width - (strikeButton.width + 4)
	strikeButton.y = leftButton.y
	controls:insert(leftButton)

	local jumpRightButton = JumpRightButton:new()
	jumpRightButton.name = "jumpRight"
	jumpRightButton.x = strikeButton.x - (jumpRightButton.width + 4)
	jumpRightButton.y = leftButton.y
	controls:insert(jumpRightButton)

	local jumpButton = JumpButton:new()
	jumpButton.name = "jump"
	jumpButton.x = jumpRightButton.x - (jumpButton.width + 4)
	jumpButton.y = leftButton.y
	controls:insert(jumpButton)

	local jumpLeftButton = JumpLeftButton:new()
	jumpLeftButton.name = "jumpLeft"
	jumpLeftButton.x = jumpButton.x - (jumpLeftButton.width + 4)
	jumpLeftButton.y = leftButton.y
	controls:insert(jumpLeftButton)
	
	function controls:touch(event)
		local t = event.target
		if t == leftButton then
			self:dispatchEvent({name="onLeftButtonTouch", target=self, phase=event.phase, button=leftButton})
		elseif t == rightButton then
			self:dispatchEvent({name="onRightButtonTouch", target=self, phase=event.phase, button=rightButton})
		elseif t == strikeButton then
			self:dispatchEvent({name="onAttackButtonTouch", target=self, phase=event.phase, button=strikeButton})
		elseif t == jumpButton then
			self:dispatchEvent({name="onJumpButtonTouch", target=self, phase=event.phase, button=jumpButton})
		elseif t == jumpLeftButton then
			self:dispatchEvent({name="onJumpLeftButtonTouch", target=self, phase=event.phase, button=jumpLeftButton})
		elseif t == jumpRightButton then
			self:dispatchEvent({name="onJumpRightButtonTouch", target=self, phase=event.phase, button=jumpRightButton})
		end	
		return true
	end

	leftButton:addEventListener("touch", controls)
	rightButton:addEventListener("touch", controls)
	strikeButton:addEventListener("touch", controls)
	jumpButton:addEventListener("touch", controls)
	jumpLeftButton:addEventListener("touch", controls)
	jumpRightButton:addEventListener("touch", controls)
	
	return controls
	
end

return HudControls