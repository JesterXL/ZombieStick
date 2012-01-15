JumpLeftButton = {}

function JumpLeftButton:new()

	local image = display.newImage("button-jump-left.png")
	image:setReferencePoint(display.TopLeftReferencePoint)


	return image

end

return JumpLeftButton