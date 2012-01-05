require "com.jxl.core.statemachine.BaseState"
ReadyState = {}

function ReadyState:new()
	local state = BaseState:new("ready")
	state.player = nil
	
	
	function state:onEnterState(event)
		print("ReadyState::onEnterState")
		
		local player = event.data[1]
		self.player = player
		
		player.REST_TIME = 2000
		player.INACTIVE_TIME = 3000
		player.startRestTime = nil
		player.elapsedRestTime = nil
		player.recharge = false
		
		self:reset()
		
		player:showSprite("stand")
	end
	
	function state:onExitState(event)
		print("ReadyState::onExitState")
		self.player = nil
	end
	
	function state:tick(time)
		local player = self.player
		player.elapsedRestTime = player.elapsedRestTime + time
		if player.elapsedRestTime >= player.INACTIVE_TIME then
			player.fsm:changeState("resting", player)
		elseif player.elapsedRestTime >= player.REST_TIME and player.recharge == false then
			player.recharge = true
			player:rechargeStamina()
		end
	end
	
	function state:reset()
		local player = self.player
		player.startRestTime = system.getTimer()
		player.elapsedRestTime = 0
		player.recharge = false
	end
	
	return state
end

return ReadyState