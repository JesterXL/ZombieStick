require "com.jxl.zombiestick.constants"

WindowPiece = {}

function WindowPiece:new(params)
	local window = display.newImage("window-piece.png")
	--window:setReferencePoint(display.TopLeftReferencePoint)
	window.classType = "WindowPiece"
	window.name = "WindowPiece"
	window.x = params.x
	window.y = params.y
	window.rotation = params.rotation
	physics.addBody(window, { density=params.density, friction=params.friction, bounce=params.bounce, 
			filter = { categoryBits = constants.COLLISION_FILTER_TERRAIN_CATEGORY, 
						maskBits = constants.COLLISION_FILTER_TERRAIN_MASK }} )				
	return window
end

return WindowPiece