require "com.jxl.core.components.ProgressBar"

HealthBar = {}
 
function HealthBar:new()
	local group = ProgressBar:new(200, 0, 0, 0, 255, 0)
	
	return group
end
 
return HealthBar