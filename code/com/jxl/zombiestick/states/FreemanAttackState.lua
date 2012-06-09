--require "com.jxl.zombiestick.gamegui.LevelView"
require "com.jxl.zombiestick.players.weapons.Freeman9mmBullet"

FreemanAttackState = {}


function FreemanAttackState:new()
	local state = BaseState:new("attack")
	
	function state:onEnterState(event)
		print("FreemanAttackState::onEnterState")
		self:attack(event)
	end
	
	function state:onExitState(event)
		print("FreemanAttackState::onExitState")
	end
	
	--function state:attack
	
	function state:attack(event)
		local player = self.entity
		
		if player.selectedWeapon ~= "gun" then
			player.fsm:changeStateToAtNextTick("ready")
			return
		end
		
		if player:canShoot() == false then
			if player:canReload() then
				player.fsm:changeStateToAtNextTick("reload")
				return
			else
				player.fsm:changeStateToAtNextTick("ready")
				return
			end
		end
		
		player:setGunAmmo(player.gunAmmo - 1)
		
		if player.gunFireSound == nil then
			player.gunFireSound = audio.loadSound("sound-hk-fire.wav")
		end
		audio.play(player.gunFireSound)
		
		player:showSprite("attack")
		-- NOTE/TODO: I don't think Freeman shooting should reduce stamina... if it does, like a freaking 0.01.
		-- Instead, I'd rather focus on his reloading be the stagger time vs. the running around.
		-- He still gets the normal movement + jump stamina reductions.
		--player:performedAction("attack")
		
		local levelView = LevelView.instance
		local lc = levelView.levelChildren
		
		local targetX, targetY
		print("player.lastAttackX: ", player.lastAttackX)
		local localX, localY = levelView:localToContent(player.lastAttackX, player.lastAttackY)
		local variance = 80
		targetX = localX + (lc.x * -1) + (math.random() * variance) - (variance / 2)
		targetY = localY + (lc.y * -1) + (math.random() * variance) - (variance / 2)
		
		if targetX > player.x and player.direction == "left" then
			player:setDirection("right")
		elseif player.direction == "right" and targetX < player.x then
			player:setDirection("left")
		end
		
		local bullet = Freeman9mmBullet:new(player.x + 4, player.y + (player.height / 2), targetX, targetY)
		bullet:addEventListener("onRemoveFromGameLoop", function(e)
															LevelView.instance.gameLoop:removeLoop(bullet)
														end)
		levelView:insertChild(bullet)
		levelView.gameLoop:addLoop(bullet)
		player.fsm:changeStateToAtNextTick("ready")
	end
	
	return state
end

return FreemanAttackState