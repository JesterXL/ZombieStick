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


		local first, direction, xForce
		direction = self.entity.direction

		local proneTargets = LevelView.instance:getEnemiesInFrontOfMe(player, 150)
		if #proneTargets > 0 then
			local i = 1
			while proneTargets[i] do
				if proneTargets[i].fsm.state == "knockedProne" then
					--[[
					first = proneTargets[1]
					if direction == "left" then
						xForce = -20
					else
						xForce = 20
					end
					first:applyLinearImpulse(xForce, 10, first.x, first.y)
					first:onHit(20)
					]]--
					self.stateMachine:changeState("coupDeGrace")
					return true
				end
				i = i + 1
			end
		end

		local frontTargets = LevelView.instance:getEnemiesInFrontOfMe(player, 42)
		--print("#frontTargets: ", #frontTargets)
		if #frontTargets > 0 then
			first = frontTargets[1]
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