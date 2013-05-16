FirstAidVO = {}

function FirstAidVO:new(name, description, icon, amount)
	local aid       = {}
	aid.name        = name
	aid.icon        = icon
	aid.description = description
	aid.amount      = amount
	
	return aid
end

return FirstAid