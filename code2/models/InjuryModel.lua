
InjuryModel = {}

function InjuryModel:new()
	
	local model = {}
	model.injuries = {}

	function model:init()
		gameLoop:addLoop(self)
	end

	function model:addInjury(injuryVO)
		local injuries = self.injuries
		if table.indexOf(injuries, injuryVO) == nil then
			table.insert(injuries, injuryVO)
			-- Runtime:dispatchEvent({name="onPlayerInjuriesChanged", target=self, injuries=injuries})
			return true
		else
			error("injuryVO already added to array")
		end
	end

	function model:hasInjury(injuryType)
		assert(injuryType ~= nil, "You cannot pass a nil injuryType.")
		local injuries = self.injuries
		if injuries == nil then return false end
		if #injuries < 1 then return false end

		local i = 1
		while injuries[i] do
			local vo = injuries[i]
			if vo.type == injuryType then return true end
			i = i + 1
		end
	end

	-- function model:healInjury(injuryVO)
	-- 	local injuries = self.injuries
	-- 	local i = 1
	-- 	while injuries[i] do
	-- 		local vo = injuries[i]
	-- 		if vo == injuryVO then
	-- 			table.remove(injuries, i)
	-- 			Runtime:dispatchEvent({
	-- 										name="InjuryModel_onChange", 
	-- 										target=self, 
	-- 										type="remove", 
	-- 										index=i, 
	-- 										injuryVO=vo
	-- 									})
	-- 			return true
	-- 		end
	-- 		i = i + 1
	-- 	end
	-- 	return false
	-- end

	function model:tick(time)
		local injuries = self.injuries
		if injuries and #injuries > 0 then
			local i = #injuries
			while i > 0 do
				local vo = injuries[i]
				vo.currentTime = vo.currentTime + time
				if vo.lifetime ~= -1 then
					vo.totalTimeAlive = vo.totalTimeAlive + time
				end
				if vo.currentTime >= vo.applyInterval then
					-- time's up, time to apply the injury
					vo.currentTime = 0
					Runtime:dispatchEvent({
											name="InjuryModel_applyInjury",
											target=self,
											index=i,
											injuryVO=vo
										})
				end
				
				if vo.lifetime ~= -1 and vo.totalTimeAlive >= vo.lifetime then
					print("InjuryModel::tick, removing " .. vo.name .. ", lifetime:" .. vo.lifetime)
					table.remove(injuries, i)
					Runtime:dispatchEvent({
											name="InjuryModel_onChange", 
											target=self, 
											type="remove", 
											index=i, 
											injuryVO=vo
										})
				end
				
				i = i - 1
			end
		end
	end

	model:init()


	return model
end

return InjuryModel