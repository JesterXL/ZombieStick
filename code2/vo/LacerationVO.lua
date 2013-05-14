require "vo.InjuryVO"
LacerationVO = {}

function LacerationVO:new()

	-- applyInterval, injuryType, amount, lifetime
	local cut = InjuryVO:new(500, constants.INJURY_LACERATION, -1, 60 * 1000)
	-- local cut = InjuryVO:new(6 * 1000, constants.INJURY_LACERATION, -1, 60 * 1000)
	return cut

end

return LacerationVO