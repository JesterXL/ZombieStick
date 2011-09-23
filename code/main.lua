require "players.PlayerJXL"
require "players.PlayerFreeman"
require("physics")
physics.setDrawMode( "normal" )
physics.start()
physics.setGravity(0, 9.8)

display.setStatusBar( display.HiddenStatusBar )

local stage = display.getCurrentStage()

local background = display.newRect(0, 0, stage.width, stage.height)
background:setFillColor(255, 255, 255)

local level = display.newGroup()

player = PlayerJXL:new()
player.x = 100
player.y = 300

freeman = PlayerFreeman:new()
freeman.x = 164
freeman.y = 300

local t = {}
function t:timer(event)
	freeman:shoot()
	--freeman:jump()
end
timer.performWithDelay(500, t, 999)

level:insert(player)
level:insert(freeman)

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
	assert(physics.addBody(floor, "static", 
		{friction=.3, bounce=0,
			filter = { categoryBits = 1, maskBits = 6 }}), 
			"Floor failed to add to physics.")
	floor.x = x
	floor.y = y
	level:insert(floor)
	return floor
end

local levelWidth = stage.width * 3

local function getCrate(x, y)
	local crate = display.newImage("crate.png")
	crate.name = "crate"
	crate.x = x
	crate.y = y
	level:insert(crate)
	physics.addBody(crate, { density=20, friction=0.3, 
		filter = { categoryBits = 2, maskBits = 7 }} )
	return crate
end

local crate1 = getCrate(stage.width - 20, 300)
local crate2 = getCrate(crate1.x + crate1.width, 300)


local bottomFloor = getFloor("floor", 0, stage.height - 50, levelWidth, 50)
local leftWall = getFloor("leftWall", -25, 0, 50, stage.height - 50)
local rightWall = getFloor("rightWall", levelWidth - 25, 0, 50, stage.height - 50)

local function scrollScreen()
	local centerX = stage.width / 2
	local centerY = level.y
	local playerX, playerY = player:localToContent(stage.x, stage.y)
	local currentOffsetX = playerX - level.x
	local currentOffsetY = playerY - level.y
	
	local deltaX = playerX - centerX
	local deltaY = playerY - centerY
	
	if true then
		if level.x + -deltaX < 0 then
			level.x = level.x + -deltaX
		end
		return
	end
	
end

Runtime:addEventListener("enterFrame", scrollScreen)
