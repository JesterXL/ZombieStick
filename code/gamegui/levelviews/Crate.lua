
Crate = {}

function Crate:new(params)
	local crate = display.newImage("crate.png")
	crate.classType = "Crate"
	crate.name = "crate"
	crate.x = params.x
	crate.y = params.y
	crate.rotation = params.rotation
	physics.addBody(crate, { density=params.density, friction=params.friction, bounce=params.bounce, 
		filter = { categoryBits = 2, maskBits = 7 }} )
	return crate
end

return Crate