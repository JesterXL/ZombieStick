require "enemies.states.IdleState"
require "enemies.states.ReadyState"
require "enemies.states.GrabPlayerState"
require "components.AutoSizeText"

Zombie = {}

function Zombie:new()

	local zombie = display.newGroup()
	zombie.classType = "Zombie"
	zombie.speed = 0.01
	zombie.health = 4
	zombie.maxHealth = 4
	zombie.dead = false
	zombie.targets = nil
	zombie.direction = "right"

	function zombie:init()
		self.spriteHolder = display.newGroup()
		self:insert(self.spriteHolder)

		local sheet = graphics.newImageSheet("assets/sheets/enemy_zombie_sheet.png", {width=64, height=64, numFrames=32})
		local sequenceData = 
		{
			{
				name="moveRight",
				start=1,
				count=7,
				time=1000,
			},
			{
				name="moveLeft",
				start=8,
				count=7,
				time=1000,
			}
		}

		local sprite = display.newSprite(sheet, sequenceData)
		self.sprite = sprite
		self.sheet = sheet
		self.sprite = sprite
		self.spriteHolder:insert(self.sprite)
		self:showSprite("moveRight")
		sprite.x = 0
		sprite.y = 0

		physics.addBody(self, "dynamic", 
				{ 
					density=.8, friction=.8, bounce=.2, isBullet=true, shape=self:getBounds()
				}
		)
		self.isFixedRotation = true
		mainGroup:insert(self)

		

		self.fsm = StateMachine:new(zombie)
		self.fsm:addState2(IdleState:new())
		self.fsm:addState2(ReadyState:new())
		-- zombie.fsm:addState2(EatPlayerState:new())
		-- zombie.fsm:addState2(TemporarilyInjuredState:new())
		zombie.fsm:addState2(GrabPlayerState:new())
		-- zombie.fsm:addState2(KnockedProneState:new())
		self.fsm:setInitialState("ready", zombie)

		local stateField = AutoSizeText:new(self)
		self.stateField = stateField
		stateField:setAutoSize(true)
		stateField:setSize(60, 20)
		stateField:setFontSize(11)
		stateField:setTextColor(0, 0, 0)
		stateField.y = -20
		stateField.x = 10

		gameLoop:addLoop(self)
	end

	function zombie:getBounds()
		return {22,4, 42,4, 42,55, 22,55}
	end

	function zombie:showSprite(name)
		local sprite = self.sprite
		if name == "move" then
			self.sprite:setSequence("moveRight")
		end
		sprite:setReferencePoint(display.TopLeftReferencePoint)
		sprite:play()
	end

	function zombie:setDirection(dir)
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

	function zombie:moveTowardTargets(time)
		if self.targets == nil then
			return false
		end

		local targets = self.targets
		if #targets < 1 then
			return false
		end

		local i = 1
		local deltaX
		local deltaY
		local distance
		local dTable = {}
		while targets[i] do
			local target = targets[i]
			local node = {}
			table.insert(dTable, i, node)
			node.target = target
			
			deltaX = self.x - target.x
			deltaY = self.y - target.y
			distance = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
			node.distance = distance
			i = i + 1
		end
		
		table.sort(dTable, function(a,b) return a.distance < b.distance end)
		
		local closest = dTable[1]
		target = closest.target
	 	distance = closest.distance
		local moveX = self.speed * (deltaX / distance) * time
		local moveY = self.speed * (deltaY / distance) * time

		if target.x > self.x and self.direction == "left" then
			self:setDirection("right")
		elseif target.x < self.x and self.direction == "right" then
			self:setDirection("left")
		end

		if (math.abs(moveX) > distance or math.abs(moveY) > distance) then
			self.x = target.x
			--self.y = self.player.y
			
		else
			self.x = self.x - moveX
			--self.y = self.y - moveY
		end
	end

	function zombie:tick(time)
		self.stateField:setText(self.fsm.state)
		self:moveTowardTargets(time)

		-- [jwarden 5.19.2013] TODO: Raycasting is awesome. I don't have time to code this...
		-- local hits = physics.rayCast(self.x, self.y, self.x + 200, self.y, 0)
		-- local hits2 = physics.rayCast(self.x, self.y, self.x + 150, self.y - 50, 0)
		
		-- if self.line then
		-- 	self.line:removeSelf()
		-- end
		-- self.line = display.newLine(self.x, self.y, self.x + 150, self.y - 50)
		-- self.line:setReferencePoint(display.TopLeftReferencePoint)
		-- self.line:setColor(255, 0, 0, 200)
		-- mainGroup:insert(self.line)
		-- self.line.x = self.x
		-- self.line.y = self.y - 50
		-- if hits then
		-- 	local first = hits[1]
		-- end
	end

	function zombie:setHealth(value)
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

		if self.health < 1 then
			self.x = -999
			self.y = -999
			local t = {}
			function t:timer()
				zombie:destroy()
			end
			timer.performWithDelay(100, t)
		end
	end

	function zombie:onHit(damage)
		self:setHealth(self.health - damage)
	end

	function zombie:destroy()
		gameLoop:removeLoop(self)
		self.fsm:destroy()
		self.fsm = nil

		physics.removeBody(self)

		self.sprite:removeSelf()
		self.sprite = nil

		self.sheet = nil

		self.spriteHolder:removeSelf()
		self.spriteHolder = nil

		self:removeSelf()
	end

	zombie:init()

	return zombie

end

return Zombie