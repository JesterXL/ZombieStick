require "utils.BaseState"

AttackState = {}

function AttackState:new()
	local state = BaseState:new("attack")
	state.startTime = nil
	
	function state:onEnterState(event)
		print("AttackState::onEnterState")
		local player = self.entity
		self.startTime = system.getTimer()
		player:showSprite("attack")
		player:setStamina(player.stamina - player.ATTACK_STAMINA_COST)
		local hits
		local line
		local range = 50
		local xForce
		if player.direction == "left" then
			hits = physics.rayCast(player.x, player.y, player.x - range, player.y, 0)
			line = display.newLine(player.x, player.y, player.x - range, player.y)
			xForce = -2
		else
			hits = physics.rayCast(player.x, player.y, player.x + range, player.y, 0)
			line = display.newLine(player.x, player.y, player.x + range, player.y)
			xForce = 2
		end

		line:setColor(255, 0, 0)
		-- line:setReferencePoint(display.TopLeftReferencePoint)
		mainGroup:insert(line)
		line.x = player.x
		line.y = player.y
		line.tween = transition.to(line, {time = 1000, alpha = 0, onComplete = function(e) line.tween = nil; line:removeSelf() end})

		if hits then
			local i
			for i=1,#hits do
				local hit = hits[i].object
				if hit.classType == "Zombie" then
					hit:applyLinearImpulse(xForce, 0, hit.x, hit.y)
					hit:onHit(2)
					return true
				end
			end

		end
	end

	
	function state:onExitState(event)
		local player = self.entity
	end

	function state:tick(time)
		if system.getTimer() - self.startTime > 400 then
			self.stateMachine:changeStateToAtNextTick("ready")
		end
	end

	return state
end

return AttackState