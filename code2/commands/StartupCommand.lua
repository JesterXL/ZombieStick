require "models.FirstAidsModel"
require "models.InjuryModel"

StartupCommand = {}

function StartupCommand:new()
	local command = {}

	function command:execute()
		local firstAidsModel = FirstAidsModel:new()
		_G.gFirstAidsModel = firstAidsModel

		local injuryModel = InjuryModel:new()
		_G.gInjuryModel = injuryModel
	end

	return command
end

return StartupCommand