
require "com.jxl.zombiestick.services.SavedGameTOCService"

require "com.jxl.core.services.ReadFileContentsService"

json = require "json"

-- TODO: need to make an index file for all saved games. Once I have that,
-- I can use it to get a list of all saved games since Corona apparnetly
-- doesn't have a getFilesInFolder() function.......

LoadSavedGamesService = {}

function LoadSavedGamesService:new()

	local service = {}

	function service:load()
		local savedGames = {}
		local tocService = SavedGameTOCService:new()
		local files = tocService:readTOC()
		local readService = ReadFileContentsService:new()
		for i=1,#files do
			local fileName = files[i]
			local savedGameJSON = readService:readFileContents(fileName, system.DocumentsDirectory)
			local savedGame = json.decode(savedGameJSON)
			table.insert(savedGames, savedGame)
		end
		return savedGames
	end

	return service
end

return LoadSavedGamesService