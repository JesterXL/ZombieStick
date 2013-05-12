
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

	function showProps(o)
		print("-- showProps --")
		print("o: ", o)
		for key,value in pairs(o) do
			print("key: ", key, ", value: ", value);
		end
		print("-- end showProps --")
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
		require "components.ButtonJump"
		require "components.ButtonJumpLeft"
		require "components.ButtonJumpRight"
		local buttonLeft = ButtonLeft:new()
		local buttonRight = ButtonRight:new()
		local buttonJump = ButtonJump:new()
		local buttonJumpLeft = ButtonJumpLeft:new()
		local buttonJumpRight = ButtonJumpRight:new()
		buttonLeft.x = 0
		buttonLeft.y = stage.height - buttonLeft.height

		buttonJumpLeft.x = buttonLeft.x + buttonLeft.width + 8
		buttonJumpLeft.y = buttonLeft.y

		buttonJump.x = buttonJumpLeft.x + buttonJumpLeft.width + 8
		buttonJump.y = buttonJumpLeft.y

		buttonJumpRight.x = buttonJump.x + buttonJump.width + 8
		buttonJumpRight.y = buttonJump.y
		
		buttonRight.x = buttonJumpRight.x + buttonJumpRight.width + 8
		buttonRight.y = buttonJumpRight.y

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

