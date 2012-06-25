SaveFileService = {}

function SaveFileService:new()
	local service = {}

	function service:saveFile(fileName, filePath, stringData)
		return assert(self:_saveFile(fileName, filePath, stringData), "Failed to save file.")
	end

	function service:_saveFile(fileName, filePath, stringData)
		local path = system.pathForFile(fileName, filePath)
		local file = io.open(path, "w")
		file:write(stringData)
		io.close(file)
		file = nil
		return true
	end

	return service
end

return SaveFileService