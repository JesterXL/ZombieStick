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
		
		player.attacking = true
		
		player:showSprite("attack")
		player:performedAction("attack")
		
		local levelView = LevelView.instance
		local lc = levelView.levelChildren
		
		local targetX, targetY
		--print("player.lastAttackX: ", player.lastAttackX)
		local localX, localY = levelView:localToContent(player.lastAttackX, player.lastAttackY)
		local variance = 80
		targetX = localX + (lc.x * -1) + (math.random() * variance) - (variance / 2)
		targetY = localY + (lc.y * -1) + (math.random() * variance) - (variance / 2)
		
		if targetX > player.x and player.direction == "left" then
			player:setDirection("right")
		elseif player.direction == "right" and targetX < player.x then
			player:setDirection("left")
		end
		
		if player.selectedWeapon == "gun" then
			local bullet = Freeman9mmBullet:new(player.x + 4, player.y + (player.height / 2), targetX, targetY)
			bullet:addEventListener("onRemoveFromGameLoop", function(e)
																LevelView.instance.gameLoop:removeLoop(bullet)
															end)
			levelView:insertChild(bullet)
			levelView.gameLoop:addLoop(bullet)
			player.fsm:changeStateToAtNextTick("ready")
		elseif player.selectedWeapon == "grapple" then
			player.fsm:changeStateToAtNextTick("grapple")
		end
	end
	
	return state
end

return FreemanAttackState