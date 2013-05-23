Stats = {}

function Stats:new(layoutWidth, layoutHeight)
	local stats = display.newGroup()

	function stats:init()
		local rect = display.newRect(0, 0, layoutWidth, layoutHeight)
		rect:setReferencePoint(display.TopLeftReferencePoint)
		rect:setFillColor(0, 0, 0, 240)
		self:insert(rect)

		print("Stats")
		local field = display.newText("Memory: ---\nTexture: ---\n", 0, 0, layoutWidth, 0, native.systemFont, 11)
		field:setReferencePoint(display.TopLeftReferencePoint)
		field:setTextColor(255, 255, 255)
		self:insert(field)
		self.field = field


		Runtime:addEventListener("enterFrame", self)
	end

	function stats:enterFrame()
		collectgarbage()
		local str = ""
		str = str .. "Memory: " .. round(collectgarbage("count"), 1) .. "\n"
		str = str .. "Texture: " .. round((system.getInfo("textureMemoryUsed") / 1000000), 1)
		self.field.text = str
	end

	stats:init()

	return stats
end

return Stats