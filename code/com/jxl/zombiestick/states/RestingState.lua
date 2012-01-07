RestingState = {}

function RestingState:new(playerJXL)
	local state = {}
	state.playerJXL = playerJXL
	state.REST_TIME = 500
	state.startTime = nil
	state.elapsedTime = nil
	state.fsm = playerJXL.fsm
	
	function state:enter()
		print("RestingState::enter")
		self:reset()
		playerJXL:addEventListener("onPerformedAction", self)
	end
	
	function state:exit()
		playerJXL:removeEventListener("onPerformedAction", self)
		self.playerJXL = nil
	end
	
	function state:tick(time)
		self.elapsedTime = self.elapsedTime + time
		if self.elapsedTime >= self.REST_TIME then
			playerJXL:rechargeStamina()
			self:reset()
		end
	end
	
	function state:reset()
		self.startTime = system.getTimer()
		self.elapsedTime = 0
	end
	
	function state:onPerformedAction(event)
		self.fsm:changeState(ReadyState:new(playerJXL))
	end
	
	return state
end

return RestingState