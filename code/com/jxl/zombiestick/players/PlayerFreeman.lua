require "sprite"
require "com.jxl.zombiestick.players.BasePlayer"

require "com.jxl.zombiestick.states.ReadyState"
require "com.jxl.zombiestick.states.RestingState"
require "com.jxl.zombiestick.states.MovingLeftState"
require "com.jxl.zombiestick.states.MovingRightState"
require "com.jxl.zombiestick.states.JumpState"
require "com.jxl.zombiestick.states.JumpRightState"
require "com.jxl.zombiestick.states.JumpLeftState"
require "com.jxl.zombiestick.states.FreemanAttackState"
require "com.jxl.zombiestick.states.GrappleState"
require "com.jxl.zombiestick.states.ReloadState"

PlayerFreeman = {}

function PlayerFreeman:new(params)

	if PlayerFreeman.sheet == nil then
		local sheet = sprite.newSpriteSheet("player_freeman_sheet.png", 64, 64)
		local standSet = sprite.newSpriteSet(sheet, 1, 6)
		sprite.add(standSet, "PlayerFreemanStand", 1, 6, 1000, 0)
		local moveSet = sprite.newSpriteSet(sheet, 8, 7)
		sprite.add(moveSet, "PlayerFreemanMove", 1, 8, 500, 0)
		local jumpSet = sprite.newSpriteSet(sheet, 15, 6)
		sprite.add(jumpSet, "PlayerFreemanJump", 1, 6, 600, 1)
		local attackSet = sprite.newSpriteSet(sheet, 22, 6)
		sprite.add(attackSet, "PlayerFreemanAttack", 1, 5, 300, 1)
		local climbSet = sprite.newSpriteSet(sheet, 29, 4)
		sprite.add(climbSet, "PlayerFreemanClimb", 1, 4, 500, 0)

		PlayerFreeman.sheet = sheet
		PlayerFreeman.standSet = standSet
		PlayerFreeman.moveSet = moveSet
		PlayerFreeman.jumpSet = jumpSet
		PlayerFreeman.attackSet = attackSet
		PlayerFreeman.climbSet = climbSet
	end
	
	local player = BasePlayer:new()
	player.name = "Freeman"
	player.classType = "PlayerFreeman"
	player.sprite = nil
	player.moving = false
	player.jumping = false
	player.attacking = false
	player.attackingTimer = nil
	player.moveForce = 10
	player:setSpeed(2)
	player.maxSpeed = 2
	player.tiredSpeed = 1
	player.jumpForce = constants.JUMP_FORCE
	player.jumpForwardForce = constants.JUMP_FORWARD_FORCE
	player.stamina = 10
	player.maxStamina = 10
	player.attackStamina = 1
	player.jumpStamina = 2
	player.moveStamina = 1
	player.startMoveTime = nil
	player.MOVE_STAMINA_TIME = 1000
	player.ATTACK_INTERVAL = 500
	player.selectedWeapon = "gun" -- gun or grapple
	player.gunAmmo = 10
	player.MAX_GUN_AMMO = 10
	
	function player:getBounds()
		return {22,4, 42,4, 42,55, 22,55}
	end
	
	function player:showSprite(name)
		local spriteAnime
		if name == "move" then
			spriteAnime = sprite.newSprite(PlayerFreeman.moveSet)
			spriteAnime:prepare("PlayerFreemanMove")
		elseif name == "jump" then
			spriteAnime = sprite.newSprite(PlayerFreeman.jumpSet)
			spriteAnime:prepare("PlayerFreemanJump")
			--spriteAnime:addEventListener("sprite", player.onJumpCompleted)
			spriteAnime:addEventListener("sprite", function(event) 
														if event.phase == "end" then
															player:dispatchEvent({name = "onJumpCompleted",
																					target = player})
														end
													end
										)
		elseif name == "stand" then
			spriteAnime = sprite.newSprite(PlayerFreeman.standSet)
			spriteAnime:prepare("PlayerFreemanStand")
		elseif name == "attack" then
			spriteAnime = sprite.newSprite(PlayerFreeman.attackSet)
			spriteAnime:prepare("PlayerFreemanAttack")
		elseif name == "climb" then
			spriteAnime = sprite.newSprite(PlayerFreeman.climbSet)
			spriteAnime:prepare("PlayerFreemanClimb")
		else
			assert("Unknown sprite name: ", name)
			return false
		end
		spriteAnime:setReferencePoint(display.TopLeftReferencePoint)
		spriteAnime:play()
		if player.sprite ~= nil then
			player.sprite:removeSelf()
		end
		player.sprite = spriteAnime
		player.spriteHolder:insert(spriteAnime)
		spriteAnime.x = 0
		spriteAnime.y = 0
		self:updateSpriteToSpeed()
	end
	
	function player:setSelectedWeapon(weapon)
		if weapon == "gun" or weapon == "grapple" then
			self.selectedWeapon = weapon
			Runtime:dispatchEvent({name="onFreemanSelectedWeaponChanged", target=self})
		else
			asesrt("Unknown weapon.")
		end
	end
	
	function player:onGunButtonTouch(event)
		self:setSelectedWeapon("gun")
	end
	
	function player:onGrappleButtonTouch(event)
		print("PlayerFreeman::onGrappleButtonTouch")
		self:setSelectedWeapon("grapple")
	end
	
	function player:canShoot()
		if self.gunAmmo > 0 then return true end
		return false
	end
	
	function player:canReload()
		if self.gunAmmo < self.MAX_GUN_AMMO then return true end
		return false
	end
	
	function player:setGunAmmo(value)
		print("PlayerFreeman::setGunAmmo, value: ", value)
		assert(value ~= nil, "You cannot set gunAmmo to a nil value.")
		assert(type(value) == "number", "You must set gunmmo to a number.")
		
		if value < 0 then
			error("You cannot have negative gunAmmo.")
		end
		
		if value > self.MAX_GUN_AMMO then
			error("You cannot set gunAmmo larger than MAX_GUN_AMMO.")
		end
		
		self.gunAmmo = value
		
		Runtime:dispatchEvent({name="onPlayerGunAmmoChanged", target=self, amount=self.gunAmmo, max=self.MAX_GUN_AMMO})
	end
	
	player:showSprite("stand")
	
	player.x = params.x
	params.y = params.y
	
	-- 22, 4, 20, 48
	local playerShape = {22,4, 42,4, 42,52, 22,52}
	assert(physics.addBody( player, "dynamic", 
		{ density=params.density, friction=params.friction, bounce=params.bounce, isBullet=true, shape=playerShape,
			filter = { categoryBits = constants.COLLISION_FILTER_PLAYER_CATEGORY, 
			maskBits = constants.COLLISION_FILTER_PLAYER_MASK }} ), 
			"PlayerFreeman failed to add to physics.")
			
	player.isFixedRotation = true
	
	player.fsm:addState2(ReadyState:new())
	player.fsm:addState2(RestingState:new())
	player.fsm:addState2(MovingLeftState:new())
	player.fsm:addState2(MovingRightState:new())
	player.fsm:addState2(JumpState:new())
	player.fsm:addState2(JumpRightState:new())
	player.fsm:addState2(JumpLeftState:new())
	player.fsm:addState2(FreemanAttackState:new())
	player.fsm:addState2(GrappleState:new())
	player.fsm:addState2(ReloadState:new())
	player.fsm:addState2(IdleState:new())
	player.fsm:setInitialState("idle")
	
	Runtime:addEventListener("onGunButtonTouch", player)
	Runtime:addEventListener("onGrappleButtonTouch", player)
	
	
	return player
end

return PlayerFreeman