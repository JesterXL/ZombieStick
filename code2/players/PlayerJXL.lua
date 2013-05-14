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
	player.speed = 3
	player.maxSpeed = 10
	player.climbSpeed = 1.4
	player.fsm = nil
	player.lastJump = nil
	player.JUMP_INTERVAL = 1000
	player.climbDirection = nil -- up or down, set by ReadyState
	player.lastLadder = nil
	player.lastLedge = nil
	player.ledgeClimbSpeed = 0.2
	player.health = 1000
	player.maxHealth = 1000
	player.injuries = {}

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

		gameLoop:addLoop(self)
	end

	function player:tick(time)
		local injuries = self.injuries
		if injuries and #injuries > 0 then
			local i = 1
			while injuries[i] do
				local vo = injuries[i]
				local destroyIt = false
				vo.currentTime = vo.currentTime + time
				vo.totalTimeAlive = vo.totalTimeAlive + time
				if vo.currentTime >= vo.applyInterval then
					if vo.livesForever == false and vo.totalTimeAlive >= vo.lifetime then
						destroyIt = true
					end

					-- time's up, time to apply the injury
					vo.currentTime = 0
					-- for now we use a switch statement
					local injuryType = vo.injuryType
					if injuryType == constants.INJURY_BITE then
						self:setHealth(self.health + vo.amount)
					elseif injuryType == constants.INJURY_LACERATION then
						self:setHealth(self.health + vo.amount)
					end
				end
				if destroyIt == true then
					table.remove(injuries, table.indexOf(vo))
				else
					i = i + 1
				end
			end
		end

		if self.fsm ~= nil then
			self.fsm:tick(time)
		end
		return true
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
		floatingText:text({x=0, y=-32, amount=difference, textTarget=self, textType=constants.TEXT_TYPE_HEALTH})
	end

	-- TODO: 6.21.2012 Need a GUI for Injuries.
	function player:addInjury(injuryVO)
		local injuries = self.injuries
		if table.indexOf(injuries, injuryVO) == nil then
			table.insert(injuries, injuryVO)
			-- Runtime:dispatchEvent({name="onPlayerInjuriesChanged", target=self, injuries=injuries})
			return true
		else
			error("injuryVO already added to array")
		end
	end

	function player:hasInjury(injuryType)
		assert(injuryType ~= nil, "You cannot pass a nil injuryType.")
		local injuries = self.injuries
		if injuries == nil then return false end
		if #injuries < 1 then return false end

		local i = 1
		while injuries[i] do
			local vo = injuries[i]
			if vo.type == injuryType then return true end
			i = i + 1
		end
	end

	function player:removeLatestInjury()
		local injuries = self.injuries
		if injuries == nil then return false end
		if #injuries < 1 then return false end

		table.remove(injuries, #injuries)
		-- Runtime:dispatchEvent({name="onPlayerInjuriesChanged", target=self, injuries=injuries})
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