require "com.jxl.zombiestick.states.RestingState"
ReadyState = {}

function ReadyState:new(playerJXL)
	local state = {}
	state.playerJXL = playerJXL
	state.REST_TIME = 2000
	state.INACTIVE_TIME = 3000
	state.startTime = nil
	state.elapsedTime = nil
	state.recharged = false
	state.paused = false
	state.fsm = playerJXL:getStateMachine()
	
	function state:enter()
		print("ReadyState::enter")
		playerJXL:addEventListener("onPerformedAction", self)
		playerJXL:addEventListener("onMoveCompleted", self)
		playerJXL:addEventListener("onJumpCompleted", self)
		self:reset()
	end
	
	function state:exit()
		playerJXL:removeEventListener("onPerformedAction", self)
		playerJXL:removeEventListener("onMoveCompleted", self)
		playerJXL:removeEventListener("onJumpCompleted", self)
		self.playerJXL = nil
	end
	
	function state:tick(time)
		if self.paused == true then return true end
		
		self.elapsedTime = self.elapsedTime + time
		if self.elapsedTime >= self.INACTIVE_TIME then
			self.fsm:changeState(RestingState:new(playerJXL))
		elseif self.elapsedTime >= self.REST_TIME and self.recharge == false then
			self.recharge = true
			playerJXL:rechargeStamina()
		end
	end
	
	function state:reset()
		self.startTime = system.getTimer()
		self.elapsedTime = 0
		self.recharge = false
	end
	
	function state:onPerformedAction(event)
		if event.action == "move" or event.action == "jump" then
			self.paused = true
		else
			self.paused = false
			self:reset()
		end
	end
	
	function state:onMoveCompleted(event)
		self.paused = false
		self:reset()
	end
	
	function state:onJumpCompleted(event)
		self.paused = false
		self:reset()
	end
	
	return state
end

return ReadyState