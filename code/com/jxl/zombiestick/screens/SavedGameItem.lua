SavedGameItem = {}

function SavedGameItem:new()

	local item = display.newGroup()

	function item:init(savedGameVO)
		self:destroy()
		
		local background = display.newRect(0, 0, 300, 60)
		background:setFillColor(255, 255, 255, 180)
		background:setStrokeColor(0, 255, 0, 180)
		background.strokeWidth = 2
		background:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(background)
		self.background = background

		--local image = display.newImage(savedGameVO.iconImage, system.DocumentsDirectory)
		local image = display.newImage(savedGameVO.iconImage)
		self.image = image
		image:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(image)
		image.x = 2
		image.y = 2
		image.width = 60
		image.height = 60

		local titleField = display.newText("", 0, 0, 200, 60, native.systemFont, 16)
		titleField:setReferencePoint(display.TopLeftReferencePoint)
		titleField:setTextColor(0, 0, 0, 180)
		titleField.text = savedGameVO.saveDate
		self.titleField = titleField
		self:insert(titleField)
		titleField.x = 66
		titleField.y = 2
	end

	function item:destroy()

	end

	return item
end

return SavedGameItem