local widget = require "widget"

require "com.jxl.zombiestick.screens.SavedGameitem"

SavedGameScreen = {}

function SavedGameScreen:new()
	local screen = display.newGroup()

	function screen:init(savedGames)

		local background = display.newRect(0, 0, 320, 320)
		background:setFillColor(0, 0, 0, 80)
		background:setStrokeColor(255, 0, 0)
		background.strokeWidth = 1
		background:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(background)
		self.background = background


		local scrollView = widget.newScrollView{
		    width = 320,
		    height = 320,
		    scrollWidth = 320,
		    scrollHeight = 800
		}
		self.scrollView = scrollView
		self:insert(scrollView)

		local ITEM_HEIGHT = 60
		local startY = 0

		for i=1,#savedGames do
			local game = savedGames[i]
			local item = SavedGameItem:new()
			item:init(game)
			scrollView:insert(item)
			item.y = startY
			startY = startY + ITEM_HEIGHT
		end
	end

	function screen:destroy()
		if self.scrollView ~= nil then
			display.remove(self.scrollView)
			self.scrollView = nil
		end
	end

	return screen
end

return SavedGameScreen