require "com.jxl.zombiestick.gamegui.hud.MoveLeftButton"
require "com.jxl.zombiestick.gamegui.hud.MoveRightButton"
require "com.jxl.zombiestick.gamegui.hud.JumpButton"
require "com.jxl.zombiestick.gamegui.hud.AttackButton"
require "com.jxl.zombiestick.gamegui.hud.JumpRightButton"
require "com.jxl.zombiestick.gamegui.hud.JumpLeftButton"

require "com.jxl.zombiestick.states.hud.HudControlsJXLState"
require "com.jxl.zombiestick.states.hud.HudControlsFreemanState"

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
	
	local attackButton = AttackButton:new()
	attackButton.name = "attack"
	attackButton.x = width - (attackButton.width + 4)
	attackButton.y = leftButton.y
	controls:insert(leftButton)
	
	local jumpRightButton = JumpRightButton:new()
	jumpRightButton.name = "jumpRight"
	jumpRightButton.x = attackButton.x - (jumpRightButton.width + 4)
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
	
	function controls:showJXLAttackButton(show)
		attackButton.isVisible = show
	end
	
	function controls:showFreemanAttackButton(show)
		if show then
			if self.targetButton == null then
				local targetButton = TargetButton:new()
				targetButton.name = "attack"
				controls:insert(targetButton)
			end
			targetButton:show()
		else
			targetButton.isVisible = false
			targetButton:hide()
		end
	end
	
	function controls:touch(event)
		local t = event.target
		if t == leftButton then
			self:dispatchEvent({name="onLeftButtonTouch", target=self, phase=event.phase, button=leftButton})
		elseif t == rightButton then
			self:dispatchEvent({name="onRightButtonTouch", target=self, phase=event.phase, button=rightButton})
		elseif t == attackButton then
			self:dispatchEvent({name="onAttackButtonTouch", target=self, phase=event.phase, button=attackButton})
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
	attackButton:addEventListener("touch", controls)
	jumpButton:addEventListener("touch", controls)
	jumpLeftButton:addEventListener("touch", controls)
	jumpRightButton:addEventListener("touch", controls)
	
	controls.fsm = StateMachine:new(controls)
	controls.fsm:addState2(HudControlsJXLState:new())
	controls.fsm:addState2(HudControlsFreemanState:new())
	controls.fsm:setInitialState("HudControlsJXL")
	
	return controls
	
end

return HudControls