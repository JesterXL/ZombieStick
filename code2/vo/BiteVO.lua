require "vo.InjuryVO"
BiteVO = {}

function BiteVO:new()

	local bite = InjuryVO:new("Bite", 2 * 1000, constants.INJURY_BITE, -2, 3 * 60 * 1000)

	bite.usedBandage = false
	bite.usedOintment = false

	function bite:setUsedBandage(value)
		self.usedBandage = value
		if value == true then
			self.currentTime = 0
			self.amount = -1
			self.applyInterval = 30 * 1000
			self.lifetime = 1 * 60 * 1000
		end
	end

	function bite:setUsedOintment(value)
		self.usedOintment = value
	end

	-- function bite:getInfected()
	-- 	local num = math.round(math.random() * 100)
	-- 	if self.usedOintment == true then
	-- 		num = num - 60
	-- 	end
	-- 	if self.usedBandage == true then
	-- 		num = num - 20
	-- 	end

	-- 	if num > 20 then
	-- 		return true
	-- 	else
	-- 		return false
	-- 	end
	-- end


	function bite:getStatus()
		local str = ""
		if self.usedOintment == false then
			str = str .. "No ointment applied, risk of infection."
		else
			str = str .. "Ointment applied, no risk of infection."
		end

		if self.usedBandage == false then
			str = str .. "No bandage applied."
		else
			str = str .. "Bandage applied, blood loss slowed, will heal in " .. tostring(math.round(self.lifetime / 1000)) .. " seconds."
		end
		return str
	end
	
	return bite

end

return BiteVO