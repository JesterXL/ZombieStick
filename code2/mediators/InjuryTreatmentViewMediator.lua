require "robotlegs.Mediator"
InjuryTreatmentViewMediator = {}

function InjuryTreatmentViewMediator:new()

	local mediator = Mediator:new()

	function mediator:onRegister()
		print("InjuryTreatmentViewMediator::onRegister")
		local view = self.viewInstance
	end

	function mediator:onRemove()
		print("InjuryTreatmentViewMediator::onRemove")
		local view = self.viewInstance
		
		self.viewInstance = nil
	end

	return mediator

end


return InjuryTreatmentViewMediator