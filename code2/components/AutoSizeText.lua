AutoSizeText = {}

function AutoSizeText:new(parentGroup)

	local view = display.newGroup()
	parentGroup:insert(view)
	view._text = nil
	view._rgba = {255, 255, 255, 255}
	view._fontSize = 18
	view._width = nil
	view._height = nil
	view._autoSize = false
	view._bold = false

	function view:init()
		self:setText("")
	end

	function view:getText()
		return self._text
	end

	function view:setText(str, bypass)
		if self._text == str and bypass ~= true then
			return true
		end

		if str == nil then str = "nil" end
		
		self._text = str
		if self.field then
			self.field:removeSelf()
			self.field = nil
		end

		local newField
		local fontName
		if self._bold == false then
			fontName = native.systemFont
		else
			fontName = native.systemFontBold
		end
		
		if self._autoSize == true then
			newField = display.newText(str, 0, 0, fontName, self._fontSize)
		else
			newField = display.newText(str, 0, 0, self._width, self._height, fontName, self._fontSize)
		end
		

		newField:setReferencePoint(display.TopLeftReferencePoint)
		newField:setTextColor(unpack(self._rgba))
		self.field = newField
		self:insert(newField)
		-- field.size = self._fontSize
	end

	function view:setTextColor(r, g, b, alpha)
		if alpha == nil then
			alpha = 255
		end
		self._rgba = {r, g, b, alpha}
		self.field:setTextColor(r, g, b, alpha)
	end

	function view:setFontSize(size)
		self._fontSize = size
		self.field.size = size
	end

	function view:setSize(w, h)
		local dirty = false
		if self._width ~= w or self._height ~= h then
			dirty = true
		end
		self._width = w
		self._height = h
		if dirty then
			self:setText(self._text, true)
		end
	end

	function view:setAutoSize(val)
		if value ~= val then
			self._autoSize = val
			self:setText(self._text, true)
		end
	end

	function view:setBold(bold)
		if value ~= val then
			self._bold = bold
			self:setText(self._text, true)
		end
	end


	view:init()

	return view

end

return AutoSizeText