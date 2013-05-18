require "vo.InjuryVO"
LacerationVO = {}

function LacerationVO:new()

	-- applyInterval, injuryType, amount, lifetime
	-- local cut = InjuryVO:new(500, constants.INJURY_LACERATION, -1, 60 * 1000)
	-- local lifetimeVariance = (13 * 1000) + math.round(math.random() * 5)
	local cut = InjuryVO:new("Laceration", 6 * 1000, constants.INJURY_LACERATION, -4, -1)

	cut.usedSuture = false
	cut.usedBandage = false

	function cut:setUsedSuture(value)
		self.usedSuture = true
		if value == true then
			self.currentTime = 0
			self.applyInterval = 30 * 1000
			self.lifetime = 10 * 1000
		end
	end

	function cut:setUsedBandage(value)
		print("Laceration::setUsedBandage, self.lifetime:", self.lifetime)
		self.usedBandage = value
		if value == true then
			self.currentTime = 0
			self.amount = -1
			if self.usedSuture then
				self.lifetime = 5 * 1000
			else
				self.lifetime = 15 * 1000
			end
		end
		print("and set lifetime:", self.lifetime)
	end

	function cut:getStatus()
		local str = ""
		if self.usedSuture == false then
			str = str .. "No suture applied, heavy blood loss."
		else
			str = str .. "Suture applied, blood loss slowed to " .. tostring(self.applyInterval / 1000) .. " seconds."
		end
		
		str = str .. " "

		if self.usedBandage == false then
			str = str .. "No bandage applied."
		else
			local lifetime = math.round((self.lifetime - self.totalTimeAlive) / 1000)
			if self.usedSuture then
				str = str .. "Bandage applied on top of suture, blood loss lessened, wound will heal in " .. tostring(lifetime) .. " seconds."
			else
				str = str .. "Bandage applied, blood loss lessened, wound will heal in " .. tostring(lifetime) .. " seconds."
			end
		end
			
		return str
	end

	return cut

end

return LacerationVO