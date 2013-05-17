require "robotlegs.Mediator"
InjuryTreatmentViewMediator = {}

function InjuryTreatmentViewMediator:new()

	local mediator = Mediator:new()

	function mediator:onRegister()
		print("InjuryTreatmentViewMediator::onRegister")
		local view = self.viewInstance

		Runtime:addEventListener("InjuryModel_onChange", self)
	end

	function mediator:onRemove()
		print("InjuryTreatmentViewMediator::onRemove")
		Runtime:removeEventListener("InjuryModel_onChange", self)
		local view = self.viewInstance
		
		self.viewInstance = nil
	end

	function mediator:InjuryModel_onChange(e)
		if e.injuryVO == self.viewInstance.injuryVO then
			self.viewInstance:destroy()
		end
	end

	return mediator

end


return InjuryTreatmentViewMediator