InjuryViewMediator = {}

function InjuryViewMediator:new()
	local mediator = Mediator:new()

	function mediator:onRegister()
		print("InjuryViewMediator::onRegister")
		local view = self.viewInstance
		view:setInjuries(gInjuryModel.injuries)

		Runtime:addEventListener("InjuryModel_onChange", self)
	end

	function mediator:onRemove()
		Runtime:removeEventListener("InjuryModel_onChange", self)

		local view = self.viewInstance
		self.viewInstance = nil
	end

	function mediator:InjuryModel_onChange(e)
		self.viewInstance:removeInjury(e.injuryVO)
	end
	
	return mediator

end

return InjuryViewMediator