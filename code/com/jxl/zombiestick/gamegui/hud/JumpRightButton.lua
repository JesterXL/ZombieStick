JumpRightButton = {}

function JumpRightButton:new()
	
	local image = display.newImage("button-jump-right.png")
	image:setReferencePoint(display.TopLeftReferencePoint)
	
	
	return image
	
end

return JumpRightButton