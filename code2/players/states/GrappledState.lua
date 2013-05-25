require "utils.BaseState"
-- require "com.jxl.zombiestick.gamegui.hud.ButtonSeries"
-- require "com.jxl.zombiestick.gamegui.buttons.CounterclockwiseSwipeButton"
-- require "com.jxl.zombiestick.gamegui.buttons.SwipeRightButton"
-- require "com.jxl.zombiestick.gamegui.buttons.SwipeLeftButton"
-- require "com.jxl.zombiestick.gamegui.buttons.SwipeUpButton"
-- require "com.jxl.zombiestick.gamegui.buttons.SwipeDownButton"

GrappledState = {}

function GrappledState:new()
	local state = BaseState:new("grappled")
	state.buttonSeries = nil
	
	function state:onEnterState(event)
		print("GrappledState::onEnterState")
		local player = self.entity
		local grapplers = gGrapplerModel.grapplers
		if grapplers == nil or #grapplers < 1 then
			self.stateMachine:changeStateToAtNextTick("ready")
			return true
		end
		
		Runtime:addEventListener("accelerometer", self)
		-- self:createButtonSeries()
	end
	
	function state:onExitState(event)
		print("GrappledState::onExitState")
		Runtime:removeEventListener("accelerometer", self)
		self:destroyButtonSeries()
	end

	function state:accelerometer(event)
		print("GrappledState::accelerometer")
		self:onButtonSeriesComplete()
	end

	function state:destroyButtonSeries()
		if self.buttonSeries then
			buttonSeries:removeEventListener("onButtonSeriesComplete", self)
			self.buttonSeries:removeSelf()
			self.buttonSeries = nil
		end
	end

	function state:createButtonSeries()
		-- self:destroyButtonSeries()
		
		-- local buttons = {SwipeDownButton,
		-- 				SwipeUpButton}
		-- local buttonSeries = ButtonSeries:new(buttons)
		-- buttonSeries.x = 100
		-- buttonSeries.y = 100
		-- buttonSeries:start()
		-- buttonSeries:addEventListener("onButtonSeriesComplete", self)
		-- self.buttonSeries = buttonSeries
	end

	-- [jwarden 5.19.2013] TODO: Base this on skill. For now, only 1 grappler removed at a time.
	function state:onButtonSeriesComplete(event)
		print("GrappledDefenseState::onButtonSeriesComplete")
		-- remove latest injury vs. specific one
		local player = self.entity
		local grappler = gGrapplerModel:removeLatestGrappler()
		if grappler == nil then
			error("Couldn't remove latest grappler")
		end
		print("grappler:", grappler, grappler.classType)
		grappler:onGrappleDefeated()

		local grapplers = gGrapplerModel.grapplers
		if #grapplers > 0 then
			self:createButtonSeries()
		else
			self.stateMachine:changeStateToAtNextTick("ready")
		end
	end
	
	return state
end

return GrappledState