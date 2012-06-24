require "com.jxl.core.statemachine.StateMachine"
require "com.jxl.zombiestick.constants"

BasePlayer = {}

function BasePlayer:new()
	local player = display.newGroup()
	
	--player.classType = "BasePlayer"

	player.spriteHolder = display.newGroup()
	player:insert(player.spriteHolder)
	
	player.lastAttack = nil
	player.ATTACK_INTERVAL = 300
	player.direction = "right"
	player.jumpGravity = -3
	player.lastJump = nil
	player.jumpStartY = nil
	player.JUMP_INTERVAL = 100
	
	-- ready --
	player.REST_TIME = 2000
	player.INACTIVE_TIME = 3000
	player.startRestTime = nil
	player.elapsedRestTime = nil
	
	-- moving --
	player.startMoveTime = nil
	player.MOVE_STAMINA_TIME = 1000
	player.speed = 3
	player.maxSpeed = 3
	player.grappledSpeed = 0.001
	player.tiredSpeed = 1

	player.moveStamina = 1
	player.stamina = 10
	player.maxStamina = 10
	player.health = 40
	player.maxHealth = 40

	player.injuries = {}
	player.grapplers = {}
	
	function player:init()
		self.fsm = StateMachine:new(self)
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
	
	function player:setDirection(dir)
		self.direction = dir
		assert(self.direction ~= nil, "You cannot set direction to a nil value.")
		local spriteHolder = player.spriteHolder
		if dir == "right" then
			spriteHolder.xScale = 1
			spriteHolder.x = 0
		else
			spriteHolder.xScale = -1
			spriteHolder.x = spriteHolder.width
		end
	end
	
	function player:canAttack()
		if self.attacking == true then return false end
		if self.jumping == true then return false end
		if self.stamina == 0 then return false end
		if self.stamina - self.attackStamina >= 0 then return true end
		return true
	end
	
	function player:onAttackComplete(event)
		self:showSprite("stand")
		self.attacking = false
	end
	
	function player:startMoving()
		if self.moving == false and self.jumping == false then
			self.moving = true
			self.startMoveTime = system.getTimer()
		end
	end
	
	function player:stopMoving()
		self.moving = false
		if self.speed <= 0 then return true end

		local force
		if self.direction == "right" then
			force = self.speed
		else
			force = -self.speed
		end
		self:applyLinearImpulse(force / 3, 0, 40, 32)
		self:dispatchEvent({name="onMoveCompleted", target=self})
	end
	
	function player:canJump()
		local score = 0
		local min = 4
		if self.attacking == false then score = score + 1 end
		if self.moving == false then score = score + 1 end
		if self.jumping == false then score = score + 1 end
		if self.stamina >= self.jumpStamina then score = score + 1 end
		
		if score >= min then
			return true
		else
			return false
		end
	end
	
	function player:performedAction(actionType)
		if actionType == "attack" then
			self:reduceStamina(self.attackStamina)
		elseif actionType == "jump" then
			self:reduceStamina(self.jumpStamina)
		end
		self:dispatchEvent({name="onPerformedAction", target=self, action=actionType})
	end
	
	function player:reduceStamina(amount)
		assert(amount ~= nil, "Error: BasePlayer::reduceStamina, You cannot pass a nil amount.")
		self:setStamina(self.stamina - amount)
		if self.stamina < 0 then
			self:setStamina(0)
			print("Warning, someone is writing checks he can't cash.")
		end
	end
	
	function player:rechargeStamina()
		if self.stamina ~= self.maxStamina then
			self:setStamina(self.stamina + 1)
		end
	end
	
	function player:setStamina(value)
		local oldValue = self.stamina
		self.stamina = value
		self:resolveSpeed()
		local difference = value - oldValue
		self:showStaminaText(25, 0, difference)

		Runtime:dispatchEvent({name="onPlayerStaminaChanged", target=self, maxStamina = self.maxStamina, oldValue=oldValue, value=value})
	end

	function player:resolveSpeed()
		local targetSpeed = self.maxSpeed
		local grapplers = self.grapplers
		print("grapplers lenght: ", #grapplers)
		if #grapplers > 0 then targetSpeed = self.grappledSpeed end
		if self.stamina <= 1 then targetSpeed = self.tiredSpeed end
		self:setSpeed(targetSpeed)
	end

	function player:reduceHealth(amount)
		assert(amount ~= nil, "Error: BasePlayer::reduceHealth, You cannot pass a nil amount.")
		self:setHealth(self.health - amount)
	end

	function player:rechargeHealth()
		local injuries = self.injuries
		if #injuries > 0 then return false end
		
		if self.health ~= self.maxHealth then
			self:setHealth(self.health + 1)
		end
	end

	function player:setHealth(value)
		assert(value ~= nil, "Error: BasePlayer::setHealth, you cannot pass a nil amount.")
		local oldValue = self.health
		self.health = value
		if self.health < 0 then
			self.health = 0
		end
		-- TODO: put uber slow speeds here if hurt AND/OR tired

		local difference = value - oldValue
		self:showHealthText(25, 0, difference)

		Runtime:dispatchEvent({name="onPlayerHealthChanged", target=self, maxHealth = self.maxHealth, oldValue = oldValue, value=value})
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

	function player:showStaminaText(targetX, targetY, amount)
		Runtime:dispatchEvent({name="onShowFloatingText", target=self, x=targetX, y=targetY, textTarget=self, textType=constants.TEXT_TYPE_STAMINA, amount=amount})
	end

	function player:showHealthText(targetX, targetY, amount)
		Runtime:dispatchEvent({name="onShowFloatingText", target=self, x=targetX, y=targetY, textTarget=self, textType=constants.TEXT_TYPE_HELATH, amount=amount})
	end

	-- TODO: 6.21.2012 Need a GUI for Injuries.
	function player:addInjury(injuryVO)
		local injuries = self.injuries
		if table.indexOf(injuries, injuryVO) == nil then
			table.insert(injuries, injuryVO)
			Runtime:dispatchEvent({name="onPlayerInjuriesChanged", target=self, injuries=injuries})
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
		Runtime:dispatchEvent({name="onPlayerInjuriesChanged", target=self, injuries=injuries})
	end

	-- TODO/BUG: 6.21.2012, if 2 Zombies grapple the character, this will make him think he isn't
	-- grappled. We'll have to use an array, similiar to how injuries work. This'll allow us to
	-- compound the grappling. 3 or more and you won't be able to move! Perfect opportunity
	-- for some Tai Kwon Do to do special break moves vs. just simple attacking. For JXL, this
	-- should be the only option since he can't use his machetes in close quarters.

	-- TODO: ok, fixed bug... but the martial arts option is more fun.
	function player:addGrappler(dudeGrabbingMeUpInThisMug)
		-- TODO: need to ensure you can actually be grappled, need to check state. psuedo code below
		local currentState = self.fsm.state
		if currentState == "firehose" and currentState == "grapple" and currentState == "jump" and current == "jumpLeft" and currentState == "jumpRight" then
			error("Illlegal to grapple player when they're in state: ", currentState)
		end

		-- if you're grappled, you're slowed down
		local grapplers = self.grapplers
		if table.indexOf(grapplers, dudeGrabbingMeUpInThisMug) == nil then
			table.insert(grapplers, dudeGrabbingMeUpInThisMug)
			self:resolveSpeed()
			self.fsm:changeStateToAtNextTick("grappleDefense")
			return true
		else
			error("grappler already added to array")
		end
	end

	function player:removeGrappler(grappler)
		local grapplers = self.grapplers
		if grapplers == nil then return false end
		if #grapplers < 1 then return false end
		local index = table.indexOf(grapplers, grappler)
		if index ~= nil then
			table.remove(grapplers, index)
			self:resolveSpeed()
			return true
		else
			error("grappler not found in grapplers array.")
		end
	end

	function player:removeLatestGrapple()
		local grapplers = self.grapplers
		if grapplers == nil then return false end
		if #grapplers < 1 then return false end
		local grappler = grapplers[#grapplers]
		self:removeGrappler(grappler)
		return grappler
	end
	
	return player
end

return BasePlayer