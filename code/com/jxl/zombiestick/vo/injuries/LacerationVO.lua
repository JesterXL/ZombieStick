require "com.jxl.zombiestick.vo.InjuryVO"
LacerationVO = {}

function LacerationVO:new()

	local cut = InjuryVO:new(6 * 1000, constants.INJURY_LACERATION, -1, 60 * 1000)
	return cut

end

return LacerationVO