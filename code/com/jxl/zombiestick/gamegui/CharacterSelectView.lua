require "com.jxl.zombiestick.gamegui.HealthBar"
require "com.jxl.zombiestick.gamegui.StaminaBar"
CharacterSelectView = {}

-- [jwarden 10.30.2011] TODO: players needs to eventually dispatch a change event so I can redraw
function CharacterSelectView:new(x, y)
	local group = display.newGroup()
	group.labels = nil
	
	function group:redraw(players)
		local i = self.numChildren
		local hasChildren = true
		while hasChildren do
			self:remove(i)
			i = i - 1
			if i <= 0 then
				hasChildren = false
			end
		end
		
		if players == nil then return true end
		
		i = 1
		local startX = 0
		self.labels = {}
		while players[i] do
			local player = players[i]
			local image
			local frame = display.newImage("character-frame.png")
			local frameMask = graphics.newMask("frame-mask.png")
			frame:setReferencePoint(display.TopLeftReferencePoint)
			
			local stateLabel = display.newText("", 0, 0, native.systemFont, 12)
			stateLabel:setReferencePoint(display.TopLeftReferencePoint)
			stateLabel:setTextColor(255, 255, 255)
			stateLabel.text = "--"
			stateLabel.size = 11

			local healthBar = HealthBar:new()
			local staminaBar = StaminaBar:new()
			
			if player.classType == "PlayerJXL" then
				image = display.newImage("gamegui_dialogueview_jesterxl_normal.jpg")
				healthBar.targetClassType = "PlayerJXL"
				staminaBar.targetClassType = "PlayerJXL"
			elseif player.classType == "PlayerFreeman" then
				image = display.newImage("gamegui_dialogueview_freeman_normal.png")
				healthBar.targetClassType = "PlayerFreeman"
				staminaBar.targetClassType = "PlayerFreeman"
			end
			image:setReferencePoint(display.TopLeftReferencePoint)
			--image:setMask(frameMask)
			image.maskX = 2
			image.maskY = 5
			image.name = player.classType
			frame.name = "frame_" .. player.classType

			self:insert(healthBar)
			self:insert(staminaBar)
			self:insert(image)
			self:insert(frame)
			self:insert(stateLabel)

			frame.x = startX
			image.x = startX

			stateLabel.x = startX - (stateLabel.width / 2)
			stateLabel.y = image.y + image.height

			healthBar.x = image.x
			healthBar.y = image.y + image.height + 2

			staminaBar.x = healthBar.x
			staminaBar.y = healthBar.y + healthBar.height + 2
			
			local labelName = "label_" .. player.classType
			stateLabel.name = labelName
			stateLabel.originalX = startX
			stateLabel.x = startX + (stateLabel.width / 2)
			self.labels[labelName] = stateLabel
			image:addEventListener("touch", self)
			startX = startX + 64 + 8
			i = i + 1
		end
	end
	
	function group:touch(event)
		self:dispatchEvent({name="onSelectActivePlayer", target=self, classType=event.target.name})
	end
	
	function group:onStateMachineStateChanged(event)
		local stateMachine = event.target
		local entity = stateMachine.entity
		local classType = stateMachine.entity.classType
		if classType and (classType == "PlayerJXL" or classType == "PlayerFreeman") then
			local state = stateMachine.state
			local textField = self.labels["label_" .. classType]
			textField.text = state
			textField.x = textField.originalX + (textField.width / 2)
		end
	end
	
	Runtime:addEventListener("onStateMachineStateChanged", group)
	
	return group
end

return CharacterSelectView