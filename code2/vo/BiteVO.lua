require "vo.InjuryVO"
BiteVO = {}

function BiteVO:new()

	local bite = InjuryVO:new("Bite", 2 * 1000, constants.INJURY_BITE, -1)
	return bite

end

return BiteVO