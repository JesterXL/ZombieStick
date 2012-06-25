LevelViewMemento = {}

function LevelViewMemento:new()
	local memento 			= {}
	memento.iconImage 		= nil
	memento.levelMemento 	= nil
	memento.saveDate 		= nil

	return memento
end

return LevelViewMemento