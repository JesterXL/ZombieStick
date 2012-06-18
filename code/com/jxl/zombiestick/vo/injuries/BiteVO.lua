require "com.jxl.zombiestick.vo.InjuryVO"
BiteVO = {}

function BiteVO:new()

	local bite = InjuryVO:new(2 * 1000, constants.INJURY_BITE, -1)
	return bite

end

return BiteVO