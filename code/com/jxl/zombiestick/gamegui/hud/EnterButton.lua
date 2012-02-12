EnterButton = {}

function EnterButton:new()
	
	local image = display.newImage("button-enter.png")
	image:setReferencePoint(display.TopLeftReferencePoint)
	return image
	
end

return EnterButton