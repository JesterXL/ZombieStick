CharacterSelectView = {}

-- [jwarden 10.30.2011] TODO: players needs to eventually dispatch a change event so I can redraw
function CharacterSelectView:new(x, y)
	local group = display.newGroup()
	
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
		while players[i] do
			local player = players[i]
			local image
			if player.classType == "PlayerJXL" then
				image = display.newImage("gamegui_dialogueview_jesterxl_normal.jpg")
			elseif player.classType == "PlayerFreeman" then
				image = display.newImage("gamegui_dialogueview_freeman_normal.png")
			end
			image:setReferencePoint(display.TopLeftReferencePoint)
			image.name = player.classType
			self:insert(image)
			image.x = startX
			image:addEventListener("touch", self)
			startX = startX + image.width + 8
			i = i + 1
		end
	end
	
	function group:touch(event)
		print("event.target.name: ", event.target.name)
		self:dispatchEvent({name="onSelect", target=self, classType=event.target.name})
	end
	
	return group
end

return CharacterSelectView