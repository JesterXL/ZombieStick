require "models.FirstAidsModel"
require "models.InjuryModel"
require "models.GrapplerModel"

StartupCommand = {}

function StartupCommand:new()
	local command = {}

	function command:execute()
		local firstAidsModel = FirstAidsModel:new()
		_G.gFirstAidsModel = firstAidsModel

		local injuryModel = InjuryModel:new()
		_G.gInjuryModel = injuryModel

		local grapplerModel = GrapplerModel:new()
		_G.gGrapplerModel = grapplerModel
	end

	return command
end

return StartupCommand