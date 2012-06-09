require "com.jxl.zombiestick.players.PlayerJXL"
require "com.jxl.zombiestick.players.PlayerFreeman"

require "com.jxl.zombiestick.gamegui.DialogueView"
require "com.jxl.zombiestick.gamegui.LevelView"
require "com.jxl.zombiestick.gamegui.MoviePlayerView"

require "com.jxl.zombiestick.enemies.Zombie"

require "com.jxl.zombiestick.services.LoadLevelService"

require("physics")

-- TODO: elevators need a switch board so if you fall off, you can call it again.

physics.setDrawMode("hybrid")
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

local function testLoadLevelService()
	local level = LoadLevelService:new("sample.json")
	print("level: ", level)
	print("backgroundImageShort: ", level.backgroundImageShort)
	print("events: ", level.events, ", length: ", #(level.events))
	print("movies: ", level.movies, ", length: ", #(level.movies))
	local i = 1
	while level.events[i] do
		local event = level.events[i]
		print("\t-------------")
		print("\ttype: ", event.type)
		print("\tsubType: ", event.subType)
		print("\tx: ", event.x, ", y: ", event.y, ", width: ", event.width, ", height: ", event.height)
		print("\tdensity: ", event.density, ", friction: ", event.friction, ", bounce: ", event.bounce)
		print("\tphysics type: ", event.physicsType)
		print("\trotation: ", event.rotation)
		print("\twhen: ", event.when)
		print("\tpause: ", event.pause)
		i = i + 1
	end
	
	i = 1
	while level.movies[i] do
		local movie = level.movies[i]
		print("\t>>>>>>>>>>>>>>>>>")
		print("\tdialogues: ", movie.dialogues, ", length: ", #(movie.dialogues))
		local d = 1
		while movie.dialogues[d] do
			local dialogue = movie.dialogues[d]
			print("\t\t=================")
			print("\t\tcharacterName: ", dialogue.characterName)
			print("\t\temotion: ", dialogue.emotion)
			print("\t\taudioName: ", dialogue.audioName)
			print("\t\taudioFile: ", dialogue.audioFile)
			print("\t\tmessage: ", dialogue.message)
			d = d + 1
		end
		i = i + 1
	end
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
	local level = LoadLevelService:new("sample.json")
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
	--local level = LoadLevelService:new("Level1.json")
	local level = LoadLevelService:new("Level1-freeman.json")
	levelView:drawLevel(level)
	levelView:startScrolling()
end


local function testLevelViewBuildFromJSONBuildTwice()
	local stage = display.getCurrentStage()
	local levelView = LevelView:new(0, 0, stage.width, stage.height)
	local level = LoadLevelService:new("sample.json")
	levelView:drawLevel(level)
	levelView:drawLevel(level)
	levelView:startScrolling()
end


local function testZombie()
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
		
		pulley:removeSelf()
		pulley = nil
		

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

function testButtonSeries()
	require "com.jxl.zombiestick.gamegui.hud.ButtonSeries"
	require "com.jxl.zombiestick.core.GameLoop"
	local buttonSeries = ButtonSeries:new()
	local gameLoop = GameLoop:new()
	gameLoop:start()
	gameLoop:addLoop(buttonSeries)
	buttonSeries:setSeriesAndStart(buttonSeries.defaultSeries)
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
--testButtonSeries()
--testAngle()
--testRotation()
--testMath()
--testErrorAbort()
--testHudControlsState()

testLevelViewBuildFromJSON()