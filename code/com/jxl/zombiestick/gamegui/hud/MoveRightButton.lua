MoveRightButton = {}

function MoveRightButton:new()
	
	local image = display.newImage("button-move-right.png")
	image:setReferencePoint(display.TopLeftReferencePoint)
	
	
	return image
	
end

return MoveRightButton