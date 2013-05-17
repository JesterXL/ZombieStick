require "vo.BandageVO"
FirstAidsModel = {}

function FirstAidsModel:new()
	local model = {}
	model.firstAids = nil

	function model:init()
		local firstAids = {}
		for i=1,1 do
			local vo = BandageVO:new()
			table.insert(firstAids, vo)
		end
		self.firstAids = firstAids
	end

	model:init()

	return model
end

return FirstAidsModel