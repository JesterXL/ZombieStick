require "utils.StateMachine"
require "players.states.IdleState"
require "players.states.ReadyState"
require "players.states.MovingLeftState"
require "players.states.MovingRightState"
require "players.states.JumpState"
require "players.states.JumpLeftState"
require "players.states.JumpRightState"
require "players.states.ClimbLadderState"
require "players.states.ClimbLedgeState"

PlayerJXL = {}

function PlayerJXL:new()

	local player = display.newGroup()
	player.classType = "PlayerJXL"
	player.spriteHolder = nil
	player.sheet = nil
	player.sprite = nil
	player.speed = 10
	player.maxSpeed = 10
	player.climbSpeed = 0.2
	player.fsm = nil
	player.lastJump = nil
	player.JUMP_INTERVAL = 1000
	player.climbDirection = nil -- up or down, set by ReadyState
	player.lastLadder = nil
	player.lastLedge = nil

	function player:init()
		self.spriteHolder = display.newGroup()
		self:insert(self.spriteHolder)

		local sheet = graphics.newImageSheet("assets/sheets/player_jesterxl_sheet.png", {width=64, height=64, numFrames=32})
		local sequenceData = 
		{
			{
				name="stand",
				start=1,
				count=6,
				time=1600,
				loopDirection="bounce"
			},
			{
				name="move",
				start=9,
				count=8,
				time=500,
			},
			{
				name="jump",
				start=17,
				count=6,
				time=600,
				loopCount=1,
			},
			{
				name="attack",
				start=25,
				count=6,
				time=300,
				loopCount=1,
			}
		}

		local sprite = display.newSprite(sheet, sequenceData)
		self.sprite = sprite
		sprite:setSequence("stand")
		sprite:play()
		self.sheet = sheet
		self.sprite = sprite
		self.spriteHolder:insert(self.sprite)
		sprite.x = 11
		sprite.y = 8

		mainGroup:insert(self)

		-- regular physics
		physics.addBody(self, "dynamic", {density=0.3, friction=0.8, bounce=0.2,})
											--shape={0,0, 20,0, 20,40, 0,40}})
		self.isFixedRotation = true

		local fsm = StateMachine:new(self)
		fsm:addState2(IdleState:new())
		fsm:addState2(ReadyState:new())
		fsm:addState2(MovingLeftState:new())
		fsm:addState2(MovingRightState:new())
		fsm:addState2(JumpState:new())
		fsm:addState2(JumpLeftState:new())
		fsm:addState2(JumpRightState:new())
		fsm:addState2(ClimbLadderState:new())
		fsm:addState2(ClimbLedgeState:new())
		fsm:setInitialState("ready")

		Runtime:addEventListener("onPlayerLadderCollisionBegan", self)
		Runtime:addEventListener("onPlayerLadderCollisionEnded", self)
		Runtime:addEventListener("onLedgeCollideBegan", self)
		Runtime:addEventListener("onLedgeCollideEnded", self)

		--gameLoop:addLoop(self)
	end

	function player:showSprite(name)
		local sprite = self.sprite
		if name == "move" then
			sprite:setSequence("stand")
		elseif name == "jump" then
			sprite:setSequence("jump")
			-- spriteAnime:addEventListener("sprite", function(event) 
			-- 											if event.phase == "end" then
			-- 												player:dispatchEvent({name = "onJumpCompleted",
			-- 																		target = player})
			-- 											end
			-- 										end
			-- 							)
		elseif name == "stand" then
			sprite:setSequence("stand")
		elseif name == "attack" then
			sprite:setSequence("attack")
			-- spriteAnime:addEventListener("sprite", function(event) 
			-- 											if event.phase == "end" then
			-- 												player:dispatchEvent({name = "onAttackAnimationCompleted",
			-- 																		target = player})
			-- 											end
			-- 										end
			-- 							)
		elseif name == "hang" then
			-- spriteAnime = sprite.newSprite(PlayerJXL.hangSet)
			-- spriteAnime:prepare("PlayerJXLHang")
		else
			print("ERROR: Unknown sprite sequence:", name)
			return false
		end

		sprite:setReferencePoint(display.TopLeftReferencePoint)
		sprite:play()
		sprite.x = 0
		sprite.y = 0
		self:updateSpriteToSpeed()
	end

	function player:updateSpriteToSpeed()
		local speed = self.speed
		local sprite = self.sprite
		if sprite then
			if speed == player.maxSpeed then
				sprite.timeScale = 1
			elseif speed == player.tiredSpeed then
				sprite.timeScale = 0.3
			elseif speed == player.grappledSpeed then
				sprite.timeScale = 0.5
			end
		end
	end

	function player:setDirection(dir)
		self.direction = dir
		assert(self.direction ~= nil, "You cannot set direction to a nil value.")
		local spriteHolder = self.spriteHolder
		if dir == "right" then
			spriteHolder.xScale = 1
			spriteHolder.x = 0
		else
			spriteHolder.xScale = -1
			spriteHolder.x = spriteHolder.width
		end
	end

	function player:onPlayerLadderCollisionBegan(event)
		print("PlayerJXL::onPlayerLadderCollisionBegan")
		self.lastLadder = event.target
	end

	function player:onPlayerLadderCollisionEnded(event)
		print("PlayerJXL::onPlayerLadderCollisionEnded")
		--self.lastLadder = nil
	end

	function player:onLedgeCollideBegan(event)
		self.lastLedge = event.target
	end

	function player:onLedgeCollideEnded(event)
		self.lastLedge = nil
	end

	player:init()

	return player

end


return PlayerJXL