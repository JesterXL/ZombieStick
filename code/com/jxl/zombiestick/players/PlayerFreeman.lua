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

PlayerFreeman = {}

function PlayerFreeman:new(params)

	if PlayerFreeman.sheet == nil then
		local sheet = sprite.newSpriteSheet("player_freeman_sheet.png", 64, 64)
		local standSet = sprite.newSpriteSet(sheet, 1, 6)
		sprite.add(standSet, "PlayerFreemanStand", 1, 6, 1000, 0)
		local moveSet = sprite.newSpriteSet(sheet, 8, 7)
		sprite.add(moveSet, "PlayerFreemanMove", 1, 8, 500, 0)
		local jumpSet = sprite.newSpriteSet(sheet, 15, 6)
		sprite.add(jumpSet, "PlayerJXLJump", 1, 6, 600, 1)
		local attackSet = sprite.newSpriteSet(sheet, 22, 6)
		sprite.add(attackSet, "PlayerFreemanAttack", 1, 5, 300, 1)

		PlayerFreeman.sheet = sheet
		PlayerFreeman.standSet = standSet
		PlayerFreeman.moveSet = moveSet
		PlayerFreeman.jumpSet = jumpSet
		PlayerFreeman.attackSet = attackSet
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
			spriteAnime:addEventListener("sprite", player.onJumpCompleted)
		elseif name == "stand" then
			spriteAnime = sprite.newSprite(PlayerFreeman.standSet)
			spriteAnime:prepare("PlayerFreemanStand")
		elseif name == "attack" then
			spriteAnime = sprite.newSprite(PlayerFreeman.attackSet)
			spriteAnime:prepare("PlayerFreemanAttack")
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
	player.fsm:addState2(JXLAttackState:new())
	player.fsm:setInitialState("ready", player)
	
	
	return player
end

return PlayerFreeman