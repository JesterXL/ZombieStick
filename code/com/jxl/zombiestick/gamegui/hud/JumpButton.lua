JumpButton = {}

function JumpButton:new()
	
	local image = display.newImage("button-jump.png")
	image:setReferencePoint(display.TopLeftReferencePoint)
	
	
	return image
	
end

return JumpButton