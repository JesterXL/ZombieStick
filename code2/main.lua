
display.setStatusBar( display.HiddenStatusBar )

local function main()
	local function setupGlobals()
		require "utils.GameLoop"
		_G.gameLoop = GameLoop:new()
		gameLoop:start()

		_G.mainGroup = display.newGroup()
		mainGroup.classType = "mainGroup"
		_G.stage = display.getCurrentStage()
		_G.constants = require "constants"
	end

	local function setupPhysics()
		require("physics")
		physics.setDrawMode("hybrid")
		--physics.setDrawMode("normal")
		physics.start()
		physics.setGravity(0, 9.8)
		physics.setPositionIterations( 10 )
	end

	function round(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end

	function showProps(o)
		print("-- showProps --")
		print("o: ", o)
		for key,value in pairs(o) do
			print("key: ", key, ", value: ", value);
		end
		print("-- end showProps --")
	end

	function setupPlayerDebug(player)
		local rect = display.newRect(0, 0, 120, 60)
		rect:setFillColor(0, 0, 0, 240)

		local field = display.newText("x: ---\ny: ---", 0, 0, 120, 120, native.systemFont, 21)
		field:setTextColor(255, 255, 255)
		field.player = player

		function field:enterFrame(e)
			if self.player then
				local str = "x: " .. round(self.player.x, 2)
				str = str .. "\ny: " .. round(self.player.y, 2)
				self.text = str
			else
				self.text = "---"
			end
		end
		Runtime:addEventListener("enterFrame", field)

		rect.x = stage.width - rect.width
		field.x = rect.x + 2
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
		jxl.x = 3598
		jxl.y = 420

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

		local scroller = {}
		function scroller:enterFrame(e)
			local w = stage.width
			local w2 = w / 2
			local player = jxl
			local lastX = mainGroup.x
			local finalScrollX = math.min(0, w2 - player.x)
			finalScrollX = math.max(finalScrollX, -(mainGroup.width - stage.width - 20))
			mainGroup.x = finalScrollX
		end
		Runtime:addEventListener("enterFrame", scroller)

		setupPlayerDebug(jxl)

		require "components.ButtonClimbUp"
		require "components.ButtonClimbDown"
		local buttonClimbUp = ButtonClimbUp:new()
		local buttonClimbDown = ButtonClimbDown:new()
		buttonClimbDown.y = buttonClimbUp.y + buttonClimbUp.height + 8
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

