
require "vo.FirstAidVO"

BandageVO = {}

function BandageVO:new(name, description, icon, amount)
	local aid   = FirstAidVO:new("Bandage", 
				"Protects a cut, slows bleeding, and helps prevent infection while protecting the cut.",
				"assets/icons/icon-bandage.png",
				6)
	
	return aid
end

return BandageVO