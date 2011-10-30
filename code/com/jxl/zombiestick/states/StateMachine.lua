StateMachine = {}

function StateMachine:new()
	local machine = {}
	machine.currentState = nil
	machine.previousState = nil
	machine.nextState = nil
	
	function machine:setNextState(state)
		self.nextState = state
	end
	
	function machine:tick(time)
		if self.currentState ~= nil then
			self.currentState:tick(time)
		end
	end
	
	function machine:changeState(state)
		if self.currentState ~= nil then
			self.currentState:exit()
			self.previousState = self.currentState
		end
		self.currentState = state
		self.currentState:enter()
	end
	
	function machine:goToPreviousState()
		self:changeState(self.previousState)
	end
	
	function machine:goToNextState()
		self:changeState(self.nextState)
	end
	
	return machine
end

return StateMachine