require "com.jxl.zombiestick.constants"

Table = {}

function Table:new(params)
	local table = display.newImage("table.png")
	--table:setReferencePoint(display.TopLeftReferencePoint)
	table.classType = "Table"
	table.name = "Table"
	table.x = params.x
	table.y = params.y
	table.rotation = params.rotation
	physics.addBody(table, { density=params.density, friction=params.friction, bounce=params.bounce, 
			filter = { categoryBits = constants.COLLISION_FILTER_TERRAIN_CATEGORY, 
						maskBits = constants.COLLISION_FILTER_TERRAIN_MASK }} )				
	return table
end

return Table