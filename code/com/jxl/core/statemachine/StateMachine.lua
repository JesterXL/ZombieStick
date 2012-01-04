require "com.jxl.core.statemachine.State"
StateMachine = {}

function StateMachine:new()
	
	local stateMachine = {}
	stateMachine.states = {}
	stateMachine.id = nil
	stateMachine.state = nil
	stateMachine.states = {}
	stateMachine.parentState = nil
	stateMachine.parentStates = {}
	stateMachine.path = {}
	
	function stateMachine:addState(stateName, stateData)
		if self.states[stateName] ~= nil then
			print("StateMachne::addedState, overriding existing state: " .. stateName)
		end
		
		if stateData == nil then stateData = {} end
		
		local newStatesParent = nil
		if stateData.parent then
			newStatesParent = self.states[stateData.parent.name]
		end
		local state = State:new({name = stateName,
									from = stateData.from,
									enter = stateData.enter,
									exit = stateData.exit,
									parent = newStatesParent})
		self.states[stateName] = state
	end
	
	function stateMachine:setInitialState(stateName)
		local initial = self.states[stateName]
		--print("StateMachine::setInitialState, stateName: ", stateName)
		--print("state: ", self.state, ", initial: ", initial)
		if self.state == nil and initial ~= nil then
			self.state = stateName
			
			local event = {name = "onEnterState", target = self, toState = stateName}
			
			local root = initial:getRoot()
			--print("root: ", root)
			if root ~= nil then
				local newParentStates = initial:getParents()
				self.parentStates = newParentStates
				local i = 1
				while newParentStates[i] do
					if newParentStates[i].enter ~= nil then
						event.currentState = newParentStates[i].name
						newParentStates[i].enter(event)
					end
					i = i + 1
				end
			end
			
			if initial.enter ~= nil then
				event.currentState = stateName
				initial.enter(event)
			end
			
			local outEvent = {name = "onTransitionComplete", target = self, toState = stateName}
			self:dispatchEvent(outEvent)
		end
	end
	
	function stateMachine:getStateByName(stateName)
		local i = 1
		local states = self.states
		for i,v in ipairs(states) do
			if(v ~= nil and v.name == stateName) then
				return v
			end
		end
		return false
	end
	
	function stateMachine:canChangeTo(stateName)
		local theState = self.states[stateName]
		if stateName ~= self.state and (theState:inFrom(self.state) == false or theState.from == "*") then
			return true
		else
			return false
		end
	end
	
	function stateMachine:findPath(stateFrom, stateTo)
		local states = self.states
		local fromState = states[stateFrom]
		local c = 1
		local d = 1
		while fromState do
			d = 1
			local toState = states[stateTo]
			while toState do
				if fromState == toState then
					return {c, d}
				end
				d = d + 1
				toState = toState.parent
			end
			c = c + 1
			fromState = fromState.parent
		end
		return {0, 0}
	end
	
	function stateMachine:changeState(stateTo)
		local state = self.state
		local states = self.states
		local toState = states[stateTo]
		if toState == nil then
			print("StateMachine::changeState, Cannot make transition: State " .. stateTo .. " is not defined.")
			return false
		end
		
		if changeChangeStateTo(stateTo) == false then
			print("StateMachine::changestate, Transition to " .. stateTo .. " denied.")
			local outEvent = {name = "onTransitionDenied",
								target = self,
								fromState = state,
								toState = stateTo,
								allowedStates = states[stateTo].from}
			self:dispatchEvent(outEvent)
			return false
		end
		
		local path = self:findPath(state, stateTo)
		if path[1] > 0 then
			local exitCallback = {name = "onExit",
									target = self,
									toState = stateTo,
									fromState = state}
			
			if states[state].exit ~= nil then
				exitCallback.currentState = state
				states[state].exit(exitCallback)
			end
			
			-- TODO: optimize via locals
			self.parentState = states[state]
			
			local p = 1
			local firstPath = path[1]
			local len = firstPath - 1
			while p < len do
				self.parentState = self.parentState.parent
				if self.parentState.exit ~= nil then
					exitCallback.currentState = self.parentState.name
					self.parentState.exit(exitCallback)
				end
			end
		end
		
		local oldState = state
		self.state = stateTo
		state = stateTo
		
		if path[2] > 0 then
			local enterCallback = {name = "onEnterState",
									target = self,
									toState = stateTo,
									fromState = oldState}
			
			if states[stateTo].root ~= nil then
				self.parentStates = states[stateTo].parents
				local secondPath = path[1]
				local k = secondPath - 2
				while k >= 0 do
					if self.parentStates[k] and self.parentStates[k].enter then
						enterCallback.currentState = self.parentStates[k].name
						self.parentStates[k].enter(enterCallback)
					end
				end
			end
			
			if states[state].enter ~= nil then
				enterCallback.currentState = state
				states[state].enter(enterCallback)
			end
		end
		
		print("StateMachine::changeState, State changed to " .. state)
		
		local outEvent = {name = "onTransitionComplete",
							target = self,
							fromState = oldState,
							toState = stateTo}
		self:dispatchEvent(outEvent)
	end
	
	-- event helpers
	
	function stateMachine:addEventListener(name, listener)
		return Runtime:addEventListener(name, listener)
	end
	
	function stateMachine:removeEventListener(name, listener)
		return Runtime:removeEventListener(name, listener)
	end
	
	function stateMachine:dispatchEvent(event)
		--print("StateMachine::dispatchEvent")
		return Runtime:dispatchEvent(event)
	end
	
	return stateMachine
	
end

return StateMachine