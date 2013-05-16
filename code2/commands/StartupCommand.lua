require "models.firstAidsModel"

StartupCommand = {}

function StartupCommand:new()
	local command = {}

	function command:execute()
		local firstAidsModel = FirstAidsModel:new()
		_G.gFirstAidsModel = firstAidsModel
	end

	return command
end

return StartupCommand