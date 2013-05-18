
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

		require "MainContext"
		local context = MainContext:new()

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
		require "vo.BiteVO"
		-- jxl:addInjury(LacerationVO:new())
		gInjuryModel:addInjury(LacerationVO:new())
		gInjuryModel:addInjury(LacerationVO:new())
		gInjuryModel:addInjury(BiteVO:new())


		require "components.ButtonLeft"
		require "components.ButtonRight"
		require "components.ButtonJump"
		require "components.ButtonJumpLeft"
		require "components.ButtonJumpRight"
		require "components.ButtonHeal"

		local buttonLeft = ButtonLeft:new()
		local buttonRight = ButtonRight:new()
		local buttonJump = ButtonJump:new()
		local buttonJumpLeft = ButtonJumpLeft:new()
		local buttonJumpRight = ButtonJumpRight:new()
		local buttonHeal = ButtonHeal:new()

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

		buttonHeal.x = buttonRight.x + buttonHeal.width * 2
		buttonHeal.y = buttonRight.y

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

		require "views.InjuryView"
		local healListener = function()
			if gTreatInjuryView then
				gTreatInjuryView:destroy()
				gTreatInjuryView = nil
			end

			if gInjuryView == nil then
				gInjuryView = InjuryView:new(30, 30, 300, 300)
			else
				gInjuryView:destroy()
				gInjuryView = nil
			end
		end
		Runtime:addEventListener("onHeal", healListener)

		require "views.injuryviews.InjuryTreatmentView"
		local treatListener = function(e)
			if gInjuryView then
				gInjuryView:destroy()
				gInjuryView = nil
			end

			if gTreatInjuryView == nil then
				gTreatInjuryView = InjuryTreatmentView:new(400, 400)
				gTreatInjuryView.x = 30
				gTreatInjuryView.y = 30
				gTreatInjuryView:setInjury(e.injuryVO)
			end

		end
		Runtime:addEventListener("onTreatInjury", treatListener)

		local useFirstAidListener = function(e)
			local injury = gTreatInjuryView.injuryVO
			local firstAid = e.firstAidVO
			print("attempting to heal " .. injury.name .. " with " .. firstAid.name .. ", amount:" .. firstAid.amount)
			if firstAid.amount >= 1 then
				print("injury.injuryType:", injury.injuryType, ", firstAid.firstAidType: ", firstAid.firstAidType)
				print("constants.INJURY_LACERATION:", constants.INJURY_LACERATION, ", constants.FIRST_AID_BANDAGE: ", constants.FIRST_AID_BANDAGE)
				if injury.injuryType == constants.INJURY_LACERATION and firstAid.firstAidType == constants.FIRST_AID_BANDAGE then
					print("injury.usedBandage:", injury.usedBandage)
					if injury.usedBandage == false then
						print("treated!")
						firstAid.amount = firstAid.amount - 1
						injury:setUsedBandage(true)
					else
						print("already used a bandage")
					end
				end
			end
		end
		Runtime:addEventListener("onUseFirstAid", useFirstAidListener)

		require "views.CharacterView"
		local characterView = CharacterView:new()
		characterView:setPlayer(jxl)

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

	local function testEventDispatcher()
		local objectA = {}
		print("objectA:", objectA.addEventListener)
		require "utils.EventDispatcher"
		EventDispatcher:initialize(objectA)
		print("objectA:", objectA.addEventListener)
		objectA:addEventListener("onTest", function(e)
			print "onTest callback"
			print("e:", e)
			print("self:", self)
			print(showProps(e))
		end)

		local objectB = {}
		function objectB:onTest(event)
			print("objectB::onTest, event:", event)
			showProps(event)
			print(objectB == self)
		end
		objectA:addEventListener("onTest", objectB)

		objectA:dispatchEvent({name="onTest", data="example"})
	end


	setupGlobals()
	setupPhysics()

	-- testLevel1()
	testLevel1AndPlayer()
	--testFloatingText()
	-- testInjuryView()
	-- testFirstAidViews()

	-- testEventDispatcher()
end

local function onError(e)
	-- return true
end
Runtime:addEventListener("unhandledError", onError)
timer.performWithDelay(100, main)

