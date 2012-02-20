Elevator = {}

function Elevator:new(x, y, height)

	local elevator = display.newGroup()
	elevator.x = x
	elevator.y = y
	elevator.lastTick = nil
	elevator.moving = false
	elevator.direction = nil
	elevator.startLength = nil
	local globalAlpha = 100
	local startHeight = height
	
	function elevator:getWall(x, y, width, height)
		local wall = display.newRect( x, y, width, height)
		wall:setFillColor( 255, 0, 0, globalAlpha)
		self:insert(wall)
		physics.addBody(wall, "static", { friction=0.5, bounce=0.0, density=2 } )
		return wall
	end

	function elevator:getBox(x, y)
		local rect = display.newRect(x, y, 100, 100)
		rect:setReferencePoint(display.TopLeftReferencePoint)
		rect:setFillColor( 0, 255, 0, globalAlpha)
		self:insert(rect)
		
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

		physics.addBody(rect, { friction=0.5, bounce=0.1, density=1.2, shape=shape1 },
								{ friction=0.5, bounce=0.1, density=1.2, shape=shape3 })
								
		--rect.isFixedRotation = true
		return rect
	end

	function elevator:getElevatorCounterWeight(x, y, width, height)
		local rect = display.newRect(x, y, width, height)
		--rect:setReferencePoint(display.TopLeftReferencePoint)
		rect:setFillColor( 0, 255, 0, globalAlpha)
		self:insert(rect)
		physics.addBody(rect, "static", { friction=0.5, bounce=.2, density=1.2 } )
		return rect
	end
	
	function elevator:redrawLine(startX, startY, endX, endY)
		if self.line then 
			self.line:removeSelf()
		end
		self.line = display.newLine(startX, startY, endX, endY)
		self.line:setReferencePoint(display.TopLeftReferencePoint)
		self.line.width = 2
		self.line:setColor(255, 255, 255)
		self:insert(self.line)
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
			self:redrawLine(pulleyConnector.x, pulleyConnector.y + 10, box.x + (box.width / 2), box.y + 10)
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
		
		self:redrawLine(pulleyConnector.x, pulleyConnector.y + 10, box.x + (box.width / 2), box.y + 10)
	end

	function elevator:initialize()
		self.pulleyConnector = self:getWall(self.x + 60, self.y, 20, 20)
		
		self.box = self:getBox(0, startHeight - 100, 100, 100)

		self.pulleyJoint = physics.newJoint( "distance", self.box, self.pulleyConnector, self.box.x + (self.box.width / 2), self.box.y, self.pulleyConnector.x, self.pulleyConnector.y + 10 )
		self.pulleyJoint.frequency = 1
		self.pulleyJoint.dampingRatio = .5
		self.startLength = self.pulleyJoint.length
	end
	
	elevator:initialize()
	
	return elevator
	
end

return Elevator