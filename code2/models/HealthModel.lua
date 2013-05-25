

HealthModel = {}

function HealthModel:new()
	local model = {}
	model.health = 100
	model.maxHealth = 100

	function model:setHealth(value)
		-- print("PlayerJXL::setHealth, value:", value)
		assert(value ~= nil, "value cannot be nil.")
		local oldValue = self.health
		self.health = value
		if self.health < 0 then
			self.health = 0
		end

		local difference = self.health - oldValue
		if difference ~= 0 then
			floatingText:text({x=0, y=-32, amount=difference, textTarget=self, textType=constants.TEXT_TYPE_HEALTH})
		end
	end

	model:init()

	return model
end

return HealthModel