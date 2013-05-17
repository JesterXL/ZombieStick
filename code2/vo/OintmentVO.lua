OintmentVO = {}

function OintmentVO:new()
	local aid   = FirstAidVO:new("Ointment", 
				"Helps keep infection away and help wound heal.",
				constants.FIRST_AID_OINTMENT,
				nil,
				10)
	
	return aid
end

return OintmentVO