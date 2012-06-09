require "com.jxl.core.components.ProgressBar"

StaminaBar = {}
 
function StaminaBar:new()
	local group = ProgressBar:new(255, 255, 255, 0, 0, 255)
	
	function group:onPlayerStaminaChanged(event)
		if event.target.classType == self.targetClassType then
			self:setProgress(event.value, event.maxStamina)
		end
	end

	Runtime:addEventListener("onPlayerStaminaChanged", group)

	return group
end
 
return StaminaBar