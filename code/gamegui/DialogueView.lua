require "constants"

DialogueView = {}

function DialogueView:new(right)

	local group = display.newGroup()
	group.classType = "DialogueView"
	group:setReferencePoint(display.TopLeftReferencePoint)

	local img
	if right == nil or right == false then
		group.right = false
		img = display.newImage("gamegui_dialogue.png")
	else
		group.right = true
		img = display.newImage("gamegui_dialogue2.png")
	end
	img:setReferencePoint(display.TopLeftReferencePoint)
	group:insert(img)

	local platform = system.getInfo("platformName")
	local text
	if platform == "Android" or platform == "iPhone OS" then
		text = native.newTextBox( 0, 0, 278, 68 )
		text.hasBackground = false
		text.isEditable = false
		text.align = "left"
	else
		text = display.newText("", 0, 0, native.systemFont, 16)
	end
	text:setReferencePoint(display.TopLeftReferencePoint)
	text:setTextColor(255, 255, 255)
	text.size = 16
	text.font = native.newFont( native.systemFont, 16 )
	group:insert(text)
	
	
	function group:setText(value)
		-- TODO: wipe this in (animate mask or whatever)
		text.text = value
		
		local platform = system.getInfo("platformName")
		if platform == "Android" or platform == "iPhone OS" then
			text.x = 100
			text.y = 16
		else
			if group.right == false then
				text.x = 100 + (text.width / 2)
			else
				text.x = 16 + (text.width / 2)
			end
			text.y = 16 + (text.height / 2)
		end
	end

	function group:setCharacter(character, emotion)
		self.character = character
		if self.characterImage ~= nil then
			self:remove(self.characterImage)
			self.characterImage = nil
		end

		local img
		if character == constants.CHARACTER_JESTERXL then
			-- TODO: support emotion
			img = display.newImage(constants.CHARACTER_JESTERXL_DIALOGUEVIEW_IMAGE)
			
		elseif character == constants.CHARACTER_FREEMAN then
			img = display.newImage(constants.CHARACTER_FREEMAN_DIALOGUEVIEW_IMAGE)
		end

		if img ~= nil then
			img:setReferencePoint(display.TopLeftReferencePoint)
			self:insert(img)
			if group.right == false then
				img.x = 16
			else
				img.x = 298
			end
			img.y = 16
		end
		self.characterImage = img
	end

	function group:destroy()
		img:removeSelf()
		text.text = ""
		text:removeSelf()

		if self.characterImage ~= nil then
			self.characterImage:removeSelf()
			self.characterImage = nil
		end

		self:removeSelf()
	end

	
	return group

end

return DialogueView