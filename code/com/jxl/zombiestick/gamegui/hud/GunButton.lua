GunButton = {}

function GunButton:new()
	local image = display.newImage("gun-button.png")
	image:setReferencePoint(display.TopLeftReferencePoint)
	return image
end

return GunButton