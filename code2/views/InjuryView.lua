local widget = require "widget"
require "views.InjuryItemRenderer"
InjuryView = {}

function InjuryView:new(startX, startY, layoutWidth, layoutHeight)

	local view = display.newGroup()
	view.background = nil
	view.x = startX
	view.y = startY
	view.layoutWidth = layoutWidth
	view.layoutHeight = layoutHeight
	view.scrollView = nil

	function view:init()
		local background = display.newRect(0, 0, self.layoutWidth, self.layoutHeight)
		background:setReferencePoint(display.TopLeftReferencePoint)
		background:setFillColor(255, 255, 255, 200)
		background:setStrokeColor(0, 0, 0)
		background.strokeWidth = 2
		self:insert(background)
		self.background = background

		local MARGIN = 4
		local MARGIN2 = MARGIN * 2
		local scrollViewWidth = self.layoutWidth - MARGIN2
		local scrollViewHeight = self.layoutHeight - MARGIN2

		local scrollView = widget.newScrollView
		{
		    top = MARGIN,
		    left = MARGIN,
		    width = scrollViewWidth,
		    height = scrollViewHeight,
		    scrollWidth = scrollViewWidth,
		    scrollHeight = scrollViewHeight,
		    maskFile = "assets/images/mask-injury-view.png",
		    listener = function(e) end,
		}
		self:insert(scrollView)
		self.scrollView = scrollView

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function view:setInjuries(injuries)
		local scrollView = self.scrollView
		local itemWidth = scrollView.width
		local itemHeight = 70
	    local startY = 0
		local i
		for i = 1, #injuries do
			local injury = injuries[i]
			local item = InjuryItemRenderer:new(itemWidth, itemHeight)
			scrollView:insert(item)
			item:setInjury(injury)

			item.y = startY
			startY = startY + item.height
		end
	end

	view:init()

	return view 

end

return InjuryView