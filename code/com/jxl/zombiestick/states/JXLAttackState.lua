require "com.jxl.core.statemachine.BaseState"

JXLAttackState = {}

function JXLAttackState:new()
	
	local state = BaseState:new("attack")
	state.startTime = nil
	
	function state:onEnterState(event)
		print("JXLAttackState::onEnterState")
		self.startTime = system.getTimer()
		local player = self.entity
		player:addEventListener("onAttackAnimationCompleted", self)
		player:showSprite("attack")

		local frontTargets = LevelView.instance:getEnemiesInFrontOfMe(player, 42)
		if #frontTargets > 0 then
			local first = frontTargets[1]
			local direction = self.entity.direction
			local xForce = nil
			if direction == "left" then
				xForce = -2
			else
				xForce = 2
			end
			first:applyLinearImpulse(xForce, 0, first.x, first.y)
			first:onHit(2)
		end
	end

	function state:onExitState(event)
		print("JXLAttackState::onExitState, time: ", (system.getTimer() - self.startTime))
		local player = self.entity
		player:removeEventListener("onAttackAnimationCompleted", self)
		player:showSprite("stand")
	end

	function state:onAttackAnimationCompleted(event)
		self.entity:showSprite("stand")
		self.stateMachine:changeStateToAtNextTick("ready")
	end
	
	function state:tick(time)
	end
	
	return state
	
end

return JXLAttackState