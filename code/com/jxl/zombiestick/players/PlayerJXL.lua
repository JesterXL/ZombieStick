require "sprite"
require "com.jxl.zombiestick.constants"

require "com.jxl.zombiestick.states.ReadyState"
require "com.jxl.zombiestick.states.RestingState"
require "com.jxl.zombiestick.states.MovingLeftState"
require "com.jxl.zombiestick.states.MovingRightState"
require "com.jxl.zombiestick.states.JumpState"
require "com.jxl.zombiestick.states.JumpRightState"
require "com.jxl.zombiestick.states.JumpLeftState"
require "com.jxl.zombiestick.states.JXLAttackState"

require "com.jxl.zombiestick.players.BasePlayer"
PlayerJXL = {}

function PlayerJXL:new(params)

	if PlayerJXL.sheet == nil then
		local sheet = sprite.newSpriteSheet("player_jesterxl_sheet.png", 64, 64)
		local standSet = sprite.newSpriteSet(sheet, 1, 6)
		sprite.add(standSet, "PlayerJXLStand", 1, 6, 1000, 0)
		local moveSet = sprite.newSpriteSet(sheet, 9, 8)
		sprite.add(moveSet, "PlayerJXLMove", 1, 8, 500, 0)
		local jumpSet = sprite.newSpriteSet(sheet, 17, 6)
		sprite.add(jumpSet, "PlayerJXLJump", 1, 6, 600, 1)
		local attackSet = sprite.newSpriteSet(sheet, 25, 6)
		sprite.add(attackSet, "PlayerJXLAttack", 1, 6, 300, 1)
		
		PlayerJXL.sheet = sheet
		PlayerJXL.standSet = standSet
		PlayerJXL.moveSet = moveSet
		PlayerJXL.jumpSet = jumpSet
		PlayerJXL.attackSet = attackSet
	end
	
	local player = BasePlayer:new()
	player.name = "JXL"
	player.classType = "PlayerJXL"
	player.sprite = nil
	
	player.jumpForce = constants.JUMP_FORCE
	player.jumpForwardForce = constants.JUMP_FORWARD_FORCE
	
	player.stamina = 10
	player.maxStamina = 10
	player.attackStamina = 1
	player.jumpStamina = 2
	
	
	function player:getBounds()
		return {22,4, 42,4, 42,55, 22,55}
	end
	
	function player:showSprite(name)
		local spriteAnime
		if name == "move" then
			spriteAnime = sprite.newSprite(PlayerJXL.moveSet)
			spriteAnime:prepare("PlayerJXLMove")
		elseif name == "jump" then
			spriteAnime = sprite.newSprite(PlayerJXL.jumpSet)
			spriteAnime:prepare("PlayerJXLJump")
			--spriteAnime:addEventListener("sprite", player.onJumpCompleted)
			spriteAnime:addEventListener("sprite", function(event) 
														if event.phase == "end" then
															player:dispatchEvent({name = "onJumpCompleted",
																					target = player})
														end
													end
										)
		elseif name == "stand" then
			spriteAnime = sprite.newSprite(PlayerJXL.standSet)
			spriteAnime:prepare("PlayerJXLStand")
		elseif name == "attack" then
			spriteAnime = sprite.newSprite(PlayerJXL.attackSet)
			spriteAnime:prepare("PlayerJXLAttack")
			spriteAnime:addEventListener("sprite", function(event) 
														if event.phase == "end" then
															player:dispatchEvent({name = "onAttackAnimationCompleted",
																					target = player})
														end
													end
										)
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
	player.y = params.y
	
	local playerShape = player:getBounds()
	assert(physics.addBody( player, "dynamic", 
		{ density=params.density, friction=params.friction, bounce=params.bounce, isBullet=true, 
			shape=playerShape,
			filter = { categoryBits = constants.COLLISION_FILTER_PLAYER_CATEGORY, 
			maskBits = constants.COLLISION_FILTER_PLAYER_MASK }} ), 
			"PlayerJXL failed to add to physics.")
			
	player.isFixedRotation = true
	
	--player.fsm:changeState(ReadyState:new(player))
	
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

return PlayerJXL