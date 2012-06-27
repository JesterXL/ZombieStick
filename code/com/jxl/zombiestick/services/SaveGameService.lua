require "com.jxl.zombiestick.vo.SavedGameVO"
require "com.jxl.zombiestick.services.SavedGameTOCService"
require "com.jxl.core.services.SaveFileService"

json = require "json"

SaveGameService = {}

function SaveGameService:new()

	local service = {}

	function service:save(levelView)
		local levelMemento = levelView:getMemento()
		local savedGameVO = SavedGameVO:new()
		savedGameVO.saveDate = tostring(os.date())
		savedGameVO.levelMemento = levelMemento
		savedGameVO.iconImage = levelMemento.iconImage
		savedGameVO.levelVO = levelView.levelVO
		savedGameVO.name = "SavedGame_" .. tostring(savedGameVO.saveDate)
		local jsonString = json.encode(savedGameVO)
		local tocService = SavedGameTOCService:new()
		tocService:saveTOC(savedGameVO.name)
		local saveService = SaveFileService:new()
		saveService:saveFile(savedGameVO.name, system.DocumentsDirectory, json.encode(savedGameVO))
		return true
	end

	return service
end

return SaveGameService