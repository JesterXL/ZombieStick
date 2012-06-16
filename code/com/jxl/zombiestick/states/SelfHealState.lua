require "com.jxl.core.statemachine.BaseState"
require "com.jxl.zombiestick.gamegui.hud.ButtonSeries"
require "com.jxl.zombiestick.gamegui.buttons.CounterclockwiseSwipeButton"
require "com.jxl.zombiestick.gamegui.buttons.SwipeRightButton"
require "com.jxl.zombiestick.gamegui.buttons.SwipeLeftButton"
require "com.jxl.zombiestick.gamegui.buttons.SwipeUpButton"
require "com.jxl.zombiestick.gamegui.buttons.SwipeDownButton"

SelfHealState = {}

function SelfHealState:new()
	local state = BaseState:new("selfHeal")
	state.buttonSeries = nil
	
	function state:onEnterState(event)
		print("SelfHealState::onEnterState")
		local player = self.entity

		Runtime:addEventListener("onMoveLeftStarted", self)
		Runtime:addEventListener("onMoveRightStarted", self)
		Runtime:addEventListener("onAttackStarted", self)
		Runtime:addEventListener("onGrappleTargetTouched", self)
		Runtime:addEventListener("onJumpStarted", self)
		Runtime:addEventListener("onJumpLeftStarted", self)
		Runtime:addEventListener("onJumpRightStarted", self)

		-- TODO: inspect the injury-type. This'll allow me to customize the
		-- button series we're supposed to show (different one for bites vs. lacerations).
		-- Also, give the player a chance to do make-shift healing vs. doing it right.
		-- They can just wrap gauze around a wound to slow down the bleeding vs. cleaning it right.
		-- This allows them to heal in time-sensitive situations and keep them alive long enough
		-- until the have a breather.

		local buttons = {SwipeDownButton,
						SwipeUpButton,
						CounterclockwiseSwipeButton,
						CounterclockwiseSwipeButton,
						CounterclockwiseSwipeButton,
						SwipeRightButton,
						SwipeLeftButton,
						SwipeRightButton,
						SwipeLeftButton}
		local buttonSeries = ButtonSeries:new(buttons)
		buttonSeries.x = 100
		buttonSeries.y = 100
		buttonSeries:start()
		buttonSeries:addEventListener("onButtonSeriesComplete", self)
		LevelView.instance.buttonChildren:insert(buttonSeries)
		self.buttonSeries = buttonSeries
	end
	
	function state:onExitState(event)
		print("SelfHealState::onExitState")
		Runtime:removeEventListener("onMoveLeftStarted", self)
		Runtime:removeEventListener("onMoveRightStarted", self)
		Runtime:removeEventListener("onAttackStarted", self)
		Runtime:removeEventListener("onGrappleTargetTouched", self)
		Runtime:removeEventListener("onJumpStarted", self)
		Runtime:removeEventListener("onJumpLeftStarted", self)
		Runtime:removeEventListener("onJumpRightStarted", self)
	end
	
	function state:tick(time)
		local player = self.entity
		
	end

	function state:onButtonSeriesComplete(event)
		print("SelfHealState::onButtonSeriesComplete")
		-- remove latest injury vs. specific one
		local player = self.entity
		player:removeLatestInjury()
		self.stateMachine:changeStateToAtNextTick("ready")
	end

	function state:onMoveLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("movingLeft")
	end
	
	function state:onMoveRightStarted(event)
		self.stateMachine:changeStateToAtNextTick("movingRight")
	end
	
	function state:onAttackStarted(event)
		self.stateMachine:changeStateToAtNextTick("attack")
	end
	
	function state:onGrappleTargetTouched(event)
		self.stateMachine:changeStateToAtNextTick("grapple")
	end
	
	function state:onJumpStarted(event)
		self.stateMachine:changeStateToAtNextTick("jump")
	end
	
	function state:onJumpLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpLeft")
	end
	
	function state:onJumpRightStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpRight")
	end
	
	function state:onHealButtonTouch(event)
		self.stateMachine:changeStateToAtNextTick("selfHeal")
	end
	
	return state
end

return SelfHealState