GunAmmoLine = {}

function GunAmmoLine:new(initialTotal, initialShown)

	local gunAmmoLine = display.newGroup()
	
	function gunAmmoLine:redraw(total, shown)
		local img
		local n = self.numChildren
		while n > 0 do
			-- TODO: object pool these
			img = self[n]
			img:removeSelf()
			n = n - 1
		end
		
		self.total = total
		
		local i
		local startX = 0
		for i=1,total do
			img = display.newImage("ammo-bullet45.png")
			self:insert(img)
			img.x = startX
			startX = startX + 6
			if i > shown then
				img.isVisible = false
			end
		end
	end
	
	function gunAmmoLine:showBullets(amount)
		assert(type(amount) == "number", "amount is not a number: ", amount)
		local total = self.total
		if amount > total then
			print("WARNING: GunAmmoLine::showBullets, amount was greater than 10.")
			amount = max
		end
		
		if amount < 0 then
			print("WARNING: GunAmmoLine::showBullets, amount was less than 0.")
			amount = 0
		end
		
		local shown = amount
		local i
		local img
		for i=1,total do
			img = self[i]
			img.isVisible = false
		end
		
		for i=1,shown do
			img = self[i]
			img.isVisible = true
		end
	end
	
	function gunAmmoLine:onPlayerGunAmmoChanged(event)
		self:showBullets(event.amount)
	end
	
	gunAmmoLine:redraw(initialTotal, initialShown)
	
	Runtime:addEventListener("onPlayerGunAmmoChanged", gunAmmoLine)
	
	
	return gunAmmoLine
	
end

return GunAmmoLine