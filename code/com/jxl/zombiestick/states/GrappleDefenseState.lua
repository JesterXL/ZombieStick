require "com.jxl.core.statemachine.BaseState"
require "com.jxl.zombiestick.gamegui.hud.ButtonSeries"
require "com.jxl.zombiestick.gamegui.buttons.CounterclockwiseSwipeButton"
require "com.jxl.zombiestick.gamegui.buttons.SwipeRightButton"
require "com.jxl.zombiestick.gamegui.buttons.SwipeLeftButton"
require "com.jxl.zombiestick.gamegui.buttons.SwipeUpButton"
require "com.jxl.zombiestick.gamegui.buttons.SwipeDownButton"

GrappleDefenseState = {}

function GrappleDefenseState:new()
	local state = BaseState:new("grappleDefense")
	state.buttonSeries = nil
	
	function state:onEnterState(event)
		print("GrappleDefenseState::onEnterState")
		local player = self.entity
		local grapplers = player.grapplers
		if #grapplers < 1 then
			self.stateMachine:changeStateToAtNextTick("ready")
			return true
		end
		
		self:createButtonSeries()
	end
	
	function state:onExitState(event)
		print("GrappleDefenseState::onExitState")
		local buttonSeries = self.buttonSeries
		buttonSeries:removeSelf()
		self.buttonSeries = nil
	end
	
	function state:tick(time)
		local player = self.entity
		
	end

	function state:destroyButtonSeries()
		if self.buttonSeries then
			self.buttonSeries:removeSelf()
			self.buttonSeries = nil
		end
	end

	function state:createButtonSeries()
		self:destroyButtonSeries()
		
		local buttons = {SwipeDownButton,
						SwipeUpButton}
		local buttonSeries = ButtonSeries:new(buttons)
		buttonSeries.x = 100
		buttonSeries.y = 100
		buttonSeries:start()
		buttonSeries:addEventListener("onButtonSeriesComplete", self)
		LevelView.instance.buttonChildren:insert(buttonSeries)
		self.buttonSeries = buttonSeries
	end

	function state:onButtonSeriesComplete(event)
		print("GrappleDefenseState::onButtonSeriesComplete")
		-- remove latest injury vs. specific one
		local player = self.entity
		local grappler = player:removeLatestGrapple()
		grappler:onGrappleDefeated()

		local grapplers = player.grapplers
		if #grapplers > 0 then
			self:createButtonSeries()
		else
			self.stateMachine:changeStateToAtNextTick("ready")
		end
	end
	
	return state
end

return GrappleDefenseState