require "players.PlayerJXL"
require "players.PlayerFreeman"

require "gamegui.DialogueView"
require "gamegui.LevelView"

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
	view:show()
	--view:setCharacter(constants.CHARACTER_FREEMAN)
end
--testDialogueView()

local function testLoadLevelService()
	local level = LoadLevelService:new("sample.json")
	print("level: ", level)
	print("backgroundImageShort: ", level.backgroundImageShort)
	print("events: ", level.events, "length: ", #(level.events))
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

local function testLevelView()
	local stage = display.getCurrentStage()
	local levelView = LevelView:new(0, 0, stage.width, stage.height)
end
--testLevelView()

local function testLevelViewBuildFromJSON()
	local stage = display.getCurrentStage()
	local levelView = LevelView:new(0, 0, stage.width, stage.height)
	local level = LoadLevelService:new("sample.json")
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

