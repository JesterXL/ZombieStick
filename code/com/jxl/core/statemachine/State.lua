State = {}

function State:new(params)

	local state = {}
	state.name = params.name
	state.from = params.from
	state.enter = params.enter
	state.exit = params.exit
	state.parent = params.parent
	
	function state:setParent(parent)
		self.parent = parent
		self.parent:addChildState(self)
	end
	
	function state:getRoot()
		local parentState = self.parent
		if parentState then
			while parentState.parent do
				parentState = parentState.parent
			end
		end
		return parentState
	end
	
	function state:getParents()
		local parents = {}
		local parentState = self.parent
		--print("State::getParents, name: ", self.name, ", parent: ", self.parent)
		if parentState ~= nil then
			table.insert(parents, parentState)
			while parentState.parent do
				parentState = parentState.parent
				table.insert(parents, parentState)
			end
		end
		return parents
	end
	
	function state:inFrom(stateName)
		if self.from == nil then return false end
		local from = self.from
		if type(from) == "string" then
			return (from == stateName)
		elseif type(from) == "table" then
			local i = 1
			while from[i] do
				local name = from[i]
				if from == stateName then
					return true
				end
			end
			return false
		end
		return false
	end
	
	return state
end

return State