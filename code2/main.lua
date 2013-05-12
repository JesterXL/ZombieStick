
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

	setupGlobals()
	setupPhysics()

	testLevel1()

end

local function onError(e)
	return true
end
Runtime:addEventListener("unhandledError", onError)
timer.performWithDelay(100, main)

