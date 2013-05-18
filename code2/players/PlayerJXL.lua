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
require "players.states.RestState"

PlayerJXL = {}

function PlayerJXL:new()

	local player = display.newGroup()
	player.classType = "PlayerJXL"
	player.spriteHolder = nil
	player.sheet = nil
	player.sprite = nil
	player.speed = 3
	player.maxSpeed = 3
	player.grappledSpeed = 0.001
	player.tiredSpeed = 1
	player.climbSpeed = 1.4
	player.fsm = nil
	player.lastJump = nil
	player.JUMP_INTERVAL = 1000
	player.climbDirection = nil -- up or down, set by ReadyState
	player.lastLadder = nil
	player.lastLedge = nil
	player.ledgeClimbSpeed = 0.2
	player.health = 10
	player.maxHealth = 10
	player.stamina = 10
	player.maxStamina = 10
	player.injuries = nil
	player.startMoveTime = nil
	player.MOVE_STAMINA_TIME = 500
	player.moveStamina = 1
	player.REST_TIME = 2000
	player.INACTIVE_TIME = 3000
	player.startRestTime = nil
	player.elapsedRestTime = nil
	player.oldRestTime = nil

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
		self.sheet = sheet
		self.sprite = sprite
		self.spriteHolder:insert(self.sprite)
		self:showSprite("stand")
		sprite.y = -24

		mainGroup:insert(self)

		-- regular physics
		physics.addBody(self, "dynamic", {density=0.3, friction=0.8, bounce=0.2,})
											--shape={0,0, 20,0, 20,40, 0,40}})
		self.isFixedRotation = true

		local fsm = StateMachine:new(self)
		self.fsm = fsm
		fsm:addState2(IdleState:new())
		fsm:addState2(RestState:new())
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

		-- gameLoop:addLoop(self)

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	-- function player:tick(time)
	-- 	-- if self.fsm ~= nil then
	-- 	-- 	self.fsm:tick(time)
	-- 	-- end
	-- 	return true
	-- end

	function player:showSprite(name)
		local sprite = self.sprite
		if name == "move" then
			sprite:setSequence("move")
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
			-- spriteHolder.x = spriteHolder.width
		end
	end

	function player:setHealth(value)
		print("PlayerJXL::setHealth, value:", value)
		assert(value ~= nil, "value cannot be nil.")
		local oldValue = self.health
		self.health = value
		if self.health < 0 then
			self.health = 0
		end

		local difference = self.health - oldValue
		if difference ~= 0 then
			floatingText:text({x=0, y=-32, amount=difference, textTarget=self, textType=constants.TEXT_TYPE_HEALTH})
		end
	end

	function player:rechargeHealth()
		if self.health ~= self.maxHealth then
			self:setHealth(self.health + 1)
		end
	end

	function player:setStamina(value)
		print("PlayerJXL::setStamina, value:", value)
		assert(value ~= nil, "value cannot be nil.")
		local oldValue = self.stamina
		self.stamina = value
		if self.stamina < 0 then
			self.stamina = 0
		end

		local difference = self.stamina - oldValue
		if difference ~= 0 then
			floatingText:text({x=0, y=-32, amount=difference, textTarget=self, textType=constants.TEXT_TYPE_STAMINA})
		end

		self:resolveSpeed()
	end

	function player:rechargeStamina()
		if self.stamina ~= self.maxStamina then
			self:setStamina(self.stamina + 1)
		end
	end

	function player:setSpeed(value)
		assert(value ~= nil, "You cannot set speed to a nil value.")
		self.speed = value
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

	function player:resolveSpeed()
		local targetSpeed = self.maxSpeed
		-- local grapplers = self.grapplers
		-- if #grapplers > 0 then targetSpeed = self.grappledSpeed end
		if self.stamina <= 1 then targetSpeed = self.tiredSpeed end
		self:setSpeed(targetSpeed)
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