local widget = require "widget"

require "com.jxl.zombiestick.screens.SavedGameitem"

SavedGameScreen = {}

function SavedGameScreen:new()
	local screen = display.newGroup()

	function screen:init(savedGames)
		local scrollView = widget.newScrollView{
		    width = 320,
		    height = 320,
		    scrollWidth = 768,
		    scrollHeight = 1024
		}
		self.scrollView = scrollView
		self:insert(scrollView)

		for i=1,#savedGames do
			local game = savedGames[i]
			local item = SavedGameItem:new()
			item:init(game)
			scrollView:insert(item)
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