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


	return model

end

return GrapplerModel