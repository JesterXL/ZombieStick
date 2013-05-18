InjuryViewMediator = {}

function InjuryViewMediator:new()
	local mediator = Mediator:new()

	function mediator:onRegister()
		print("InjuryViewMediator::onRegister")
		local view = self.viewInstance
		print("setting InjuryModel.injuries:", table.maxn(gInjuryModel.injuries))
		view:setInjuries(gInjuryModel.injuries)

		Runtime:addEventListener("InjuryModel_onChange", self)
	end

	function mediator:onRemove()
		Runtime:removeEventListener("InjuryModel_onChange", self)

		local view = self.viewInstance
		self.viewInstance = nil
	end

	function mediator:InjuryModel_onChange(e)
		if e.type == "remove" then
			self.viewInstance:removeInjury(e.injuryVO)
		end
	end
	
	return mediator

end

return InjuryViewMediator