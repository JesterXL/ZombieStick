FirstAidsModel = {}

function FirstAidsModel:new()
	local model = {}
	model.firstAids = nil

	function model:init()
		local firstAids = {}
		for i=1,10 do
			local vo = FirstAidVO:new("Bandage", "Protects a cut, slows bleeding, and helps prevent infection while protecting the cut.")
			table.insert(firstAids, vo)
		end
		self.firstAids = firstAids
	end

	model:init()

	return model
end

return FirstAidsModel