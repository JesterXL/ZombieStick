GenericButton = {}

function GenericButton:new(label)
	local button = display.newGroup()
	local image = display.newImage("button-generic.png")
	image:setReferencePoint(display.TopLeftReferencePoint)
	button:insert(image)
	local field = display.newText(label, 0, 0, 60, 60)
	field:setTextColor(0, 0, 0)
	--field:setReferencePoint(display.TopLeftReferencePoint)
	button:insert(field)
	field.y = 45
	field.x = 36
	return button

end

return GenericButton