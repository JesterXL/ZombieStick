require "robotlegs.Context"

MainContext = {}

function MainContext:new()

	local context = Context:new()

	function context:init()

		self:mapCommand("onApplicationStartup", 
						"commands.StartupCommand")
		

		self:mapMediator("players.PlayerJXL",
							"mediators.PlayerJXLMediator")

		self:mapMediator("views.InjuryView", 
							"mediators.InjuryViewMediator")

		-- self:mapMediator("views.injuryviews.InjuryTreatmentView", 
		-- 					"mediators.InjuryTreatmentView")

		self:mapMediator("views.injuryviews.FirstAidList",
							"mediators.FirstAidListMediator")

		Runtime:dispatchEvent({name="onApplicationStartup"})
	end

	context:init()

	return context

end

return MainContext