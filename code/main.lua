require "com.jxl.zombiestick.players.PlayerJXL"
require "com.jxl.zombiestick.players.PlayerFreeman"

require "com.jxl.zombiestick.gamegui.DialogueView"
require "com.jxl.zombiestick.gamegui.LevelView"
require "com.jxl.zombiestick.gamegui.MoviePlayerView"

require "com.jxl.zombiestick.enemies.Zombie"

require "com.jxl.zombiestick.services.LoadLevelService"

require("physics")
physics.setDrawMode("normal")
physics.start()
physics.setGravity(0, 9.8)

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
	--moviePlayer:startMovie(level.movies[1])
	moviePlayer:startMovie(level.movies[2])
end


local function testLevelView()
	local stage = display.getCurrentStage()
	local levelView = LevelView:new(0, 0, stage.width, stage.height)
end


local function testLevelViewBuildFromJSON()
	local stage = display.getCurrentStage()
	local levelView = LevelView:new(0, 0, stage.contentWidth, stage.contentHeight)
	--local level = LoadLevelService:new("sample.json")
	local level = LoadLevelService:new("level-test.json")
	--local level = LoadLevelService:new("Level1.json")
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

testLevelViewBuildFromJSON()