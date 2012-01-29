require "com.jxl.core.statemachine.BaseState"
FirehoseState = {}

function FirehoseState:new()
	local state = BaseState:new("firehose")
	state.apex = false
	
	function state:onEnterState(event)
		print("FirehoseState::onEnterState")
		
		local player = self.entity
		self.player = player
		player:showSprite("hang")
		--player.isFixedRotation = false
		player.jumpGravity = -4
		player.jumpStartY = player.y
		player.lastJump = system.getTimer()
		player.apex = false
		player.angularVelocity = 0
		player:setLinearVelocity(0, 0)
		--player.x = firehose.x - player.width
		--player.y = firehose.y - (player.height + 1)
		
		player:applyLinearImpulse(-8, -6, player.width / 2, player.height / 2)
		
		Runtime:addEventListener("onGenericSensorCollision", self)
	end
	
	function state:onExitState(event)
		print("FirehoseState::onEnterState")
		
		if self.distanceJoint then
			self.distanceJoint:removeSelf()
		end
		self.entity.lastFirehoseTarget = nil
		
		Runtime:removeEventListener("onGenericSensorCollision", self)
		
		
		local firehoseLinks = self.firehoseLinks
		local firehoseJoints = self.firehoseJoints
		if firehoseLinks then
			local len = #firehoseLinks
			while len > 0 do
				local link = firehoseLinks[len]
				local joint = firehoseJoints[len]
				print("joint: ", joint, ", len: ", len)
				joint:removeSelf()
				link:removeSelf()
				len = len - 1
			end
		end
	end
	
	function state:tick(time)
		local player = self.entity
		if self.apex == false then
			if self.lastY ~= nil then
				local currentY = player.y
				local diff = currentY - self.lastY
				if diff >= 0.5 then
					self.apex = true
					self:deployHoseJoint()
					return true
				end
				self.lastY = currentY
			else
				self.lastY = player.y
			end
		end
	end
	
	function state:deployHoseJoint()
		local player = self.entity
		local firehose = player.lastFirehoseTarget
		player.isFixedRotation = false
		local firehoseLinks = {}
		local firehoseJoints = {}
		self.firehoseLinks = firehoseLinks
		self.firehoseJoints = firehoseJoints
		local startX = firehose.x
		local startY = firehose.y
		local j
		local lastLink
		
		local MAX_LINKS = 25
		local deltaX = player.x - firehose.x
		local deltaY = player.y - firehose.y
		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
		local xAmount = deltaX / MAX_LINKS
		local yAmount = deltaY / MAX_LINKS
		local levelView = LevelView.instance
		for j = 1,MAX_LINKS do
			local link = display.newImage("firehose-link.png")
			firehoseLinks[j] = link
			link.x = startX
			link.y = startY
			levelView:insertChild(link)
			
			physics.addBody(link, { density=.8, friction=.3, bounce=0 } )
			
			if (j > 1) then
				prevLink = firehoseLinks[j-1]
			else
				prevLink = firehose
			end
			
			local jointIndex = #firehoseJoints + 1
			firehoseJoints[jointIndex] = physics.newJoint("pivot", prevLink, link, startX, startY)
			
			startY = startY + link.height
			
			lastLink = link
		end
		
		lastLink.x = player.x
		lastLink.y = player.y
		
		local distanceJoint = physics.newJoint("pivot", lastLink, player, player.x + 30, player.y + 10)
		distanceJoint.frequency = 0
		distanceJoint.dampingRatio = 0.5
		distanceJoint.length = 3
		self.distanceJoint = distanceJoint
		
	end
	
	function state:onGenericSensorCollision(event)
		local player = self.entity
		if event.other == player then
			player.fsm:changeStateToAtNextTick("ready")
		end
	end
	
	
	return state
end

return FirehoseState