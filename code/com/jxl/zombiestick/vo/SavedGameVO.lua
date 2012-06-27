SavedGameVO = {}

function SavedGameVO:new()
	local game 			= {}
	game.name 			= nil
	game.iconImage 		= nil
	game.levelMemento 	= nil
	game.saveDate 		= nil
	game.levelVO 		= nil

	return game
end

return SavedGameVO