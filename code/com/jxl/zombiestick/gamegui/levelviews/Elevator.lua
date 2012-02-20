Elevator = {}

function Elevator:new(startX, startY, startHeight, proxyGroup)

	local elevator = display.newGroup()
	elevator.lastTick = nil
	elevator.moving = false
	elevator.direction = nil
	elevator.startLength = nil
	local globalAlpha = 100
	
	function elevator:getWall(wallX, wallY, wallWidth, wallHeight)
		local wall = display.newRect(0, 0, wallWidth, wallHeight)
		wall:setReferencePoint(display.TopLeftReferencePoint)
		proxyGroup:insert(wall)
		wall.x = wallX
		wall.y = wallY
		wall:setFillColor( 255, 0, 0, globalAlpha)
		
		physics.addBody(wall, "static", { friction=0.5, bounce=0.0, density=2 } )
		return wall
	end

	function elevator:getBox(boxX, boxY)
		local rect = display.newRect(0, 0, 100, 100)
		rect:setReferencePoint(display.TopLeftReferencePoint)
		proxyGroup:insert(rect)
		rect.x = boxX
		rect.y = boxY
		rect:setFillColor( 0, 255, 0, globalAlpha)
		
		local shape1 = {0,0, 100,0, 100,20, 0,20, 0,0}
		local shape2 = {0,0, 20,0, 20,100, 0,100, 0,0}
		local shape3 = {0,80, 100,80, 100,100, 0,100, 0,80}
		local i
		local max = 10
		local adjustment = 50

		i = 1
		while shape1[i] do
			local value = shape1[i]
			value = value - adjustment
			shape1[i] = value
			i = i + 1
		end

		i = 1
		while shape2[i] do
			local value = shape2[i]
			value = value - adjustment
			shape2[i] = value
			i = i + 1
		end

		i = 1
		while shape3[i] do
			local value = shape3[i]
			value = value - adjustment
			shape3[i] = value
			i = i + 1
		end
		
		

		physics.addBody(rect, {friction=0.5, bounce=0.1, density=1.2, shape=shape3, 
								filter = { categoryBits = constants.COLLISION_FILTER_GROUND_CATEGORY,
		 									maskBits = constants.COLLISION_FILTER_GROUND_MASK
										 }
							  })
		rect.isBullet = true
								
		--rect.isFixedRotation = true
		
		rect:addEventListener("collision", self)
		
		return rect
	end
	
	function elevator:redrawLine(startX, startY, endX, endY)
		if self.line then 
			self.line:removeSelf()
		end
		self.line = display.newLine(startX, startY, endX, endY)
		self.line:setReferencePoint(display.TopLeftReferencePoint)
		proxyGroup:insert(self.line)
		self.line.width = 2
		self.line:setColor(255, 0, 0)
	end

	function elevator:goUp()
		self.moving = true
		self.direction = "up"
	end
	
	function elevator:goDown()
		self.moving = true
		self.direction = "down"	
	end
	
	function elevator:stopMoving()
		self.moving = false
	end
	
	function elevator:startMoving()
		self.moving = true
	end
	
	function elevator:onUpComplete()
		self.moving = false
		self.direction = nil
		self:dispatchEvent({name="onUpComplete", target=self})
	end
	
	function elevator:onDownComplete()
		self.moving = false
		self.direction = nil
		self:dispatchEvent({name="onDownComplete", target=self})
	end
	
	function elevator:tick(millisecondsPassed)
		local pulleyConnector = self.pulleyConnector
		local box = self.box
		if self.moving == false then
			self:redrawLine(pulleyConnector.x + (pulleyConnector.width / 2), pulleyConnector.y + 10, box.x + (box.width / 2), box.y + 10)
			return true
		end
		
		local pixelsPerSecond = 30
		local pixelsPerMillisecond = pixelsPerSecond / 1000
		local yAmount = pixelsPerMillisecond * millisecondsPassed
		local direction = self.direction
		if direction == "up" then
			yAmount = -(math.abs(yAmount))
		elseif direction == "down" then
			yAmount = math.abs(yAmount)
		else
			error("Unknown direction")
			return false
		end
		
		
		
		local pulleyJoint = self.pulleyJoint
		if direction == "up" then
			if pulleyJoint.length > 50 then
				pulleyJoint.length = pulleyJoint.length + yAmount
			else
				self:onUpComplete()
			end
		elseif direction == "down" then
			if pulleyJoint.length < self.startLength then
				pulleyJoint.length = pulleyJoint.length + yAmount
			else
				self:onDownComplete()
			end
		end
		
		self:redrawLine(pulleyConnector.x + (pulleyConnector.width / 2), pulleyConnector.y + 10, box.x + (box.width / 2), box.y + 10)
	end

	function elevator:initialize()
		local pulleyConnector = self:getWall(startX + 40, startY, 20, 20)
		self.pulleyConnector = pulleyConnector
		
		local box = self:getBox(startX, startY + startHeight - 100)
		self.box = box

		local pulleyJoint = physics.newJoint( "distance", box, pulleyConnector, box.x + (box.width / 2), box.y, pulleyConnector.x + (pulleyConnector.width / 2), pulleyConnector.y + 10 )
		self.pulleyJoint = pulleyJoint
		pulleyJoint.frequency = 1
		pulleyJoint.dampingRatio = .5
		self.startLength = pulleyJoint.length
		
		--local background = display.newRect(0, 0, self.width, self.height)
		--self.background = background
		--background:setFillColor(0, 255, 0, 100)
		--self:insert(background)
	end
	
	function elevator:collision(event)
		Runtime:dispatchEvent({name="onElevatorCollision", target=self, phase=event.phase})
	end
	
	elevator:initialize()
	
	return elevator
	
end

return Elevator