MoveLeftButton = {}

function MoveLeftButton:new()
	
	local image = display.newImage("button-move-left.png")
	image:setReferencePoint(display.TopLeftReferencePoint)
	
	return image
	
end

return MoveLeftButton