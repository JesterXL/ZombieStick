TargetButton = {}

function TargetButton:new()

	
	local image = display.newImage("button-target.png")
	image:setReferencePoint(display.TopLeftReferencePoint)
	image.alpha = .5
	local stage = display.getCurrentStage()
	image.focused = false
	
	function image:touch(event)
		if event.phase == "began" then
			self.alpha = 1
			stage:setFocus( self, event.id )
			self.focused = true
			self.x = event.x - (self.width / 2)
			self.y = event.y - (self.height / 2)
		elseif self.focused and event.phase == "moved" then
			self.x = event.x - (self.width / 2)
			self.y = event.y - (self.height / 2)
		else
			self.alpha = .5
			self.focused = false
		end
	end
	
	function image:show()
		self.isVisible = true
		--Runtime:addEventListener("touch", image)
	end
	
	function image:hide()
		self.isVisible = false
		--Runtime:removeEventListener("touch", image)
	end
	
	
	image:hide()
	
	
	return image
	
end

return TargetButton