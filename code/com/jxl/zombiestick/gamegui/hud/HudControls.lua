require "com.jxl.zombiestick.gamegui.hud.MoveLeftButton"
require "com.jxl.zombiestick.gamegui.hud.MoveRightButton"
require "com.jxl.zombiestick.gamegui.hud.JumpButton"
require "com.jxl.zombiestick.gamegui.hud.AttackButton"
require "com.jxl.zombiestick.gamegui.hud.JumpRightButton"
require "com.jxl.zombiestick.gamegui.hud.JumpLeftButton"
require "com.jxl.zombiestick.gamegui.hud.TargetButton"
require "com.jxl.zombiestick.gamegui.hud.GunButton"
require "com.jxl.zombiestick.gamegui.hud.GrapplingHookGunButton"
require "com.jxl.zombiestick.gamegui.hud.GunAmmoLine"
require "com.jxl.zombiestick.gamegui.hud.EnterButton"
require "com.jxl.zombiestick.gamegui.hud.HealButton"

require "com.jxl.zombiestick.states.hud.HudControlsJXLState"
require "com.jxl.zombiestick.states.hud.HudControlsFreemanState"

HudControls = {}

function HudControls:new(width, height)

	local controls = display.newGroup()
	controls.classType = "HudControls"
	
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
	
	local gunButton = GunButton:new()
	gunButton.name = "gunButton"
	gunButton.x = rightButton.x + (rightButton.width + 4)
	gunButton.y = leftButton.y
	controls:insert(gunButton)
	gunButton.isVisible = false
	gunButton.alpha = .5
	
	local gunAmmoLine = GunAmmoLine:new(10, 10)
	gunAmmoLine.name = "gunAmmoLine"
	gunAmmoLine.x = gunButton.x
	gunAmmoLine.y = gunButton.y - (gunAmmoLine.height + 2)
	controls:insert(gunAmmoLine)
	gunAmmoLine.isVisible = false
	
	local grappleButton = GrapplingHookGunButton:new()
	grappleButton.name = "grappleButton"
	grappleButton.x = gunButton.x + (gunButton.width + 4)
	grappleButton.y = leftButton.y
	controls:insert(grappleButton)
	grappleButton.isVisible = false
	grappleButton.alpha = .5
	
	local enterButton = EnterButton:new()
	enterButton.name = "enterButton"
	controls:insert(enterButton)
	enterButton.showing = false
	enterButton.alpha = 0
	enterButton.x = width - enterButton.width
	enterButton.y = (height / 2) - (enterButton.height / 2)
	enterButton.originalWidth = enterButton.width
	enterButton.originalHeight = enterButton.height

	local healButton = HealButton:new()
	healButton.name = "healButton"
	controls:insert(healButton)
	healButton.x = jumpLeftButton.x - healButton.width - 4
	healButton.y = jumpLeftButton.y

	function controls:tick(time)
		if self.fsm ~= nil then
			self.fsm:tick(time)
		end
	end
	
	function controls:showJXLAttackButton(show)
		--print("HudControls::showJXLAttackButtons, show: ", show)
		attackButton.isVisible = show
	end

	function controls:enableHealing(show)
		if show then
			healButton.alpha = 1
			healButton.enabled = true
		else
			healButton.alpha = 0.5
			healButton.enabled = false
		end
	end
	
	local function onTouch(event)
		--print("HudControls::onTouch")
		if event.phase == "began" then
			if gunButton.alpha == 1 then
				controls:dispatchEvent({name="onAttackButtonTouch", target=controls, 
								phase=event.phase, button=clickRect, x=event.x, y=event.y})
			end
		end
	end
	
	function controls:showFreemanAttackButton(show)
		--print("HudControls::showFreemanAttackButton, show: ", show)
		gunButton.isVisible = show
		gunAmmoLine.isVisible = show
		grappleButton.isVisible = show
		if show then
			Runtime:addEventListener("touch", onTouch)
		else
			Runtime:removeEventListener("touch", onTouch)
		end
	end
	
	function controls:setFreemanWeapon(weapon)
		--print("HudControls::setFreemanWeapon, weapon: ", weapon)
		if weapon == "gun" then
			gunButton.alpha = 1
			grappleButton.alpha = .5
		elseif weapon == "grapple" then
			gunButton.alpha = .5
			grappleButton.alpha = 1
		else
			assert("Unknown weapon.")
		end
	end
	
	function controls:showDoorButton(show, doorName, targetDoorName)
		if enterButton.showing ~= show then
			enterButton.doorName = doorName
			enterButton.targetDoorName = targetDoorName
			if enterButton.tween ~= nil then
				transition.cancel(enterButton.tween)
			end
			
			if show == true then
				enterButton.showing = show
				enterButton.tween = transition.to( enterButton, {time=500, alpha=1, width=enterButton.originalWidth, height=enterButton.originalHeight, transition=easing.outExpo})
			else
				enterButton.showing = show
				enterButton.tween = transition.to( enterButton, {time=500, alpha=0, width=(enterButton.originalWidth * .3), height=(enterButton.originalHeight * .3), stransition=easing.outExpo})
			end
		end		
	end
	
	function controls:touch(event)
		--print("HudControls::touch, target: ", event.target.name)
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
		elseif t == gunButton then
			Runtime:dispatchEvent({name="onGunButtonTouch", target=self, phase=event.phase, button=gunButton})
		elseif t == grappleButton then
			Runtime:dispatchEvent({name="onGrappleButtonTouch", target=self, phase=event.phase, button=grappleButton})
		elseif t == enterButton then
			self:dispatchEvent({name="onEnterButtonTouch", target=self, phase=event.phase, button=enterButton})
		elseif t == healButton and healButton.enabled then
			Runtime:dispatchEvent({name="onHealButtonTouch", target=self, phase=event.phase, button=healButton})
		end
		return true
	end

	function controls:destroy()
		leftButton:removeEventListener("touch", controls)
		rightButton:removeEventListener("touch", controls)
		attackButton:removeEventListener("touch", controls)
		jumpButton:removeEventListener("touch", controls)
		jumpLeftButton:removeEventListener("touch", controls)
		jumpRightButton:removeEventListener("touch", controls)
		gunButton:removeEventListener("touch", controls)
		grappleButton:removeEventListener("touch", controls)
		enterButton:removeEventListener("touch", controls)
		healButton:removeEventListener("touch", controls)

		if enterButton.tween ~= nil then
			transition.cancel(enterButton.tween)
		end

		Runtime:removeEventListener("touch", onTouch)
		
		controls.fsm = nil
	end
	


	leftButton:addEventListener("touch", controls)
	rightButton:addEventListener("touch", controls)
	attackButton:addEventListener("touch", controls)
	jumpButton:addEventListener("touch", controls)
	jumpLeftButton:addEventListener("touch", controls)
	jumpRightButton:addEventListener("touch", controls)
	gunButton:addEventListener("touch", controls)
	grappleButton:addEventListener("touch", controls)
	enterButton:addEventListener("touch", controls)
	healButton:addEventListener("touch", controls)
	
	controls.fsm = StateMachine:new(controls)
	controls.fsm:addState2(HudControlsJXLState:new())
	controls.fsm:addState2(HudControlsFreemanState:new())
	controls.fsm:setInitialState("HudControlsJXL")
	
	return controls
	
end

return HudControls