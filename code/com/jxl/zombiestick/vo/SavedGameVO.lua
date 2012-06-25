SavedGameVO = {}

function SavedGameVO:new()
	local game 			= {}
	game.name 			= nil
	game.iconImage 		= nil
	game.levelMemento 	= nil
	game.saveDate 		= nil

	return game
end

return SavedGameVO