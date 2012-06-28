module(..., package.seeall)

function test_loadLevelService()
	require "com.jxl.zombiestick.services.LoadLevelService"
	local level = LoadLevelService:new():loadLevelFile("sample.json")
	assert_not_nil(level, "Level is nil.")
	assert_not_nil(level.backgroundImageShort, "backgroundImageShort is nil.")
	assert_not_nil(level.events, "level.events are nil.")
	assert_not_nil(level.movies, "level.movies are nil.")

	local i = 1
	while level.events[i] do
		local event = level.events[i]
		assert_not_nil(event.type, "type is nil.")
		assert_not_nil(event.subType, "subType is nil.")
		assert_not_nil(event.x, "x is nil.")
		assert_not_nil(event.y, "y is nil.")
		assert_not_nil(event.width, "width is nil.")
		assert_not_nil(event.height, "height is nil.")
		assert_not_nil(event.density, "density is nil.")
		assert_not_nil(event.physicsType, "physicsType is nil.")
		assert_not_nil(event.rotation, "rotation is nil.")
		assert_not_nil(event.when, "when is nil.")
		assert_not_nil(event.pause, "pause is nil.")
		assert_not_nil(event.friction, "friction is nil.")
		assert_not_nil(event.bounce, "bounce is nil.")
		i = i + 1
	end
	
	i = 1
	while level.movies[i] do
		local movie = level.movies[i]
		assert_not_nil(movie.dialogues, "movie.dialogues is nil.")
		local d = 1
		while movie.dialogues[d] do
			local dialogue = movie.dialogues[d]
			assert_not_nil(dialogue.characterName, "dialogue.characterName is nil")
			assert_not_nil(dialogue.emotion, "dialogue.emotion is nil")
			--assert_not_nil(dialogue.audioName, "dialogue.audioName is nil")
			--ssert_not_nil(dialogue.audioFile, "dialogue.audioFile is nil")
			assert_not_nil(dialogue.message, "dialogue.message is nil")
			d = d + 1
		end
		i = i + 1
	end
	
end