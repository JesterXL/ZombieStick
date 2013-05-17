require "vo.BandageVO"
require "vo.AntibacterialSoapVO"
require "vo.OintmentVO"

FirstAidsModel = {}

function FirstAidsModel:new()
	local model = {}
	model.firstAids = nil

	function model:init()
		local firstAids = {}
		-- for i=1,1 do
		-- 	local vo = BandageVO:new()
		-- 	table.insert(firstAids, vo)
		-- end

		table.insert(firstAids, BandageVO:new())
		table.insert(firstAids, AntibacterialSoapVO:new())
		table.insert(firstAids, OintmentVO:new())

		self.firstAids = firstAids
	end

	model:init()

	return model
end

return FirstAidsModel