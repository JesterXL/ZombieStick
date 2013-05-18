require "components.ImageBox"
require "components.AutoSizeText"
require "components.ProgressBar"
local widget = require "widget"

InjuryItemRenderer = {}

function InjuryItemRenderer:new(layoutWidth, layoutHeight)

	local view = display.newGroup()
	view.classType = "InjuryItemRenderer"
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

		local descriptionField = AutoSizeText:new(self)
		self.descriptionField = descriptionField
		descriptionField:setTextColor(200, 0, 0)
		descriptionField.x = titleField.x
		descriptionField.y = titleField.y + titleField.height
		descriptionField:setText("---")
		descriptionField:setFontSize(9)

		

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
		    onEvent = function(e) self:onTreatButtonTouched(e) end,
		}
		treatButton:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(treatButton)
		self.treatButton = treatButton
		treatButton.x = layoutWidth - (treatButton.width + MARGIN)
		treatButton.y = MARGIN

		descriptionField:setSize(layoutWidth - descriptionField.x - treatButton.width - MARGIN, layoutHeight, descriptionField.y)

		gameLoop:addLoop(self)
	end

	function view:setInjury(injuryVO)
		self.injuryVO = injuryVO

		if injuryVO == nil then return true end
		
		self.icon:loadImage(injuryVO.icon)
		self.titleField:setText(injuryVO.name)
	end

	function view:updateDescription()
		local injuryVO = self.injuryVO
		-- print("injuryVO:", injuryVO)
		local descriptionField = self.descriptionField
		if injuryVO == nil then
			descriptionField:setText("...")
			return true
		end
		-- print("weeeee")
		-- print(injuryVO:getStatus())
		descriptionField:setText(injuryVO:getStatus())
	end

	function view:tick(time)
		self:updateDescription()
		if self.injuryVO == nil then return true end
		local injuryVO = self.injuryVO

		if injuryVO.lifetime >= 0 then
			self.progressBar:setProgress(injuryVO.totalTimeAlive, injuryVO.lifetime)
			self.progressBar.isVisible = true
		else
			self.progressBar.isVisible = false
		end
	end

	function view:onTreatButtonTouched(event)
		if event.phase == "ended" then
			Runtime:dispatchEvent({name="onTreatInjury", 
				injuryVO=self.injuryVO})
		end
		return true
	end

	function view:showTreatButton(show)
		self.treatButton.isVisible = show
	end

	function view:destroy()
		if self.destroyed == true then return true end

		gameLoop:removeLoop(self)
		
		self.background:removeSelf()
		self.background = nil

		self.icon:removeSelf()
		self.icon = nil

		self.titleField:removeSelf()
		self.titleField = nil
		
		self.descriptionField:removeSelf()
		self.descriptionField = nil

		self.progressBar:removeSelf()
		self.progressBar = nil

		self.treatButton:removeSelf()
		self.treatButton = nil

		
		self.injuryVO = nil

		self.destroyed = true
	end

	view:init()


	return view
end

return InjuryItemRenderer