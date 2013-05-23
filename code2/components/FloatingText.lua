FloatingText = {}

function FloatingText:new()
	local floating = display.newGroup()
	floating.textPool = {}

	function floating:text(event)
		-- convert from local to global coordinates, and back again
		local targetX, targetY = event.textTarget:localToContent(event.x, event.y)
		targetX, targetY = self:contentToLocal(targetX, targetY)
		self:showText(targetX, targetY, event.amount, event.textType, event.text)
	end


	function floating:showText(targetX, targetY, amount, textType, text)
		local field
		if table.maxn(self.textPool) > 0 then
			field = self.textPool[1]
			assert(field ~= nil, "Failed to get item from pool")
			table.remove(self.textPool, table.indexOf(self.textPool, field))
			assert(field ~= nil, "After cleanup, field got nil.")
		else
			print("floatingtext")
			field = display.newText("", 0, 0, 60, 60, native.systemFont, constants.FLOATING_TEXT_FONT_SIZE)
			function field:onComplete(obj)
				if self.tween then
					transition.cancel(field.tween)
					field.tween = nil
				end
				if self.alphaTween then
					transition.cancel(field.alphaTween)
					field.alphaTween = nil
				end
				table.insert(floating.textPool, field)
			end
		end
		assert(field ~= nil, "After if statement, field is nil.")
		field:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(field)
		field.x = targetX
		field.y = targetY
		field.alpha = 1

		local fieldText
		if amount ~= nil then
			local amountText = tostring(amount)
			if amount > 0 then
				amountText = "+" .. amountText
			end

			if textType == constants.TEXT_TYPE_STAMINA then
				if amount > 0 then
					field:setTextColor(unpack(constants.STAMINA_FIELD_POSITIVE_COLOR))
				else
					field:setTextColor(unpack(constants.STAMINA_FIELD_NEGATIVE_COLOR))
				end
			elseif textType == constants.TEXT_TYPE_HEALTH then
				if amount > 0 then
					field:setTextColor(unpack(constants.HEALTH_FIELD_POSITIVE_COLOR))
				else
					field:setTextColor(unpack(constants.HEALTH_FIELD_NEGATIVE_COLOR))
				end
			else
				field:setTextColor(0, 0, 0)
			end

			fieldText = amountText
		else
			field:setTextColor(0, 0, 0)
			fieldText = text
		end

			
		field.text = amountText
		local newTargetY = targetY - 40
		field.tween = transition.to(field, {y=newTargetY, time=500, transition=easing.outExpo})
		field.alphaTween = transition.to(field, {alpha=0, time=200, delay=300, onComplete=field})
	end
	
	function floating:init()
		self:destroy()
		self.textPool = {}
	end

	function floating:destroy()
		local len = self.numChildren
		for i=len,1,-1 do
			self:remove(i)
		end

		local pool = self.textPool
		len = #pool
		for i=len,1,-1 do
			table.remove(pool, i)
		end
	end

	return floating
end

return FloatingText