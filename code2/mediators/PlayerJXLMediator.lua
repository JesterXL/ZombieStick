PlayerJXLMediator = {}

function PlayerJXLMediator:new()
	local mediator = Mediator:new()

	function mediator:onRegister()
		print("PlayerJXLMediator::onRegister")
		local view = self.viewInstance
		view.injuries = gInjuryModel.injuries

		Runtime:addEventListener("InjuryModel_applyInjury", self)
		Runtime:addEventListener("GrapplerModel_onChange", self)
	end

	function mediator:onRemove()
		print("PlayerJXLMediator::onRemove")

		Runtime:removeEventListener("InjuryModel_applyInjury", self)
		Runtime:removeEventListener("GrapplerModel_onChange", self)

		local view = self.viewInstance
		view.injuries = nil
		self.viewInstance = nil
	end

	function mediator:InjuryModel_applyInjury(e)
		local vo = e.injuryVO
		local view = self.viewInstance
		local injuryType = vo.injuryType
		if injuryType == constants.INJURY_BITE then
			view:setHealth(view.health + vo.amount)
		elseif injuryType == constants.INJURY_LACERATION then
			view:setHealth(view.health + vo.amount)
		end
	end

	function mediator:GrapplerModel_onChange(e)
		if e.kind == "add" then
			self.viewInstance.fsm:changeStateToAtNextTick("grappled")
		end
	end

	return mediator

end

return PlayerJXLMediator