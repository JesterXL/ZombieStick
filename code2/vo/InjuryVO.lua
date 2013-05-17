InjuryVO = {}

function InjuryVO:new(name, applyInterval, injuryType, amount, lifetime)
	assert(applyInterval ~= nil, "applyInterval cannot be nil")
	assert(injuryType ~= nil, "injuryType cannot be nil")
	assert(amount ~= nil, "amount cannot be nil")

	assert(type(applyInterval) == "number", "applyInterval must be of injuryType number")
	assert(type(injuryType) == "string", "injuryType must be of injuryType number")
	assert(type(amount) == "number", "amount must be of injuryType number")

	assert(applyInterval > -1, "applyInterval must be equal to or greater than 0")

	local injury 				= {}
	injury.name 				= name
	injury.applyInterval 		= applyInterval
	injury.injuryType			= injuryType
	injury.amount 				= amount
	if lifetime == nil then
		lifetime = -1 -- default to live forever
	end
	injury.lifetime 			= lifetime
	
	-- [jwarden 6.16.2012] NOTE/TODO: I wanted to keep track of when it was created,
	-- so that whoever handles applying the injuries knew that time had in fact passed since the actual
	-- injury was created, therefore to make up for lost time. However... screw it.
	--injury.creationTime 		= system.getTimer()
	injury.currentTime 			= 0
	injury.totalTimeAlive 		= 0

	injury.icon 				= nil

	


	return injury
end

return InjuryVO