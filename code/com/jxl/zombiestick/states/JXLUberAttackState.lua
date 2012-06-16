require "com.jxl.core.statemachine.BaseState"

JXLUberAttackState = {}

function JXLUberAttackState:new()

	local state = BaseState:new("attack")
	state.startTime = nil
	
	function state:onEnterState(event)
		local player = self.entity
		
		Runtime:addEventListener("touch", state)
	end
	
	
	function state:onExitState(event)
		local player = self.entity
	end
	
	function state:touch(event)
		if event.phase == "began" then
			self.startTime = system.getTimer()
		elseif event.phase == "ended" then
			self:onEndSwipe(event)
		end
	end
	
	function state:getAngle(startX, startY, endX, endY)
		local angle = math.atan2(startY - endY, startX - endX)
		angle = math.deg(angle)
		return angle
	end
	
	function state:calculateEndValue(angle)
		if angle >= 70 and angle <= 110 then
			angle = 90
		elseif (angle >= -180 and angle <= -160) or (angle >= 160 and angle <= 180) then
			angle = 180
		elseif angle >= -110 and angle <= -70 then
			angle = -90
		elseif (angle >= -20 and angle <= 0) or (angle >= 0 and angle <= 20) then
			angle = 0
		elseif angle >= 25 and angle <= 65 then
			angle = 45
		elseif angle >= -65 and angle <= -25 then
			angle = -45
		elseif angle >= 115 and angle <= 155 then
			angle = 135
		elseif angle >= -155 and angle <= -115 then
			angle = -135
		else
			--error("Unknown angle")
			angle = "???"
			--return false
		end
		
		return angle
	end
	
	function state:onEndSwipe(event)
		local angle = self:getAngle(event.xStart, event.yStart, event.x, event.y)
		angle = self:calculateEndValue(angle)
		
		
	end
	
	
	
	function state:tick(time)
	end
	
	return state
end


return JXLUberAttackState