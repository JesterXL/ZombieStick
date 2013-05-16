
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
		require "components.FloatingText"
		_G.floatingText = FloatingText:new()
	end

	local function setupPhysics()
		require("physics")
		-- physics.setDrawMode("hybrid")
		physics.setDrawMode("normal")
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
		local rect = display.newRect(0, 0, 140, 120)
		rect:setReferencePoint(display.TopLeftReferencePoint)
		rect:setFillColor(0, 0, 0, 240)

		local field = display.newText("x: ---\ny: ---\nledge: ---", 0, 0, 160, 160, native.systemFont, 21)
		field:setReferencePoint(display.TopLeftReferencePoint)
		field:setTextColor(255, 255, 255)
		field.player = player

		function field:enterFrame(e)
			if self.player then
				local str = "x: " .. round(self.player.x, 2)
				str = str .. "\ny: " .. round(self.player.y, 2)
				if self.player.lastLedge then
					str = str .. "\nledge: " .. self.player.lastLedge.name
				else
					str = str .. "\nledge: nil"
				end
				self.text = str
			else
				self.text = "---"
			end
		end
		Runtime:addEventListener("enterFrame", field)

		rect.x = stage.width - rect.width
		field.x = rect.x
	end


	local function testLevel1()
		require "levels.level1._Level1"
		local level1 = _Level1:new()
		level1:build()
		

		mainGroup.x = -2900
	end

	local function testLevel1AndPlayer()
		local bg = display.newRect(0, 0, stage.width, stage.height)
		bg:setFillColor(255, 255, 255)
		bg:toBack()

		require "levels.level1._Level1"
		local level1 = _Level1:new()
		level1:build()

		mainGroup.x = 0
		mainGroup.y = -300

		require "players.PlayerJXL"
		local jxl = PlayerJXL:new()
		jxl.x = 1893
		jxl.y = 527

		require "vo.LacerationVO"
		jxl:addInjury(LacerationVO:new())

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

	local function testFloatingText()
		require "components.FloatingText"
		local float = FloatingText:new()
		float:showFloatingText({x=100, y=100, amount=55, textTarget=stage, textType=constants.TEXT_TYPE_HEALTH})
	end

	local function testInjuryView()
		-- require "views.InjuryItemRenderer"
		-- local item = InjuryItemRenderer:new(200, 70)
		-- item.x = 30
		-- item.y = 30

		require "views.InjuryView"
		require "vo.BiteVO"
		require "vo.LacerationVO"

		local view = InjuryView:new(30, 30, 300, 300)

		local injuries = {}
		table.insert(injuries, BiteVO:new())
		table.insert(injuries, LacerationVO:new())
		table.insert(injuries, BiteVO:new())
		table.insert(injuries, LacerationVO:new())
		table.insert(injuries, BiteVO:new())
		table.insert(injuries, LacerationVO:new())

		view:setInjuries(injuries)
	end

	local function testFirstAidViews()
		-- require "views.injuryviews.FirstAidItemRenderer"
		-- local item = FirstAidItemRenderer:new(300, 70)
		-- item.x = 30
		-- item.y = 30

		require "vo.FirstAidVO"
		-- local vo = FirstAidVO:new("Bandage", "Protects a cut, slows bleeding, and helps prevent infection while protecting the cut.")
		-- item:setFirstAid(vo)

		-- require "views.injuryviews.FirstAidList"
		-- local list = FirstAidList:new(300, 300)
		-- list.x = 30
		-- list.y = 30

		-- local i
		-- local firstAids = {}
		-- for i=1,10 do
		-- 	local vo = FirstAidVO:new("Bandage", "Protects a cut, slows bleeding, and helps prevent infection while protecting the cut.")
		-- 	table.insert(firstAids, vo)
		-- end
		-- list:setFirstAids(firstAids)
		
		require "MainContext"
		local context = MainContext:new()
		
		require "views.injuryviews.InjuryTreatmentView"
		local view = InjuryTreatmentView:new(400, 400)
		



	end


	setupGlobals()
	setupPhysics()

	-- testLevel1()
	-- testLevel1AndPlayer()
	--testFloatingText()
	-- testInjuryView()
	testFirstAidViews()

end

local function onError(e)
	return true
end
Runtime:addEventListener("unhandledError", onError)
timer.performWithDelay(100, main)

