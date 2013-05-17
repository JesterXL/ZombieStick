SutureVO = {}

function SutureVO:new()
	local aid   = FirstAidVO:new("Suture", 
				"Needle and thread to help close large skin wounds and to prevent scarring and infection.",
				constants.FIRST_AID_SUTURE,
				nil,
				4)
	
	return aid
end

return SutureVO