require "vo.InjuryVO"
BiteVO = {}

function BiteVO:new()

	local bite = InjuryVO:new("Bite", 2 * 1000, constants.INJURY_BITE, -2)

	bite.usedBangage = false

	function bite:setUsedBandage(value)
		self.usedBangage = value
		if value == true then
			self.currentTime = 0
			self.amount = -1
			self.lifetime = 1 * 60 * 1000
		end
	end

	function bite:getStatus()
		local str = ""
		if self.usedBangage == false then
			str = str .. "No bandage applied."
		else
			str = str .. "Bandage applied, blood loss slowed, will heal in " .. tostring(math.round(self.lifetime / 1000)) .. " seconds."
		end
		return str
	end
	
	return bite

end

return BiteVO