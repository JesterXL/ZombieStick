GrapplerModel = {}

function GrapplerModel:new()

	local model = {}
	model.grapplers = {}

	function model:hasGrappler(grappler)
		local index = table.indexOf(self.grapplers, grappler)
		if index == nil then
			return false
		else
			return true, index
		end
	end

	function model:addGrappler(grappler)
		if self:hasGrappler(grappler) == false then
			table.insert(self.grapplers, grappler)
			Runtime:dispatchEvent({
				name = "GrapplerModel_onChange",
				kind="add",
				index=table.indexOf(self.grapplers, grappler),
				grappler = grappler
			})
			return true
		else
			return false
		end
	end

	function model:removeGrappler(grappler)
		local hasGrappler, index = self:hasGrappler(grappler)
		if hasGrappler == true then
			table.remove(self.grapplers, grappler)
			Runtime:dispatchEvent({
				name="GrapplerModel_onChange",
				kind="remove",
				index=index,
				grappler=grappler
			})
			return true
		else
			return false
		end
	end

	function model:removeLatestGrappler()
		local grapplers = self.grapplers
		if grapplers and #grapplers > 0 then
			local index = #grapplers
			local removedGrappler = self.grapplers[index]
			table.remove(self.grapplers)
			Runtime:dispatchEvent({
				name="GrapplerModel_onChange",
				kind="remove",
				index=index,
				grappler=removedGrappler
			})
			return removedGrappler
		else
			return false
		end
	end


	return model

end

return GrapplerModel