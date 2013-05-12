require "physics"
local parallax = require( "utils.parallax" )
require "sprites.Ladder"
require "sprites.Ledge"

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
		floorB.y = 459

		local floorC = getFloor("level1-c")
		floorC.x = floorB.x + floorB.width
		floorC.y = 555

		-- function floorC:preCollision(event)
		-- 	if event.other.classType == "PlayerJXL" then
		-- 		if event.other.climbing == true then
		-- 			event.contact.isEnabled = false
		-- 		end
		-- 	end
		-- end
		-- floorC:addEventListener("preCollision", floorC)

		local floorD = getFloor("level1-d")
		floorD.x = floorC.x + floorC.width
		floorD.y = 777

		local floorE = getFloor("level1-e")
		floorE.x = floorD.x + floorD.width
		floorE.y = 536

		local ladder1 = Ladder:new()
		self.ladder1 = ladder1
		ladder1.name = "ladder1"
		ladder1:toBack()
		ladder1.x = 1042
		ladder1.y = 570

		local ladder2 = Ladder:new()
		self.ladder2 = ladder2
		ladder2.name = "ladder2"
		ladder2:toBack()
		ladder2.x = 1740
		ladder2.y = 570

		local ledge1 = Ledge:new(2152, 704, "left")
		self.ledge1 = ledge1
		ledge1.name = "ledge1"

		local ledge2 = Ledge:new(1982, 564, "left")
		self.ledge2 = ledge2
		ledge2.name = "ledge2"

		local ledge3 = Ledge:new(1835, 464, "left")
		self.ledge3 = ledge3
		ledge3.name = "ledge3"
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