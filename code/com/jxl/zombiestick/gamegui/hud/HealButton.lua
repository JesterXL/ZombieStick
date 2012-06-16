HealButton = {}

function HealButton:new()
	
	local image = display.newImage("button-heal.png")
	image:setReferencePoint(display.TopLeftReferencePoint)
	
	
	return image
	
end

return HealButton