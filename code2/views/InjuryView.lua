local widget = require "widget"
require "views.injuryviews.InjuryItemRenderer"
InjuryView = {}

function InjuryView:new(startX, startY, layoutWidth, layoutHeight)

	local view = display.newGroup()
	view.classType = "InjuryView"
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
		    maskFile = "assets/images/mask-injury-view.png"
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
		scrollView.children = {}
		for i = 1, #injuries do
			local injury = injuries[i]
			local item = InjuryItemRenderer:new(itemWidth, itemHeight)
			scrollView:insert(item)
			table.insert(scrollView.children, item)
			item:setInjury(injury)

			item.y = startY
			startY = startY + item.height
		end
	end

	function view:removeInjury(vo)
		local scrollView = self.scrollView
		local i = table.maxn(scrollView.children)
		while i > 0 do
			local child = scrollView.children[i]
			if child.injuryVO == vo then
				child:destroy()
				child:removeSelf()
				table.remove(scrollView.children, i)
				self:refresh()
				return true
			end
			i = i - 1
		end
	end

	function view:refresh()
		local scrollView = self.scrollView
		local itemHeight = 70
	    local startY = 0
		local i
		local children = scrollView.children
		for i = 1, #children do
			local item = children[i]
			item.y = startY
			startY = startY + item.height
		end
	end

	function view:destroy()
		Runtime:dispatchEvent({name="onRobotlegsViewDestroyed", target=self})

		self.background:removeSelf()
		self.background = nil

		local scrollView = self.scrollView
		local i = table.maxn(scrollView.children)
		while i > 0 do
			local child = scrollView.children[i]
			child:destroy()
			child:removeSelf()
			i = i - 1
		end

		self.scrollView:removeSelf()
		self.scrollView = nil

		self.injuries = nil
	end

	view:init()

	return view 

end

return InjuryView