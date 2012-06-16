require "com.jxl.core.components.ProgressBar"

HealthBar = {}
 
function HealthBar:new()
	local group = ProgressBar:new(200, 0, 0, 0, 255, 0)
	
	function group:onPlayerHealthChanged(event)
		if event.target.classType == self.targetClassType then
			self:setProgress(event.value, event.maxHealth)
		end
	end

	Runtime:addEventListener("onPlayerHealthChanged", group)

	return group
end
 
return HealthBar