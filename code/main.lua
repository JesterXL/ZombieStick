require "com.jxl.zombiestick.players.PlayerJXL"
require "com.jxl.zombiestick.players.PlayerFreeman"

require "com.jxl.zombiestick.gamegui.DialogueView"
require "com.jxl.zombiestick.gamegui.LevelView"
require "com.jxl.zombiestick.gamegui.MoviePlayerView"

require "com.jxl.zombiestick.services.LoadLevelService"

require("physics")


physics.setDrawMode("normal")
physics.start()
physics.setGravity(0, 9.8)
physics.setPositionIterations( 10 )

display.setStatusBar( display.HiddenStatusBar )


local stage = display.getCurrentStage()

function showProps(o)
	print("-- showProps --")
	print("o: ", o)
	for key,value in pairs(o) do
		print("key: ", key, ", value: ", value);
	end
	print("-- end showProps --")
end

local function testDialogueView()
	local view = DialogueView:new()
	--view:setText("Testing.")
	view:setCharacter(constants.CHARACTER_JESTERXL)
	--view:show()
	--view:setCharacter(constants.CHARACTER_FREEMAN)
end



local function testMoviePlayerView()
	local moviePlayer = MoviePlayerView:new()
	local t = {}
	function t:movieEnded(event)
		print("movieEnded")
	end
	moviePlayer:addEventListener("movieEnded", t)
end

local function testMoviePlayerViewForLevel()
	local level = LoadLevelService:new():loadLevelFile("sample.json")
	local moviePlayer = MoviePlayerView:new()
	moviePlayer:startMovie(level.movies[1])
	--moviePlayer:startMovie(level.movies[2])
end


local function testLevelView()
	local stage = display.getCurrentStage()
	local levelView = LevelView:new(0, 0, stage.width, stage.height)
end


local function testLevelViewBuildFromJSON()
	local stage = display.getCurrentStage()
	local levelView = LevelView:new(0, 0, stage.contentWidth, stage.contentHeight)
	--local level = LoadLevelService:new("sample.json")
	--local level = LoadLevelService:new("level-test.json")
	local level = LoadLevelService:new():loadLevelFile("Level1.json")
	--local level = LoadLevelService:new("Level1-freeman.json")
	levelView:drawLevel(level)
	levelView:startScrolling()
end


local function testLevelViewBuildFromJSONBuildTwice()
	local stage = display.getCurrentStage()
	local levelView = LevelView:new(0, 0, stage.width, stage.height)
	local level = LoadLevelService:new():loadLevelFile("sample.json")
	levelView:drawLevel(level)
	levelView:drawLevel(level)
	levelView:startScrolling()
end


local function testZombie()
	require "com.jxl.zombiestick.enemies.Zombie"
	local zombie = Zombie:new()
	zombie.x = 100
	zombie.y = 100
end


local function testGroupCollisions()
	require "gamegui.levelviews.Floor"
	local floor = Floor:new({x = -50, 
							y = 400, 
							width = 600,
							height = 72})
	local crate1 = display.newImage("crate.png")
	local crate2 = display.newImage("crate.png")
	crate1.x = 100
	crate2.x = 100
	crate2.y = -50
	local group1 = display.newGroup()
	group1:insert(crate1)
	
	physics.addBody(crate1)
	physics.addBody(crate2)
end



local function testSwordPolygon()
	require "players.weapons.SwordPolygon"
	local sword = SwordPolygon:new(100, 100, 20, 2)
end


local function testFreemanBullet()
	require "com.jxl.zombiestick.players.weapons.Freeman9mmBullet"
	require "com.jxl.zombiestick.core.GameLoop"
	function makeBullet(event)
		if event.phase == "began" then
			local bullet = Freeman9mmBullet:new(100, 100, event.x, event.y)
			gameLoop:addLoop(bullet)
		end
	end
	gameLoop = GameLoop:new()
	gameLoop:start()
	Runtime:addEventListener("touch", makeBullet)
end


local function testScreenSize()
	local stage = display.getCurrentStage()
	
	local background = display.newRect(0, 0, stage.width, stage.height)
	background.strokeWidth = 4
	background:setStrokeColor(255, 0, 0)
	background:setFillColor(0, 255, 0)
end

local function testCharacterSelectView()
	require "com.jxl.zombiestick.players.PlayerJXL"
	require "com.jxl.zombiestick.players.PlayerFreeman"
	require "com.jxl.zombiestick.gamegui.CharacterSelectView"
	
	local background = display.newRect(0, 0, stage.width, stage.height)
	background.strokeWidth = 4
	background:setStrokeColor(255, 0, 0)
	background:setFillColor(0, 255, 0)

	
	local params = {x = 100,
						y = 100,
						density = 1,
						friction = 1,
						bounce=1}
	local jxl = PlayerJXL:new(params)
	jxl.isVisible = false
	local free = PlayerFreeman:new(params)
	free.isVisible = false
	local view = CharacterSelectView:new()
	view.x = 100
	view.y = 100
	local players = {jxl, free}
	view:redraw(players)
end

local function testStateMachine2()
	require "com.jxl.core.statemachine.statemachinetests"
end

local function testTargetButton()
	require "com.jxl.zombiestick.gamegui.hud.TargetButton"
	local button = TargetButton:new()
	button:show()
end

local function testGrappleState()
	require "com.jxl.zombiestick.states.GrappleState"
	local state = GrappleState:new()
	
end

local function testGunAmmoLine()
	require "com.jxl.zombiestick.gamegui.hud.GunAmmoLine"
	local line = GunAmmoLine:new(10, 10)
	line.x = 100
	line.y = 100
	
	local line2 = GunAmmoLine:new(10, 10)
	line2.x = 100
	line2.y = line.y + line.height + 10
	line2:showBullets(5)
	line2:redraw(12, 6)
	
end

local function testElevator()
	require "com.jxl.zombiestick.gamegui.levelviews.Elevator"
	require "com.jxl.zombiestick.core.GameLoop"
	
	local gameLoop = GameLoop:new()
	gameLoop:start()
	local elevator = Elevator:new(10, 10, 400)
	elevator:goUp()
	gameLoop:addLoop(elevator)
	local t = {}
	function t:onUpComplete()
		elevator:goDown()
	end
	function t:onDownComplete()
		elevator:goUp()
	end
	elevator:addEventListener("onUpComplete", t)
	elevator:addEventListener("onDownComplete", t)
end

function testElevatorButtons()
	require "com.jxl.zombiestick.gamegui.hud.ElevatorControls"
	local controls = ElevatorControls:new()
	local t = {}
	function t:onUpTouched()
		print("up")
	end
	function t:onDownTouched()
		print("down")
	end
	controls:addEventListener("onUpTouched", t)
	controls:addEventListener("onDownTouched", t)
end

function testElevatorAndButtons()
	
	--physics:pause()
	
	mainGroup = display.newGroup()
	
	require "com.jxl.zombiestick.gamegui.levelviews.Elevator"
	require "com.jxl.zombiestick.core.GameLoop"
	
	local rect = display.newRect(110, 10, 10, 10)
	rect:setFillColor(255, 255, 255, 100)
	rect.isVisible = false
	
	local gameLoop = GameLoop:new()
	gameLoop:start()
	local elevator = Elevator:new(200, 0, 300, mainGroup)
	gameLoop:addLoop(elevator)
	
	rect.x = elevator.x
	rect.y = elevator.y
	
	
	require "com.jxl.zombiestick.gamegui.hud.ElevatorControls"
	local controls = ElevatorControls:new()
	local t = {}
	function t:onUpElevatorButtonTouched()
		elevator:goUp()
	end
	function t:onDownElevatorButtonTouched()
		elevator:goDown()
	end
	controls:addEventListener("onUpElevatorButtonTouched", t)
	controls:addEventListener("onDownElevatorButtonTouched", t)
	--[[
	mainGroup:insert(elevator)
	mainGroup.x = 400
	local scroller = {}
	function scroller:timer()
		print("weeee")
		transition.to(mainGroup, {time=2000, x=-500, transition=easing.outExpo})
	end
	timer.performWithDelay(1000, scroller)
	]]--
	
	
	local test = {}
	function test:timer()
		transition.to(mainGroup, {y=-100, time=2000})
	end
	--timer.performWithDelay(4000, test)
	
	--physics.setDrawMode("debug")
end

function testRect()
	local rect = display.newRect(0, 0, 20, 20)
	rect.x = 100
	rect.y = 20
	
	local group = display.newGroup()
	group:insert(rect)
	group.x = 50
	group.y = 50
end

function testFallingDrawBridge()
	local rect1 = display.newRect(0, 0, 200, 20)
	--rect1:setReferencePoint(display.TopLeftReferencePoint)
	rect1.y = 200
	
	local rect2 = display.newRect(0, 0, 200, 20)
	--rect2:setReferencePoint(display.TopLeftReferencePoint)
	rect2.x = 400
	rect2.y = 250
	
	local bridge = display.newRect(0, 0, 200, 20)
	--bridge:setReferencePoint(display.TopLeftReferencePoint)
	bridge:setFillColor(255, 0, 0)
	bridge.x = rect1.x + rect1.width - 20
	bridge.y = rect1.y - bridge.height * 4 - 2
	
	physics.addBody(rect1, "static")
	physics.addBody(rect2, "static")
	physics.addBody(bridge, "dynamic")
	
	bridgeConnector = physics.newJoint( "distance", 
								rect1, bridge, 
								rect1.x + (rect1.width / 2), rect1.y - 10,
								bridge.x - (rect1.width / 2), bridge.y + 10)
	bridgeConnector.length = 4
	
	local pulleyRect = display.newRect(0, 0, 20, 20)
	pulleyRect:setReferencePoint(display.TopLeftReferencePoint)
	pulleyRect.x = 20
	pulleyRect.y = 20
	
	local box = display.newRect(0, 0, 20, 20)
	box.x = 40
	box.y = 150
	physics.addBody(box, {density=2, friction=2, bounce=0.1})
	
	-- myJoint = physics.newJoint( "pulley", 
										--crateA, crateB, 
										--anchorA_x,anchorA_y, 
										--anchorB_x,anchorB_y, 
										--crateA.x,crateA.y, 
										--crateB.x,crateB.y,
										--1.0 )
	pulley = physics.newJoint( "pulley", 
								box, bridge, 
								pulleyRect.x, pulleyRect.y,
								pulleyRect.x + pulleyRect.width, pulleyRect.y,
								box.x, box.y,
								bridge.x + bridge.width / 2, bridge.y + 10,
							1)
	
	physics.setDrawMode("hybrid")
	
	local t = {}
	function t:timer()
		
		--pulley:removeSelf()
		--pulley = nil
		
		box.setDensity(0.2)
		box.resetMassData()

		--bridge.rotation = 0
		--bridge.y = bridge.y - 100
		--bridge.x = bridge.x - 40
		
		--joint = physics.newJoint( "distance", 
	--								rect1, bridge, 
		--							rect1.x + (rect1.width / 2), rect1.y,
		--							bridge.x - (rect1.width / 2), bridge.y)
		
		
		--bridge.rotation = -45
		
		--rope = physics.newJoint("weld",
		--							rect1, bridge,
		--							bridge.x + (bridge.width / 2), bridge.y)
									
		
		
		--if joint == nil then
		--	joint = physics.newJoint( "pivot", bridge, rect1, bridge.x - (bridge.width / 2), bridge.y)
		--	joint.isMotorEnabled = true
		--	joint.maxMotorTorque = 100000
		--	joint.motorSpeed = 10
			--joint.isLimitEnabled = true
			--joint:setRotationLimits(-45, 45)
		--end
	end
	timer.performWithDelay(3000, t)

end

function testFallingDrawBridegeForce()
	local rect1 = display.newRect(0, 0, 200, 20)
	--rect1:setReferencePoint(display.TopLeftReferencePoint)
	rect1.y = 200
	
	local rect2 = display.newRect(0, 0, 200, 20)
	--rect2:setReferencePoint(display.TopLeftReferencePoint)
	rect2.x = 400
	rect2.y = 250
	
	local bridge = display.newRect(0, 0, 200, 20)
	--bridge:setReferencePoint(display.TopLeftReferencePoint)
	bridge:setFillColor(255, 0, 0)
	bridge.x = rect1.x + rect1.width - 20
	bridge.y = rect1.y - bridge.height * 4 - 2

	
	physics.addBody(rect1, "static")
	physics.addBody(rect2, "static")
	physics.addBody(bridge, "dynamic")
	
	bridgeConnector = physics.newJoint( "distance", 
								rect1, bridge, 
								rect1.x + (rect1.width / 2), rect1.y - 10,
								bridge.x - (rect1.width / 2), bridge.y + 10)
	bridgeConnector.length = 1
	
	local pulleyRect = display.newRect(0, 0, 20, 20)
	pulleyRect:setReferencePoint(display.TopLeftReferencePoint)
	pulleyRect.x = 80
	pulleyRect.y = 40
	physics.addBody(pulleyRect,"static", {density = 1, friction = 1, bounce = 0.1})
	
	physics.setDrawMode("hybrid")
	
	bridge.rotation = -190

	local t = {}
	function t:timer(event)
		bridge:applyForce(6, 0, bridge.width, 0)
	end
	timer.performWithDelay(1000, t, 1)
end

function testSwipes()
	print("testSwipes")
	lines = display.newGroup()
	t = {}
	t.startX = 0
	t.startY = 0
	function t:drawRect(startX, startY, endX, endY)
		local line = display.newLine(startX, startY, endX, endY)
		line:setReferencePoint(display.TopLeftReferencePoint)
		line.width = 2
		line:setColor(255, 0, 0)
		lines:insert(line)
	end
	
	function t:destroyAllLines()
		local len = lines.numChildren
		print("len: ", len)
		while len > 0 do
			local line = lines[len]
			line:removeSelf()
			len = len - 1
		end
	end
	
	function t:touch(event)
		--[[
		event.id
		event.name
		event.phase
		event.target
		event.time
		event.x
		event.xStart
		event.y
		event.yStart
		]]--
		--print("p: ", event.phase, ", x: ", event.x, ", xStart: ", event.xStart, ", time: ", event.time)
		
		if event.phase == "began" then
			self:destroyAllLines()
			self.startX = event.xStart
			self.startY = event.yStart
		end
		
		self:drawRect(self.startX, self.startY, event.x, event.y)
		
		if event.phase == "moved" then
			self.startX = event.x
			self.startY = event.y
		end
		
	end

	Runtime:addEventListener("touch", t)
end

function testAngle()
	local t = {}
	--[[
	ranges = {
		{min = 80, max = 100, value = 90},
		{min = -170, max = 170, value = 180},
		{min = -100, max = -80, value = -90},
		{min = -10, max = 10, value = 0},
		{min = 35, max = 55, value = 45},
		{min = 125, max = 145, value = 135},
		{min = -145, max = -125, value =-135}
	}
	]]--
	function getAngle(startX, startY, endX, endY)
		local angle = math.atan2(startY - endY, startX - endX)
		angle = math.deg(angle)
		return angle
	end
	
	-- value = thumbSprite.x * (maximum - minimum) / (width - thumbSprite.width) + minimum;
	
	textField = display.newRetinaText("--", 0, 0, 100, 20)
	endValueField = display.newRetinaText("--", 0, 30, 100, 20) 
	
	function calculateEndValue(startX, startY, endX, endY)
		local angle = getAngle(startX, startY, endX, endY)
		if angle >= 70 and angle <= 110 then
			angle = 90
		elseif (angle >= -180 and angle <= -160) or (angle >= 160 and angle <= 180) then
			angle = 180
		elseif angle >= -110 and angle <= -70 then
			angle = -90
		elseif (angle >= -20 and angle <= 0) or (angle >= 0 and angle <= 20) then
			angle = 0
		elseif angle >= 25 and angle <= 65 then
			angle = 45
		elseif angle >= -65 and angle <= -25 then
			angle = -45
		elseif angle >= 115 and angle <= 155 then
			angle = 135
		elseif angle >= -155 and angle <= -115 then
			angle = -135
		else
			--error("Unknown angle")
			angle = "???"
			--return false
		end
		--[[
		local len = #ranges
		local i
		for i = 1, len do
			local range = ranges[i]
			local valueRange = range.max - range.min
			if angle >= range.min and angle <= range.max then
				endValueField.text = "angle: " .. range.value
				return true
			end
		end
		]]--
		
		endValueField.text = "angle: " .. angle
	end
	
	function t:drawLine(startX, startY, endX, endY)
		if self.line then
			self.line:removeSelf()
		end
		self.line = display.newLine(startX, startY, endX, endY)
		self.line:setReferencePoint(display.TopLeftReferencePoint)
		self.line.width = 2
		self.line:setColor(255, 0, 0)
		
		textField.text = getAngle(startX, startY, endX, endY)
	end
	
	function t:touch(event)
		--self:drawLine(event.xStart, event.yStart, event.x, event.y)
		
		if event.phase == "began" then
			endValueField.text = ""
		elseif event.phase == "ended" then
			calculateEndValue(event.xStart, event.yStart, event.x, event.y)
		end
	end

	Runtime:addEventListener("touch", t)
end

function testForLoop()
	for i=1,10 do
		print("yo: " .. i)
	end
end

function testRotation()
	rect = display.newRect(0, 0, 100, 100)
	
	function doRotation()
		rect.rotation = rect.rotation + 1
		print("rect.rotation: ", rect.rotation)
	end
	
	Runtime:addEventListener("enterFrame", doRotation)
end

function testMath()
	local max = 10
	local min = -10
	local range = max - min
	print("range: ", range)
end

function testErrorAbort()

	function test(moo)
		if moo == nil then
			error("moo cannot be nil")
			print("after error")
		end
		return true
	end

	local result = test()
	print("result is: ", result)
end

function testHudControlsState()
	require "com.jxl.zombiestick.gamegui.hud.HudControls"
	require "com.jxl.zombiestick.core.GameLoop"


	local gameLoop = GameLoop:new()
	assert(gameLoop ~= nil, "Failed to create GameLoop.")
	gameLoop:reset()
	gameLoop:start()

	local stage = display.getCurrentStage()
	local hudControls = HudControls:new(stage.width, stage.height)
	gameLoop:addLoop(hudControls.fsm)

	local state = hudControls.fsm.state
	assert(state == "HudControlsJXL", "Incorrect initial state.")
	hudControls.fsm:changeStateToAtNextTick("HudControlsFreeman")
end

function testStaminaHeadText()
	

	function showStaminaText(targetX, targetY, amount)
		local field = display.newRetinaText("", 0, 0, 60, 60)
		field:setReferencePoint(display.TopLeftReferencePoint)
		field.x = targetX
		field.y = targetY
		local amountText = tostring(amount)
		if amount > 0 then
			amountText = "+" .. amountText
		elseif amount < 0 then
			amountText = "-" .. amountText
		end
		field.text = amountText
		local newTargetY = targetY - 40
		field.tween = transition.to(field, {y=newTargetY, time=1000, transition=easing.outExpo})
		field.alphaTween = transition.to(field, {alpha=0, time=300, delay=800})
	end

	function onTouch(event)
		if event.phase == "began" then
			showStaminaText(event.x, event.y, 2)
		end
	end
	Runtime:addEventListener("touch", onTouch)

end

function testObjectPool()
	require "com.jxl.zombiestick.core.ObjectPool"
	require "com.jxl.zombiestick.core.GameLoop"

	local group = display.newGroup()

	local pool = ObjectPool:new()
	assert(pool.items ~= nil, "Items are nil.")
	assert(table.maxn(pool.items) == 0, "Incorrect length")

	print(type(display.newText))
	print(type(ObjectPool))
	print("display.newText: ", display.newText)
	print("display.newText is not nil: ", (display.newText ~= nil))
	local text = pool:get(display.newText, {"test", 0, 0, 60, 60})
	assert(text ~= nil, "text is nil")
	assert(text.text == "test", "text is not equal to 'test'")
	assert(text.name == nil, "text's name is not nil")

	assert(GameLoop ~= nil, "GameLoop class is nil.")
	print("GameLoop: ", GameLoop)
	print("GameLoop type: ", type(GameLoop))
	local loop = pool:get(GameLoop)
	assert(loop ~= nil, "gameLoop is nil")

	group:insert(text)

	text.name = "JesseText"

	pool:add(text)

	local newText = pool:get()

end

function testGenericButton()
	require "com.jxl.zombiestick.gamegui.buttons.GenericButton"
	local button = GenericButton:new("Default")
end

function testClockwiseAndCounterclockwiseSwipeButton()
	local stage = display.getCurrentStage()
	
	local background = display.newRect(0, 0, stage.width, stage.height)
	background.strokeWidth = 4
	background:setStrokeColor(255, 0, 0)
	background:setFillColor(25, 255, 255)

	require "com.jxl.zombiestick.gamegui.buttons.ClockwiseSwipeButton"
	local button = ClockwiseSwipeButton:new()
	button.x = 100
	button.y = 100
	function onClockwiseSwipe(event)
		print("onClockwiseSwipe")
		field.text = "onClockwiseSwipe " .. tostring(system.getTimer())
	end
	button:addEventListener("onClockwiseSwipe", onClockwiseSwipe)

	require "com.jxl.zombiestick.gamegui.buttons.CounterclockwiseSwipeButton"
	local counter = CounterclockwiseSwipeButton:new()
	counter.x = button.x + button.width
	counter.y = button.y
	function onCounterclockwiseSwipe(event)
		print("onCounterclockwiseSwipe")
		field.text = "onCounterclockwiseSwipe " .. tostring(system.getTimer())
	end
	counter:addEventListener("onCounterclockwiseSwipe", onCounterclockwiseSwipe)

	field = display.newText("test", 0, 0, native.systemFont, 16)
	field:setReferencePoint(display.TopLeftReferencePoint)
	field:setTextColor(0, 0, 0)
	field.x = 100
	field.y = 300

end

function testCircleButton()
	require "com.jxl.zombiestick.gamegui.buttons.CircleButton"
	require "com.jxl.zombiestick.gamegui.buttons.ClockwiseSwipeButton"

	local button = CircleButton:new(200, 200)
	local field = display.newText("--", 0, 0, native.systemFont, 16)
	field:setTextColor(255, 255, 255)
	field:setReferencePoint(display.TopLeftReferencePoint)

	function onHitListChanged(event)
		--local str = "---------\n"
		local str = ""
		local i = 1
		local hitList = button.hitList
		
		while hitList[i] do
			str = str .. hitList[i].name .. ","
			i = i + 1
		end
		--print(str)
		field.text = str
		field.x = (field.width / 2)
	end

	function onCircleSwipe(event)
		print("onCircleSwipe, direction: ", event.direction)
		if anime == nil then
			anime = ClockwiseSwipeButton:new()
		else
			anime.isVisible = true
		end
		anime.x = button.x + button.width
		anime.y = 0
		anime:play()
		anime.alpha = 1

		if hideTimer == nil then
			hideTimer = {}
			function hideTimer:timer(event)
				anime:pause()
				transition.to(anime, {alpha=0, time=300})
			end
		else
			timer.cancel(hideTimer.timerHandler)
		end
		hideTimer.timerHandler = timer.performWithDelay(500, hideTimer)
	end

	button:addEventListener("onHitListChanged", onHitListChanged)
	button:addEventListener("onCircleSwipe", onCircleSwipe)
	button.x = 10
	button.y = 10

	field.y = button.y + button.height + 4
	
	--local fore = display.newRect(button.x, button.y, button.width, button.height)
	--fore.strokeWidth = 4
	--fore:setStrokeColor(255, 0, 0)
	--fore:setFillColor(0, 0, 190, 100)
end

function testArrayIndexOf()
	local list = {}
	local cow = {name = "Moo"}
	table.insert(list, cow)
	print("indexOf cow: ", table.indexOf(list, cow))
	local nothing = {}
	print("indexOf nothing: ", table.indexOf(nothing, cow))
end

function testHole()
	local hole = display.newImage("hole.png")
	function hole:touch(event)
		print("phase: ", event.phase)
	end
	hole:addEventListener("touch", hole)
	hole.isHitTestMasked = true
	print("hole.isHitTestMasked: ", hole.isHitTestMasked)
end

function testSwipeButton()
	require "com.jxl.zombiestick.gamegui.buttons.SwipeButton"
	local stage = display.getCurrentStage()
	local button = SwipeButton:new(stage.width, stage.height)
	function onSwipe(event)
		print("angle: ", event.angle)
	end
	button:addEventListener("onSwipe", onSwipe)
end

function testSwipeDownButton()
	require "com.jxl.zombiestick.gamegui.buttons.SwipeDownButton"
	local button = SwipeDownButton:new()
	button.x = 0
	button.y = 0

	function onSwipeDown(event)
		print("onSwipeDown")
	end
	button:addEventListener("onSwipeDown", onSwipeDown)
end

function testSwipeButtons()
	require "com.jxl.zombiestick.gamegui.buttons.SwipeDownButton"
	require "com.jxl.zombiestick.gamegui.buttons.SwipeUpButton"
	require "com.jxl.zombiestick.gamegui.buttons.SwipeRightButton"
	require "com.jxl.zombiestick.gamegui.buttons.SwipeLeftButton"

	local downButton = SwipeDownButton:new()
	downButton.x = 0
	downButton.y = 0

	local upButton = SwipeUpButton:new()
	upButton.x = downButton.x + downButton.width
	upButton.y = 0

	local rightButton = SwipeRightButton:new()
	rightButton.x = 0
	rightButton.y = downButton.y + downButton.height

	local leftButton = SwipeLeftButton:new()
	leftButton.x = rightButton.x + rightButton.width
	leftButton.y = rightButton.y

	function onSwipeDown(event)
		print("onSwipeDown")
		field.text = "onSwipeDown " .. system.getTimer()
	end

	function onSwipeUp(event)
		print("onSwipeUp")
		field.text = "onSwipeUp " .. system.getTimer()
	end

	function onSwipeRight(event)
		print("onSwipeRight")
		field.text = "onSwipeRight " .. system.getTimer()
	end

	function onSwipeLeft(event)
		print("onSwipeLeft")
		field.text = "onSwipeLeft " .. system.getTimer()
	end

	downButton:addEventListener("onSwipeDown", onSwipeDown)
	upButton:addEventListener("onSwipeUp", onSwipeUp)
	rightButton:addEventListener("onSwipeRight", onSwipeRight)
	leftButton:addEventListener("onSwipeLeft", onSwipeLeft)

	field = display.newText("test", 0, 0, native.systemFont, 16)
	field:setReferencePoint(display.TopLeftReferencePoint)
	field:setTextColor(255, 255, 255)
	field.x = 100
	field.y = 300
end

function testPlayerHealth()
	require "com.jxl.zombiestick.players.PlayerJXL"
	local player = PlayerJXL:new({x=100, y=100, usePhysics=false})

	local t = {}
	function t:timer(event)
		player:reduceHealth(1)
	end
	timer.performWithDelay(1000, t, 3)

	local other = {}
	function other:timer(event)
		player:rechargeHealth()
	end
	timer.performWithDelay(4000, other, 1)

end

function testButtonSeries()
	require "com.jxl.zombiestick.gamegui.hud.ButtonSeries"
	require "com.jxl.zombiestick.gamegui.buttons.SwipeDownButton"
	require "com.jxl.zombiestick.gamegui.buttons.SwipeUpButton"
	require "com.jxl.zombiestick.gamegui.buttons.SwipeRightButton"
	require "com.jxl.zombiestick.gamegui.buttons.SwipeLeftButton"
	local buttons = {SwipeUpButton, SwipeRightButton, SwipeDownButton, SwipeLeftButton}
	local buttonSeries = ButtonSeries:new(buttons)
	buttonSeries.x = 100
	buttonSeries.y = 100
	buttonSeries:start()
	function onButtonSeriesComplete(event)
		print("onButtonSeriesComplete")
	end
	buttonSeries:addEventListener("onButtonSeriesComplete", onButtonSeriesComplete)

end

function testHealButtonSeries()
	require "com.jxl.zombiestick.gamegui.hud.ButtonSeries"
	require "com.jxl.zombiestick.gamegui.buttons.CounterclockwiseSwipeButton"
	require "com.jxl.zombiestick.gamegui.buttons.SwipeRightButton"
	require "com.jxl.zombiestick.gamegui.buttons.SwipeLeftButton"
	require "com.jxl.zombiestick.gamegui.buttons.SwipeUpButton"
	require "com.jxl.zombiestick.gamegui.buttons.SwipeDownButton"
	local buttons = {SwipeDownButton,
						SwipeUpButton,
						CounterclockwiseSwipeButton,
						CounterclockwiseSwipeButton,
						CounterclockwiseSwipeButton,
						SwipeRightButton,
						SwipeLeftButton,
						SwipeRightButton,
						SwipeLeftButton}
	local buttonSeries = ButtonSeries:new(buttons)
	buttonSeries.x = 100
	buttonSeries.y = 100
	buttonSeries:start()
	function onButtonSeriesComplete(event)
		print("onButtonSeriesComplete")
	end
	buttonSeries:addEventListener("onButtonSeriesComplete", onButtonSeriesComplete)

end


function testArray()
	local t = {1, 2, 3, 4, 5}
	print(t, " and length: ", #t)
	table.remove(t, 1)
	print("first: ", t[1])
	print("length now: ", #t)
	table.remove(t, #t - 1)
	print("new length: ", #t)
	print("#3: ", t[3])
	table.remove(t, #t)
	print("final length: ", #t)
	print("2: ", t[2], " vs ", t[#t])
end

function testTaps()
	local rect = display.newRect(100, 100, 100, 100)
	rect:setReferencePoint(display.TopLeftReferencePoint)
	rect:setFillColor(255, 0, 0, 180)

	function rect:tap(event)
		print("numTaps: ", event.numTaps)
	end
	rect:addEventListener("tap", rect)
end

function testTapButton()
	require "com.jxl.zombiestick.gamegui.buttons.TapButton"
	local button = TapButton:new()
	button.x = 100
	button.y = 100
end 

function testLevelCover()

	local rect = display.newRect(0, 0, 800, 800)
	rect:setReferencePoint(display.TopLeftReferencePoint)
	rect:setFillColor(0, 0, 0)
	rect.x = 0
	rect.y = 0
	rect.alpha = 0

	transition.to(rect, {time=5 * 1000, alpha=0.8})
end

function testHasEventSource()
	function onCow(event)
		print("onCow fired")
	end
	Runtime:addEventListener("cow", onCow)
	Runtime:dispatchEvent({name="cow", target=Runtime})
	local result, e = Runtime:hasEventSource("cow")
	print("result: ", result, ", e: ", e)
end

function testZombieContentBounds()
	require "com.jxl.zombiestick.enemies.Zombie"
	physics.pause()
	local zombie = Zombie:new()
	local t = {}
	function t:timer(e)
		zombie.rotation = zombie.rotation + 1
		print("zombie.width: ", zombie.width, ", contentWidth: ", zombie.contentWidth)
	end
	timer.performWithDelay(100, t, 0)
	zombie.x = 200
	zombie.y = 200
	zombie.rotation = -90
end

function testFloatingText()
	require "com.jxl.zombiestick.gamegui.FloatingText"
	require "com.jxl.zombiestick.constants"
	local float = FloatingText:new()
	float:init()
	function onTouch(event)
		--if event.phase == "began" then
			float:showText(event.x, event.y, 1, constants.TEXT_TYPE_STAMINA)
		--end
	end
	Runtime:addEventListener("touch", onTouch)
end

function testForLoop()
	for i=1,10 do
		print(i)
	end
end

function testReadAndSaveFileServices()
	require "com.jxl.core.services.ReadFileContentsService"
	require "com.jxl.core.services.SaveFileService"

	local saveFile = SaveFileService:new()
	local data = "moo"
	assert(saveFile:saveFile("test.txt", system.DocumentsDirectory, data), "Failed to save test.txt")

	local readFile = ReadFileContentsService:new()
	local contents = readFile:readFileContents("test.txt", system.DocumentsDirectory)
	print("contents: ", contents)
end

function testBasicFiles()
	local test = io.open(system.pathForFile("basic.txt", system.DocumentsDirectory), "r")
	print("test: ", test)
end

function testTOCService()
	require "com.jxl.zombiestick.services.SavedGameTOCService"

	local service = SavedGameTOCService:new()
	service:deleteTOC()
	
	--[[
	local list = service:readTOC()
	assert(list, "TOC is nil.")
	assert(table.maxn(list) == 0, "TOC length is not 0.")

	service:saveTOC("testTOCService.txt")
	local updatedList = service:readTOC()
	assert(updatedList, "2 TOC is nil.")
	assert(table.maxn(updatedList) == 1, "Incorrect file count, actual is: " .. table.maxn(updatedList))

	-- test if 2 can work
	service:saveTOC("yetAnotherTestTOCService.txt")
	local newList = service:readTOC()
	assert(newList, "3 TOC is nil.")
	assert(table.maxn(newList) == 2, "3 Incorrect file count, actual is: " .. table.maxn(newList))
	]]--
end

function testSavingGames()
	require "com.jxl.zombiestick.services.SaveGameService"
	require "com.jxl.zombiestick.services.LoadSavedGamesService"
	local service = SavedGameTOCService:new()
	service:deleteTOC()

	local loadService = LoadSavedGamesService:new()
	local anyFiles = loadService:load()
	assert(#anyFiles == 0, "anyFiles is not == 0")

	local levelViewMock = {getMemento = function() return {iconImage = "button-gun.png"} end}
	local saveGameService = SaveGameService:new()
	saveGameService:save(levelViewMock)

	local savedFiles = loadService:load()
	assert(#savedFiles == 1, "savedFiles is not == to 1")
end

function testShowSaveGameScreen()
	require "com.jxl.zombiestick.screens.SavedGameScreen"
	require "com.jxl.zombiestick.services.LoadSavedGamesService"
	local screen = SavedGameScreen:new()
	screen.x = 100
	screen.y = 100
	local savedGames = LoadSavedGamesService:new():load()
	print("#savedGames: ", #savedGames)
	screen:init(savedGames)
end

function testCurtain()
	
	function getBox()
		local rect = display.newRect(0, 0, 6, 6)
		rect:setFillColor(0, 0, 180, 200)
		return rect
	end

	local mainLink = getBox()
	physics.addBody(mainLink, "static")

	local links = {}
	local joints = {}
	local holder = display.newGroup()
	holder.x = 40
	holder.y = 40
	local j = 1
	local MAX_LINKS = 10
	local startX = 0
	local startY = 0
	for j = 1,MAX_LINKS do
		local link = getBox()
		links[j] = link
		link.x = startX
		link.y = startY
		holder:insert(link)

		physics.addBody(link, { density=0.1, friction=.3, bounce=0 } )
		link.angularDamping = 10
		link.linearDamping = 10

		
		if (j > 1) then
			prevLink = links[j-1]
		else
			prevLink = mainLink
		end
		
		local jointIndex = #joints + 1
		joints[jointIndex] = physics.newJoint("pivot", prevLink, link, startX, startY)
		
		startY = startY + link.height
		
		lastLink = link
	end

end


--testScreenSize()
--testFreemanBullet()
--testSwordPolygon()
--testGroupCollisions()
--testZombie()
--testLevelViewBuildFromJSONBuildTwice()

--testLevelView()
--testMoviePlayerViewForLevel()
--testMoviePlayerView()
--testLoadLevelService()
--testDialogueView()
--testCharacterSelectView()
--testStateMachine2()
--testTargetButton()
--testGrappleState()
--testGunAmmoLine()
--testElevator()
--testElevatorButtons()
--testElevatorAndButtons()
--testRect()
--testFallingDrawBridge()
--testFallingDrawBridegeForce()
--testSwipes()
--testForLoop()
--testAngle()
--testRotation()
--testMath()
--testErrorAbort()
--testHudControlsState()
--testStaminaHeadText()
--testObjectPool()
--testGenericButton()
--testClockwiseAndCounterclockwiseSwipeButton()
--testCircleButton()
--testArrayIndexOf()
--testHole()
--testSwipeButton()
--testSwipeDownButton()
--testSwipeButtons()
--testPlayerHealth()
--testButtonSeries()
--testHealButtonSeries()
--testArray()
--testTaps()
--testTapButton()
--testHasEventSource()
--testZombieContentBounds()
--testFloatingText()
--testForLoop()
--testReadAndSaveFileServices()
--testBasicFiles()
--testTOCService()
--testSavingGames()
--testShowSaveGameScreen()
--testCurtain()

testLevelViewBuildFromJSON()
--testLevelCover()

--require "testsmain"