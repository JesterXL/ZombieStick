require "components.ImageBox"
require "components.AutoSizeText"
require "components.ProgressBar"
local widget = require "widget"

FirstAidItemRenderer = {}

function FirstAidItemRenderer:new(layoutWidth, layoutHeight)

	local view = display.newGroup()
	view.background = nil
	view.icon = nil
	view.titleField = nil
	view.descriptionField = nil
	view.amountField = nil
	view.useButton = nil
	view.startTime = nil

	function view:init()
		local MARGIN = 4

		local background = display.newRect(self, 0, 0, layoutWidth, layoutHeight)
		self.background = background
		background:setFillColor(255, 255, 255)
		background:setStrokeColor(0, 0, 0)
		background.strokeWidth = 1
		background:setReferencePoint(display.TopLeftReferencePoint)

		local icon = ImageBox:new(self, 60, 60)
		self.icon = icon
		icon.x = MARGIN
		icon.y = MARGIN

		local titleField = AutoSizeText:new(self)
		self.titleField = titleField
		titleField:setTextColor(0, 0, 0)
		titleField.x = icon.x + icon.width + MARGIN
		titleField.y = icon.y
		titleField:setText("---")
		titleField:setFontSize(14)

		local descriptionField = AutoSizeText:new(self)
		self.descriptionField = descriptionField
		descriptionField:setTextColor(0, 0, 0)
		descriptionField.x = titleField.x
		descriptionField.y = titleField.y + titleField.height
		descriptionField:setText("---")
		descriptionField:setSize(layoutWidth - descriptionField.x - 80 - MARGIN, layoutHeight - descriptionField.y)
		descriptionField:setFontSize(9)

		local amountField = AutoSizeText:new(self)
		self.amountField = amountField
		amountField:setTextColor(255, 0, 0)
		amountField.x = icon.x
		amountField.y = icon.y
		amountField:setText("---")
		amountField:setFontSize(11)

		local useButton = widget.newButton
		{
		    left = 0,
		    top = 0,
		    width = 80,
		    height = 60,
		    id = "useButton",
		    label = "Use",
		    onEvent = function(e) self:onUseButtonTouched(e) end,
		}
		useButton:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(useButton)
		self.useButton = useButton
		useButton.x = layoutWidth - (useButton.width + MARGIN)
		useButton.y = MARGIN

		self.startTime = system.getTimer()
		gameLoop:addLoop(self)
	end

	function view:setFirstAid(firstAidVO)
		self.firstAidVO = firstAidVO

		self.icon:loadImage(firstAidVO.icon)
		self.titleField:setText(firstAidVO.name)
		self.descriptionField:setText(firstAidVO.description)
		self.amountField:setText(firstAidVO.amount)
	end

	function view:tick(time)
		if self.firstAidVO == nil then return true end

		if system.getTimer() - self.startTime > 500 then
			self.amountField:setText(self.firstAidVO.amount)
		end
	end

	function view:onUseButtonTouched(event)
		if event.phase == "ended" then
			Runtime:dispatchEvent({name="onUseFirstAid", firstAidVO=self.firstAidVO})
		end
		return true
	end

	function view:destroy()
		gameLoop:removeLoop(self)

		self.background:removeSelf()
		self.background = nil

		self.icon:removeSelf()
		self.icon = nil

		self.titleField:removeSelf()
		self.titleField = nil

		self.descriptionField:removeSelf()
		self.descriptionField = nil

		self.amountField:removeSelf()
		self.amountField = nil

		self.useButton:removeSelf()
		self.useButton = nil

		self.firstAidVO = nil
	end

	view:init()

	return view
end

return FirstAidItemRenderer