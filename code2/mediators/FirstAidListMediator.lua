require "robotlegs.Mediator"
FirstAidListMediator = {}

function FirstAidListMediator:new()

	local mediator = Mediator:new()

	function mediator:onRegister()
		print("FirstAidListMediator::onRegister")
		local view = self.viewInstance
		view:setFirstAids(gFirstAidsModel.firstAids)
	end

	function mediator:onRemove()
		print("FirstAidListMediator::onRemove")
		local view = self.viewInstance
		view:setFirstAids(nil)
		self.viewInstance = nil
	end

	return mediator

end


return FirstAidListMediator