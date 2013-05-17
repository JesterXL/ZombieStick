PlayerJXLMediator = {}

function PlayerJXLMediator:new()
	local mediator = Mediator:new()

	function mediator:onRegister()
		print("PlayerJXLMediator::onRegister")
		local view = self.viewInstance
		view.injuries = gInjuryModel.injuries

		Runtime:addEventListener("InjuryModel_applyInjury", self)
	end

	function mediator:onRemove()
		print("PlayerJXLMediator::onRemove")

		Runtime:removeEventListener("InjuryModel_applyInjury", self)

		local view = self.viewInstance
		view.injuries = nil
		self.viewInstance = nil
	end

	function mediator:InjuryModel_applyInjury(e)
		local vo = e.injury
		local view = self.viewInstance
		local injuryType = vo.injuryType
		if injuryType == constants.INJURY_BITE then
			view:setHealth(view.health + vo.amount)
		elseif injuryType == constants.INJURY_LACERATION then
			view:setHealth(view.health + vo.amount)
		end
	end

	return mediator

end

return PlayerJXLMediator