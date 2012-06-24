require "com.jxl.core.statemachine.BaseState"

CoupDeGraceState = {}

function CoupDeGraceState:new()
	
	local state = BaseState:new("coupDeGrace")
	
	function state:onEnterState(event)
		print("CoupDeGraceState::onEnterState")
		local player = self.entity
		-- TODO: make special finishing move attack animation
		local frontTargets = LevelView.instance:getEnemiesInFrontOfMe(player, 160)
		if #frontTargets > 0 then
			local i = 1
			while frontTargets[i] do
				local enemy = frontTargets[1]
				if enemy.fsm.state == "knockedProne" then
					local direction = self.entity.direction
					local xForce = nil
					if direction == "left" then
						xForce = -20
					else
						xForce = 20
					end
					enemy:applyLinearImpulse(xForce, 10, enemy.x, enemy.y)
					enemy:onHit(2)
					player:addEventListener("onAttackAnimationCompleted", self)
					player:showSprite("attack")
					return true
				end
				i = i + 1
			end
		else
			self.stateMachine:changeStateToAtNextTick("ready")
		end
	end

	function state:onExitState(event)
		print("CoupDeGraceState::onExitState")
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

return CoupDeGraceState