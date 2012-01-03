AttackButton = {}

function AttackButton:new()
	
	local image = display.newImage("button-attack.png")
	image:setReferencePoint(display.TopLeftReferencePoint)
	
	
	return image
	
end

return AttackButton