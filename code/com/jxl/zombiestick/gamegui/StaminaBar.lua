require "com.jxl.core.components.ProgressBar"

StaminaBar = {}
 
function StaminaBar:new()
	local group = ProgressBar:new({0, 0, 0}, {0, 255, 0})
	
	return group
end
 
return StaminaBar