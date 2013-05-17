FirstAidVO = {}

function FirstAidVO:new(name, description, firstAidType, icon, amount)
	local aid        = {}
	aid.name         = name
	aid.icon         = icon
	aid.description  = description
	aid.amount       = amount
	aid.firstAidType = firstAidType
	return aid
end

return FirstAid