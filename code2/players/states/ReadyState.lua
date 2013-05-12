require "utils.BaseState"

ReadyState = {}

function ReadyState:new()
	local state = BaseState:new("ready")
	
	function state:onEnterState(event)
		local player = self.entity
		player:showSprite("stand")
		Runtime:addEventListener("onMoveLeftStarted", self)
		Runtime:addEventListener("onMoveRightStarted", self)
	end
	
	function state:onExitState(event)
		local player = self.entity
		Runtime:removeEventListener("onMoveLeftStarted", self)
		Runtime:removeEventListener("onMoveRightStarted", self)
	end

	function state:onMoveLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("movingLeft")
	end
	
	function state:onMoveRightStarted(event)
		print("ReadyState::onMoveRightStarted")
		self.stateMachine:changeStateToAtNextTick("movingRight")
	end

	return state
end

return ReadyState