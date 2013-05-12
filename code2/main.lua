
display.setStatusBar( display.HiddenStatusBar )

local function main()
	local function setupGlobals()
		require "utils.GameLoop"
		_G.gameLoop = GameLoop:new()
		gameLoop:start()

		_G.mainGroup = display.newGroup()
		mainGroup.classType = "mainGroup"
		_G.stage = display.getCurrentStage()
	end

	local function setupPhysics()
		require("physics")
		physics.setDrawMode("hybrid")
		--physics.setDrawMode("normal")
		physics.start()
		physics.setGravity(0, 9.8)
		physics.setPositionIterations( 10 )

	end

	local function testLevel1()
		require "levels.level1._Level1"
		local level1 = _Level1:new()
		level1:build()
		

		mainGroup.x = -2900
	end

	local function testLevel1AndPlayer()
		local bg = display.newRect(0, 0, stage.width, stage.height)
		bg:setFillColor(255, 0, 0)
		bg:toBack()

		require "levels.level1._Level1"
		local level1 = _Level1:new()
		level1:build()

		mainGroup.x = 0
		mainGroup.y = -300

		require "players.PlayerJXL"
		local jxl = PlayerJXL:new()
		jxl.x = 200
		jxl.y = 650

		require "components.ButtonLeft"
		require "components.ButtonRight"
		local buttonLeft = ButtonLeft:new()
		local buttonRight = ButtonRight:new()
		buttonLeft.x = 0
		buttonLeft.y = stage.height - buttonLeft.height
		buttonRight.x = buttonLeft.x + buttonLeft.width + 8
		buttonRight.y = buttonLeft.y

	end

	setupGlobals()
	setupPhysics()

	testLevel1()
	testLevel1AndPlayer()

end

local function onError(e)
	return true
end
Runtime:addEventListener("unhandledError", onError)
timer.performWithDelay(100, main)

