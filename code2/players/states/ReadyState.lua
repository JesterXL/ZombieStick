require "utils.BaseState"

ReadyState = {}

function ReadyState:new()
	local state = BaseState:new("ready")
	
	function state:onEnterState(event)
		print("ReadyState::onEnterState")
		local player = self.entity
		player:showSprite("stand")
		Runtime:addEventListener("onMoveLeftStarted", self)
		Runtime:addEventListener("onMoveRightStarted", self)
		Runtime:addEventListener("onJumpStarted", self)
		Runtime:addEventListener("onJumpRightStarted", self)
		Runtime:addEventListener("onJumpLeftStarted", self)
	end
	
	function state:onExitState(event)
		local player = self.entity
		Runtime:removeEventListener("onMoveLeftStarted", self)
		Runtime:removeEventListener("onMoveRightStarted", self)
		Runtime:removeEventListener("onJumpStarted", self)
		Runtime:removeEventListener("onJumpRightStarted", self)
		Runtime:removeEventListener("onJumpLeftStarted", self)
	end

	function state:onMoveLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("movingLeft")
	end
	
	function state:onMoveRightStarted(event)
		self.stateMachine:changeStateToAtNextTick("movingRight")
	end

	function state:onJumpStarted(event)
		self.stateMachine:changeStateToAtNextTick("jump")
	end

	function state:onJumpRightStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpRight")
	end

	function state:onJumpLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpLeft")
	end

	return state
end

return ReadyState