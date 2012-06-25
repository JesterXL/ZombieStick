json = require "json"

require "com.jxl.core.services.ReadFileContentsService"

LoadLevelService = {}
function LoadLevelService:new()

	local level = {}

	function level:loadLevelFile(jsonFileName)
		local service = ReadFileContentsService:new()
		local jsonString = service:readFileContents(jsonFileName, system.ResourceDirectory)
		local json = json.decode(jsonString)
		return json
	end

	return level
end

return LoadLevelService