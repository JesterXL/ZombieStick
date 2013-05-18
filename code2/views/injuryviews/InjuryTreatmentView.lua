require "views.injuryviews.InjuryItemRenderer"
require "views.injuryviews.FirstAidList"
local widget = require "widget"

InjuryTreatmentView = {}


function InjuryTreatmentView:new(layoutWidth, layoutHeight)
	local view = display.newGroup()
	view.classType = "InjuryTreatmentView"

	function view:init()
		local MARGIN = 4
		local MARGIN2 = MARGIN * 2

		local background = display.newRect(self, 0, 0, layoutWidth, layoutHeight)
		self.background = background
		background:setFillColor(255, 255, 255)
		background:setStrokeColor(0, 0, 0)
		background.strokeWidth = 1
		background:setReferencePoint(display.TopLeftReferencePoint)

		local injuryRenderer = InjuryItemRenderer:new(layoutWidth, 70)
		self:insert(injuryRenderer)
		injuryRenderer:showTreatButton(false)
		self.injuryRenderer = injuryRenderer

		local tabHolder = display.newRect(self, 0, 0, layoutWidth, 70)
		self.tabHolder = tabHolder
		tabHolder:setFillColor(255, 255, 255)
		tabHolder:setStrokeColor(0, 0, 0)
		tabHolder.strokeWidth = 2
		tabHolder:setReferencePoint(display.TopLeftReferencePoint)
		tabHolder.y = injuryRenderer.y + injuryRenderer.height

		local firstAidButton = widget.newButton
		{
		    left = 0,
		    top = 0,
		    width = 100,
		    height = 60,
		    id = "firstAidButton",
		    label = "First Aid",
		    onEvent = function(e) self:onTreatButtonTouched(event) end,
		}
		firstAidButton:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(firstAidButton)
		self.firstAidButton = firstAidButton
		firstAidButton.x = injuryRenderer.x + MARGIN
		firstAidButton.y = injuryRenderer.y + injuryRenderer.height + MARGIN

		local medicineButton = widget.newButton
		{
		    left = 0,
		    top = 0,
		    width = 100,
		    height = 60,
		    id = "medicineButton",
		    label = "Medicine",
		    onEvent = function(e) self:onTreatButtonTouched(event) end,
		}
		medicineButton:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(medicineButton)
		medicineButton.x = layoutWidth - (medicineButton.width + MARGIN)
		medicineButton.y = firstAidButton.y
		self.medicineButton = medicineButton

		local startY = firstAidButton.y + firstAidButton.height + MARGIN
		local firstAidList = FirstAidList:new(layoutWidth, layoutHeight - startY)
		self:insert(firstAidList)
		firstAidList.y = firstAidButton.y + firstAidButton.height + MARGIN
		self.firstAidList = firstAidList
		
		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function view:setInjury(injuryVO)
		self.injuryVO = injuryVO
		self.injuryRenderer:setInjury(injuryVO)
	end

	function view:destroy()
		if self.destroyed == true then return true end

		Runtime:dispatchEvent({name="onRobotlegsViewDestroyed", target=self})

		self.injuryVO = nil
		
		self.background:removeSelf()
		self.background = nil

		self.injuryRenderer:destroy()
		self.injuryRenderer:removeSelf()
		self.injuryRenderer = nil

		self.tabHolder:removeSelf()
		self.tabHolder = nil

		self.firstAidButton:removeSelf()
		self.firstAidButton = nil

		self.medicineButton:removeSelf()
		self.medicineButton = nil

		self.firstAidList:destroy()
		self.firstAidList:removeSelf()
		self.firstAidList = nil

		self.destroyed = true
	end


	view:init()

	return view
end

return InjuryTreatmentView