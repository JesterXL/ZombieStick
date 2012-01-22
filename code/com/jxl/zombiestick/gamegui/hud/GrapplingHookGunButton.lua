GrapplingHookGunButton = {}

function GrapplingHookGunButton:new()
	local image = display.newImage("grappling-hook-gun-button.png")
	image:setReferencePoint(display.TopLeftReferencePoint)
	return image
end

return GrapplingHookGunButton