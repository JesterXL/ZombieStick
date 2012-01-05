require "sprite"
require "com.jxl.zombiestick.constants"
require "com.jxl.zombiestick.states.ReadyState"
require "com.jxl.zombiestick.states.RestingState"
require "com.jxl.zombiestick.states.MovingState"
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
														player:dispatchEvent({name = "onJumpCompleted",
																				target = player})
													end
										)
		elseif name == "stand" then
			spriteAnime = sprite.newSprite(PlayerJXL.standSet)
			spriteAnime:prepare("PlayerJXLStand")
		elseif name == "attack" then
			spriteAnime = sprite.newSprite(PlayerJXL.attackSet)
			spriteAnime:prepare("PlayerJXLAttack")
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
	
	function player:onTouch(event)
		print("PlayerJXL::onTouch, phase: ", event.phase)
		local target = event.target
		
		if event.phase == "began" then
			if target.name == "jump" then
				--player:jump()
				self.fsm:changeState("jump", self)
				return true
			elseif target.name == "jumpForward" then
				--player:jumpForward()
				return true
			elseif target.name == "right" then
				--player:moveRight()
				self.fsm:changeState("moving", self, "right")
				return true
			elseif target.name == "left" then
				--player:moveLeft()
				self.fsm:changeState("moving", self, "left")
				return true
			end
		elseif event.phase == "ended" then
			if target.name == "strike" then
				--state:attack()
				return true
			elseif target.name == "right" then
				--player:stand()
				self.fsm:changeState("ready", self)
				return true
			elseif target.name == "left" then
				--player:stand()
				self.fsm:changeState("ready", self)
				return true
			end
		end
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
	player.fsm:addState2(MovingState:new())
	player.fsm:setInitialState("ready", player)
	
	return player
end

return PlayerJXL