require "views.injuryviews.FirstAidItemRenderer"
local widget = require "widget"
FirstAidList = {}

function FirstAidList:new(layoutWidth, layoutHeight)
	local view = display.newGroup()
	view.classType = "FirstAidList"

	function view:init()
		local scrollView = widget.newScrollView
		{
		    top = 0,
		    left = 0,
		    width = layoutWidth,
		    height = layoutHeight,
		    scrollWidth = layoutWidth,
		    scrollHeight = layoutHeight,
		    maskFile="assets/images/mask-FirstAidList.png",
		    listener = function(e) end,
		}
		self:insert(scrollView)
		self.scrollView = scrollView

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function view:setFirstAids(firstAids)
		self.firstAids = firstAids

		local scrollView = self.scrollView
		local itemWidth = scrollView.width
		local itemHeight = 70
	    local startY = 0
		local i
		for i = 1, #firstAids do
			local firstAid = firstAids[i]
			local item = FirstAidItemRenderer:new(itemWidth, itemHeight)
			scrollView:insert(item)
			item:setFirstAid(firstAid)

			item.y = startY
			startY = startY + item.height - 1
		end
	end

	view:init()

	return view
end

return FirstAidList