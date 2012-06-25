require "com.jxl.core.services.ReadFileContentsService"
require "com.jxl.core.services.SaveFileService"
json = require "json"

SavedGameTOCService = {}

function SavedGameTOCService:new()
	local service = {}
	service.TOC_FILE_NAME = "zombiesticktoc.txt"

	function service:readTOC()
		local readService = ReadFileContentsService:new()
		local fileJSON = readService:readFileContents(self.TOC_FILE_NAME, system.DocumentsDirectory)
		if fileJSON ~= nil then
			local toc = json.decode(fileJSON)
			return toc
		else
			return {}
		end
	end

	function service:saveTOC(fileName)
		local filesObject = self:readTOC()
		table.insert(filesObject, fileName)
		local saveService = SaveFileService:new()
		return saveService:saveFile(self.TOC_FILE_NAME, system.DocumentsDirectory, json.encode(filesObject))
	end

	function service:deleteTOC()
		local results, reason = os.remove(system.pathForFile(self.TOC_FILE_NAME, system.DocumentsDirectory))
		return results, reason
	end

	return service
end

return SavedGameTOCService