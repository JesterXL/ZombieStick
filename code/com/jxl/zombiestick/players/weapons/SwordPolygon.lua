SwordPolygon = {}

function SwordPolygon:new(x, y, width, height)
	local sword = display.newRect(0, 0, width, height)
	sword.classType = "SwordPolygon"
	sword:setReferencePoint(display.TopLeftReferencePoint)
	sword.x = x
	sword.y = y
	physics.addBody(sword, "kinematic", {density=1.1, friction=.3, bounce=0.3, isBullet=true, isFixedRotation=true})
	
	return sword
end

return SwordPolygon