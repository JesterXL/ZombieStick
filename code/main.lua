require "players.PlayerJXL"
require "players.PlayerFreeman"

require "gamegui.DialogueView"
require "gamegui.LevelView"
require "gamegui.MoviePlayerView"

require "enemies.Zombie"

require "services.LoadLevelService"

require("physics")
physics.setDrawMode( "normal" )
physics.start()
physics.setGravity(0, 9.8)

display.setStatusBar( display.HiddenStatusBar )

local stage = display.getCurrentStage()

local function testDialogueView()
	local view = DialogueView:new()
	--view:setText("Testing.")
	view:setCharacter(constants.CHARACTER_JESTERXL)
	--view:show()
	--view:setCharacter(constants.CHARACTER_FREEMAN)
end
--testDialogueView()

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
--testLoadLevelService()

local function testMoviePlayerView()
	local moviePlayer = MoviePlayerView:new()
	local t = {}
	function t:movieEnded(event)
		print("movieEnded")
	end
	moviePlayer:addEventListener("movieEnded", t)
end
--testMoviePlayerView()

local function testMoviePlayerViewForLevel()
	local level = LoadLevelService:new("sample.json")
	local moviePlayer = MoviePlayerView:new()
	--moviePlayer:startMovie(level.movies[1])
	moviePlayer:startMovie(level.movies[2])
end
--testMoviePlayerViewForLevel()

local function testLevelView()
	local stage = display.getCurrentStage()
	local levelView = LevelView:new(0, 0, stage.width, stage.height)
end
--testLevelView()

local function testLevelViewBuildFromJSON()
	local stage = display.getCurrentStage()
	local levelView = LevelView:new(0, 0, stage.width, stage.height)
	--local level = LoadLevelService:new("sample.json")
	local level = LoadLevelService:new("level-test.json")
	levelView:drawLevel(level)
	levelView:startScrolling()
end
testLevelViewBuildFromJSON()

local function testLevelViewBuildFromJSONBuildTwice()
	local stage = display.getCurrentStage()
	local levelView = LevelView:new(0, 0, stage.width, stage.height)
	local level = LoadLevelService:new("sample.json")
	levelView:drawLevel(level)
	levelView:drawLevel(level)
	levelView:startScrolling()
end
--testLevelViewBuildFromJSONBuildTwice()

local function testZombie()
	local zombie = Zombie:new()
	zombie.x = 100
	zombie.y = 100
end
--testZombie()

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

--testGroupCollisions()

local function testSwordPolygon()
	require "players.weapons.SwordPolygon"
	local sword = SwordPolygon:new(100, 100, 20, 2)
end
--testSwordPolygon()