require "components.ImageBox"
require "components.AutoSizeText"
require "components.ProgressBar"
local widget = require "widget"

InjuryItemRenderer = {}

function InjuryItemRenderer:new(layoutWidth, layoutHeight)

	local view = display.newGroup()
	view.background = nil
	view.icon = nil
	view.titleField = nil
	view.progressBar = nil
	view.treatButton = nil

	function view:init()
		local MARGIN = 4

		local background = display.newRect(self, 0, 0, layoutWidth, layoutHeight)
		self.background = background
		background:setFillColor(255, 255, 255)
		background:setStrokeColor(0, 0, 0)
		background.strokeWidth = 1
		background:setReferencePoint(display.TopLeftReferencePoint)

		local icon = ImageBox:new(self, 50, 50)
		self.icon = icon
		icon.x = MARGIN
		icon.y = MARGIN

		local titleField = AutoSizeText:new(self)
		self.titleField = titleField
		titleField:setTextColor(0, 0, 0)
		titleField.x = icon.x + icon.width + MARGIN
		titleField.y = icon.y
		titleField:setText("---")

		local progressBar = ProgressBar:new(self, icon.width, 6, {50, 50, 50}, {0, 255, 0})
		self.progressBar = progressBar
		progressBar.x = icon.x
		progressBar.y = icon.y + icon.height + MARGIN

		local treatButton = widget.newButton
		{
		    left = 0,
		    top = 0,
		    width = 80,
		    height = 60,
		    id = "treatButton",
		    label = "Treat",
		    onEvent = function(e) self:onTreatButtonTouched(event) end,
		}
		treatButton:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(treatButton)
		self.treatButton = treatButton
		treatButton.x = layoutWidth - (treatButton.width + MARGIN)
		treatButton.y = MARGIN
	end

	function view:setInjury(injuryVO)
		self.injuryVO = injuryVO

		self.icon:loadImage(injuryVO.icon)
		self.titleField:setText(injuryVO.name)
		self.progressBar:setProgress(injuryVO.currentTime, injuryVO.applyInterval)
	end

	function view:onTreatButtonTouched(event)
		if event.phase == "ended" then
			Runtime:dispatchEvent({name="onTreatInjury", injury=self.injury})
		end
		return true
	end

	view:init()


	return view
end

return InjuryItemRenderer