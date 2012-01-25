require "com.jxl.core.components.ProgressBar"

HealthBar = {}
 
function HealthBar:new()
	local group = HealthBar:new({0, 0, 0}, {153, 0, 0})
	
	return group
end
 
return HealthBar