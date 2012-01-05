require "com.jxl.core.statemachine.BaseState"
RestingState = {}

function RestingState:new()
	local state = BaseState:new("resting")
	state.player = nil
	
	
	function state:onEnterState(event)
		print("RestingState::onEnterState, event.data: ", event.data)
		local player = event.data[1]
		self.player = player
		player.REST_TIME = 500
		self:reset()
	end
	
	function state:onExitState(event)
		print("RestingState::onExitState")
		self.player = nil
	end
	
	function state:tick(time)
		local player = self.player
		player.elapsedRestTime = player.elapsedRestTime + time
		if player.elapsedRestTime >= player.REST_TIME then
			player:rechargeStamina()
			self:reset()
		end
	end
	
	function state:reset()
		self.startRestTime = system.getTimer()
		self.elapsedRestTime = 0
	end
	
	return state
end

return RestingState