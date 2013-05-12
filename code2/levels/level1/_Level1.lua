require "physics"
local parallax = require( "utils.parallax" )

_Level1 = {}

function _Level1:new()
	local level = {}
	level.startX = 3200
	level.startY = 800
	level.parallaxScene = nil

	function level:build()
		self:destroy()

		local DIRECTORY_LEVEL = "levels/level1/"

		local level1PhysicsData = (require "levels.level1.level1").physicsData(1.0)
		local function getFloor(name)
			if x == nil then x = 0 end
			if y == nil then y = 0 end
			local floor = display.newImage("levels/level1/" .. name .. ".png", true)
			floor.classType = "Floor"
			mainGroup:insert(floor)
			floor:setReferencePoint(display.TopLeftReferencePoint)
			physics.addBody(floor, "static", level1PhysicsData:get(name) )
			floor.y = stage.height / 2 - floor.height / 2
			self[name] = name
			return floor
		end
		local floorA = getFloor("level1-a")

		local floorB = getFloor("level1-b")
		floorB.x = floorA.x + floorA.width
		floorB.y = 617

		local floorC = getFloor("level1-c")
		floorC.x = floorB.x + floorB.width
		floorC.y = 715

		local floorD = getFloor("level1-d")
		floorD.x = floorC.x + floorC.width
		floorD.y = 936

		local floorE = getFloor("level1-e")
		floorE.x = floorD.x + floorD.width
		floorE.y = 695
	end

	function level:destroy()
		if self.floorA then
			-- TODO: safe remove
			physics.removeBody(self.floorA)
			physics.removeBody(self.floorB)
			physics.removeBody(self.floorC)
			physics.removeBody(self.floorD)
			physics.removeBody(self.floorE)

			self.floorA:removeSelf()
			self.floorB:removeSelf()
			self.floorC:removeSelf()
			self.floorD:removeSelf()
			self.floorE:removeSelf()
		end
	end

	return level

end

return _Level1