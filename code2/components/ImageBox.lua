ImageBox = {}

function ImageBox:new(parentGroup, layoutWidth, layoutHeight, imageURL)

	local box = display.newGroup()

	function box:init()
		parentGroup:insert(self)
		
		local background = display.newRect(0, 0, layoutWidth, layoutHeight)
		background:setReferencePoint(display.TopLeftReferencePoint)
		background:setFillColor(255, 255, 255)
		background:setStrokeColor(0, 0, 0)
		background.strokeWidth = 1
		self:insert(background)
		self.background = background

		if imageURL ~= nil then
			self:loadImage(imageURL)
		end
	end

	function box:loadImage(url)
		if self.image then
			self.image:removeSelf()
			self.image = nil
		end

		if url == nil then return false end
		
		local image = display.newImage(self, url, 0, 0)
		self.image = image
		image:setReferencePoint(display.TopLeftReferencePoint)
		-- image.width = layoutWidth - 4
		-- image.height = layoutHeight - 4
		self:insert(image)
	end

	box:init()

	return box

end

return ImageBox