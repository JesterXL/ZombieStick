require "players.PlayerJXL"
require("physics")
physics.setDrawMode( "hybrid" )
physics.start()
physics.setGravity(0, 9.8)

display.setStatusBar( display.HiddenStatusBar )

local stage = display.getCurrentStage()

player = PlayerJXL:new()
player.x = 100
player.y = 100

local function onTouch(event)
	local target = event.target
	if event.phase == "began" then
		if target.name == "jump" then
			player:jump()
			return true
		elseif target.name == "jumpForward" then
			player:jumpForward()
			return true
		elseif target.name == "right" then
			player:moveRight()
			return true
		elseif target.name == "left" then
			player:moveLeft()
			return true
		end
	elseif event.phase == "ended" then
		if target.name == "strike" then
			player:strike()
			return true
		elseif target.name == "right" then
			player:stand()
			return true
		elseif target.name == "left" then
			player:stand()
			return true
		end
	end
end

function getButton(name, x, y)
	local button = display.newRect(0, 0, 32, 32)
	button.name = name
	button.strokeWidth = 1
	button:setFillColor(255, 0, 0, 100)
	button:setStrokeColor(255, 0, 0)
	button.x = x
	button.y = y
	button:addEventListener("touch", onTouch)
	return button
end

local strikeButton = getButton("strike", 200, 100)
local rightButton = getButton("right", 240, 100)
local leftButton = getButton("left", 160, 100)
local jumpButton = getButton("jump", 200, 140)
local jumpForward = getButton("jumpForward", 240, 140)

function getFloor(name, x, y, width, height)
	local floor = display.newRect(0, 0, width, height)
	floor.name = name
	floor:setReferencePoint(display.TopLeftReferencePoint)
	floor:setFillColor(0, 255, 0, 100)
	assert(physics.addBody(floor, "static", {friction=1}), "Floor failed to add to physics.")
	floor.x = x
	floor.y = y
	return floor
end

local bottomFloor = getFloor("floor", 0, stage.height - 50, stage.width, 50)
local leftWall = getFloor("leftWall", -25, 0, 50, stage.height - 50)
local rightWall = getFloor("rightWall", stage.width - 25, 0, 50, stage.height - 50)