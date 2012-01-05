require "com.jxl.core.statemachine.State"

BaseState = {}

function BaseState:new(name, parent, from)

	assert(name ~= nil, "You cannot pass a nil name.")
	
	if parent == nil or parent == "" then
		parent = "*"
	end
	
	local state = State:new({name = name, parent = parent, from = from})
	
	state.enter = function(event)
		return state:onEnterState(event)
	end
	state.exit = function(event)
		return state:onExitState(event)
	end
	
	
	function state:onEnterState(event)
		print(self.name .. " BaseState::onEnterState, from: ", event.fromState, ", to: ", event.toState, ", current: ", event.currentState)
	end
	
	function state:onExitState(event)
		print(self.name .. " BaseState::onExitState, from: ", event.fromState, ", to: ", event.toState, ", current: ", event.currentState)
	end
	
	function state:onTransitionComplete(event)
		print(self.name .. " BaseState::onTransitionComplete, from: ", event.fromState, ", to: ", event.toState, ", current: ", event.currentState)
	end
	
	function state:onTransitionDenied(event)
		print(self.name .. " BaseState::onTransitionDenied, from: ", event.fromState, ", to: ", event.toState, ", current: ", event.currentState)
	end
	
	Runtime:addEventListener("onTransitionComplete", function(event)
														if event.toState == state.name then
															return state:onTransitionComplete(event)
														end
													end
							)
							
	Runtime:addEventListener("onTransitionDenied", function(event)
														if event.toState == state.name then
															return state:onTransitionDenied(event)
														end
													end
							)
	
	return state
	
end

return BaseState