
require "vo.FirstAidVO"

AntibacterialSoapVO = {}

function AntibacterialSoapVO:new(name, description, icon, amount)
	local aid   = FirstAidVO:new("Antibacterial Soap", 
				"Helps clean wounds and ensure no bacterial infection develops.",
				constants.FIRST_AID_ANTIBACTERIAL_SOAP,
				nil,
				30)
	return aid
end

return AntibacterialSoapVO