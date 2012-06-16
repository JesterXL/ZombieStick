require "com.jxl.core.statemachine.BaseState"

JXLAttackState = {}

function JXLAttackState:new()
	
	local state = BaseState:new("attack")
	
	function state:onAttackAnimationCompleted(event)
		print("*** onAttackAnimationCompleted ***")
		self.stateMachine:changeStateToAtNextTick("ready")
	end
	
	function state:onEnterState(event)
		local player = self.entity
		
		player:addEventListener("onAttackAnimationCompleted", state)
		player.attacking = true
		player:showSprite("attack")
		--player.lastAttack = system.getTimer()
		player:performedAction("attack")
		
		player.swordPolygon = SwordPolygon:new(-99, -99, 20, 2)
		LevelView.instance:insertChild(player.swordPolygon)
		local sword = player.swordPolygon
		sword.y = player.y + (player.height / 2)
		
		local targetX
		local playerBounds = player:getBounds()
		if player.direction == "left" then
			sword.x = player.x + playerBounds[1]
			targetX = sword.x - (sword.width + 5)
		else
			sword.x = player.x + playerBounds[1]
			targetX = player.x + playerBounds[3] + 10
		end
		
		if sword.tween ~= nil then
			transition.cancel(sword.tween)
		end
		if sword.onComplete == nil then
			function sword:onComplete(event)
				sword.x = -999
				sword.y = -999
				sword.tween = nil
				--state:onAttackComplete()
			end
			function sword:collision(event)
				if event.phase == "began" then
					if event.other.classType == "Zombie" then
						Runtime:dispatchEvent({name="onZombieHit", target=self, damage=2, zombie=event.other})
					end
				end
			end
			sword:addEventListener("collision", sword)
		end
		-- TODO: put in tick, too tired right now
		sword.tween = transition.to(sword, {time=100, x=targetX, onComplete=sword})
	end
	
	function state:onExitState(event)
		local player = self.entity
		
		player:removeEventListener("onAttackAnimationCompleted", state)
		
		if player.swordPolygon then
			if player.swordPolygon.tween ~= nil then
				transition.cancel(player.swordPolygon.tween)
			end
			player.swordPolygon:removeSelf()
			player.swordPolyon = nil
		end
		
		player.attacking = false
		player:showSprite("stand")
	end
	
	function state:tick(time)
	end
	
	return state
	
end

return JXLAttackState