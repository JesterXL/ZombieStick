
-- Warning: This class is treated as a Singleton at very bottom.

require "com.jxl.zombiestick.gamegui.levelviews.Crate"
require "com.jxl.zombiestick.gamegui.levelviews.Floor"
require "com.jxl.zombiestick.gamegui.levelviews.GrappleTarget"
require "com.jxl.zombiestick.gamegui.levelviews.Ledge"
require "com.jxl.zombiestick.gamegui.levelviews.Table"
require "com.jxl.zombiestick.gamegui.levelviews.Chair"
require "com.jxl.zombiestick.gamegui.levelviews.Firehose"
require "com.jxl.zombiestick.gamegui.levelviews.GenericSensor"

require "com.jxl.zombiestick.players.PlayerJXL"
require "com.jxl.zombiestick.players.PlayerFreeman"
require "com.jxl.zombiestick.players.weapons.SwordPolygon"

require "com.jxl.zombiestick.enemies.Zombie"

require "com.jxl.zombiestick.core.GameLoop"
require "com.jxl.zombiestick.states.level.PlayerFreemanState"
require "com.jxl.zombiestick.gamegui.CharacterSelectView"
require "com.jxl.zombiestick.gamegui.hud.HudControls"

LevelView = {}

function LevelView:new(x, y, width, height)

	assert(x, "You must pass in a valid x value.")
	assert(y, "You must pass in a valid x value.")
	assert(width, "You must pass in a valid x value.")
	assert(height, "You must pass in a valid x value.")
	
	local level = display.newGroup()
	level.classType = "LevelView"
	level.name = "level"
	level.player = nil
	level.backgroundImage = nil
	level.hudControls = nil
	
	level.gameLoop = GameLoop:new()
	
	local background = display.newRect(0, 0, width, height)
	background:setFillColor(255, 255, 255, 250)
	level:insert(background)
	level.background = background
	
	local levelChildren = display.newGroup()
	level:insert(levelChildren)
	level.levelChildren = levelChildren
	
	local buttonChildren = display.newGroup()
	level:insert(buttonChildren)
	level.buttonChildren = buttonChildren
	
	level.players = nil
	level.enemies = nil
	
	function level:insertChild(child)
		assert(child ~= nil, "Child cannot be nil.")
		assert(self.levelChildren ~= nil, "Cannot insert children because levelChildren is nil.")
		assert(self.levelChildren.insert ~= nil, "insert method cannot be nil.")
		self.levelChildren:insert(child)
	end
	
	function level:removeLevelChildren()
		self.levelChildren:removeSelf()
		self.player = nil
		self.backgroundImage = nil
		local newLevelChildren = display.newGroup()
		self:insert(newLevelChildren)
		self.levelChildren = newLevelChildren
		self.levelChildren:toBack()
		self.background:toBack()
	end
	
	function level:getButton(name, x, y)
		local button = display.newRect(0, 0, 32, 32)
		self.buttonChildren:insert(button)
		button.name = name
		button.strokeWidth = 1
		button:setFillColor(255, 0, 0, 100)
		button:setStrokeColor(255, 0, 0)
		button.x = x
		button.y = y
		return button
	end
	
	-- old
	--[[
	function level.scrollScreen()
			local self = level
		if self.player == nil then
			return
		end

		local lvlChildren = self.levelChildren
		local w = self.background.width
		local centerX = w / 2
		local centerY = lvlChildren.y
		local player = self.player
		local playerX, playerY = player:localToContent(0, 0)
		local currentOffsetX = playerX - lvlChildren.x
		local currentOffsetY = playerY - lvlChildren.y

		local deltaX = playerX - centerX
		local deltaY = playerY - centerY

		if true then
			if lvlChildren.x + -deltaX < 0 then
				lvlChildren.x = lvlChildren.x + -deltaX
			end
			return
		end

	end
		
	]]--
	
	-- new
	level.lastScrollTime = system.getTimer()
	function level.scrollScreen(event)
		local self = level
		if self.player == nil then
			return
		end
		
		local player = self.player
		local lvlChildren = self.levelChildren
		local w = self.background.width
		local centerX = w / 2
		local centerY = lvlChildren.y
		
		local playerX, playerY = player:localToContent(0, 0)
		local currentOffsetX = playerX - lvlChildren.x
		local currentOffsetY = playerY - lvlChildren.y
		local deltaX = playerX - centerX
		--local deltaY = playerY - centerY
		local deltaY = (-player.y + 170) - lvlChildren.y
		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
		local speed = 0.15
		local passed = system.getTimer() - self.lastScrollTime
		self.lastScrollTime = system.getTimer()
		local moveX = speed * (deltaX / dist) * passed
		local moveY = speed * (deltaY / dist) * passed
		
		moveX = math.round(moveX)
		moveY = math.round(moveY)
		
		--print("moveX: ", moveX, ", dist: ", dist)
		--print("player.y: ", player.y, ", lvlChildren.y: ", lvlChildren.y)
	--	if lvlChildren.x + -moveX < 0 then
			--lvlChildren.x = lvlChildren.x + -moveX
	--		lvlChildren.x = lvlChildren.x - deltaX
	--	end
		
		lvlChildren.x = lvlChildren.x - deltaX
		lvlChildren.y = -(player.y - 160)
	
	end
	
	function level:startScrolling()
		Runtime:addEventListener("enterFrame", self.scrollScreen)
	end
	
	function level:stopScrolling()
		Runtime:removeEventListener("enterFrame", self.scrollScreen)
	end

	function level:drawLevel(levelVO)
		assert(levelVO, "You cannot pass in a nil levelVO.")
		
		self:removeLevelChildren()
		self.players = {}
		self.enemies = {}
		
		self:setBackgroundImage(levelVO.backgroundImageShort)
		
		if self.hudControls == nil then
			print("telling HUD Controls to use width: ", width, ", and height: ", height)
			local hudControls = HudControls:new(width, height)
			self:insert(hudControls)
			hudControls:addEventListener("onLeftButtonTouch", self)
			hudControls:addEventListener("onRightButtonTouch", self)
			hudControls:addEventListener("onAttackButtonTouch", self)
			hudControls:addEventListener("onJumpButtonTouch", self)
			hudControls:addEventListener("onJumpLeftButtonTouch", self)
			hudControls:addEventListener("onJumpRightButtonTouch", self)
			self.hudControls = hudControls
		end
		
		local events = levelVO.events
		local i = 1
		while events[i] do
			local event = events[i]
			local type = event.type
			if type == "Terrain" then
				self:createTerrain(event)
			elseif type == "Player" then
				self:createPlayer(event)
			elseif type == "Enemy" then
				self:createEnemy(event)
			end
			i = i + 1
		end
		
		--self.background:toBack()
		--self.levelChildren:toFront()
		--self.buttonChildren:toFront()
		
		if self.characterSelectView == nil then
			local characterSelectView = CharacterSelectView:new(0, 0)
			self:insert(characterSelectView)
			characterSelectView:addEventListener("onSelectActivePlayer", self)
			self.characterSelectView = characterSelectView
		end
		self.characterSelectView:redraw(self.players)
		
		
		self:updateEnemyTargets()
		self.gameLoop:reset()
		self.gameLoop:start()
		
		self:setPlayer(self:getPlayerType("PlayerJXL"))
		self.hudControls.fsm:changeStateToAtNextTick("HudControlsJXL")
		self.player.fsm:changeStateToAtNextTick("ready")
	end
	
	function level:onLeftButtonTouch(event)
		local p = event.phase
		if p == "began" then
			Runtime:dispatchEvent({name = "onMoveLeftStarted", target = event.target})
			return true
		elseif p == "ended" or p == "cancelled" then
			Runtime:dispatchEvent({name = "onMoveLeftEnded", target = event.target})
			return true
		end
	end
	
	function level:onRightButtonTouch(event)
		local p = event.phase
		if p == "began" then
			Runtime:dispatchEvent({name = "onMoveRightStarted", target = event.target})
			return true
		elseif p == "ended" or p == "cancelled" then
			Runtime:dispatchEvent({name = "onMoveRightEnded", target = event.target})
			return true
		end
	end
	
	function level:onAttackButtonTouch(event)
		local p = event.phase
		if p == "began" then
			event.name = "onAttackStarted"
			self.player.lastAttackX = event.x
			self.player.lastAttackY = event.y
			Runtime:dispatchEvent(event)
			return true
		elseif p == "ended" or p == "cancelled" then
			Runtime:dispatchEvent({name = "onAttackEnded", target = event.target})
			return true
		end
	end
	
	function level:onJumpButtonTouch(event)
		local p = event.phase
		if p == "began" then
			Runtime:dispatchEvent({name = "onJumpStarted", target = event.target})
			return true
		elseif p == "ended" or p == "cancelled" then
			Runtime:dispatchEvent({name = "onJumpEnded", target = event.target})
			return true
		end
	end
	
	function level:onJumpLeftButtonTouch(event)
		local p = event.phase
		if p == "began" then
			Runtime:dispatchEvent({name = "onJumpLeftStarted", target = event.target})
			return true
		elseif p == "ended" or p == "cancelled" then
			Runtime:dispatchEvent({name = "onJumpLeftEnded", target = event.target})
			return true
		end
	end
	
	function level:onJumpRightButtonTouch(event)
		local p = event.phase
		if p == "began" then
			Runtime:dispatchEvent({name = "onJumpRightStarted", target = event.target})
			return true
		elseif p == "ended" or p == "cancelled" then
			Runtime:dispatchEvent({name = "onJumpRightEnded", target = event.target})
			return true
		end
	end
	
	function level:setBackgroundImage(filename)
		if filename ~= nil and filename ~= "" then
			local img = display.newImage(filename)
			if img ~= nil then
				level.backgroundImage = img
				self:insertChild(img)
			else
				error("img is null, filename is probably some long file path.")
			end
		else
			print("WARNING: LevelView::setBackgroundImage filename is nil.")
		end
	end
	
	function level:createTerrain(event)
		local terrainType = event.subType
		local terrain
		local params = {	x = event.x,
							y = event.y,
							width = event.width,
							height = event.height,
							rotation = event.rotation,
							density = event.density,
							friction = event.friction,
							bounce = event.bounce,
							ledgeExitDirection = event.ledgeExitDirection}
		if terrainType == "Crate" then
			terrain = Crate:new(params)
		elseif terrainType == "Floor" then
			params.name = "Floor"
			terrain = Floor:new(params)
		elseif terrainType == "Grapple Target" then
			params.name = "Grapple Target"
			terrain = GrappleTarget:new(params.x, params.y)
			function terrain:touch(event)
				if event.phase == "began" then
					level.player.lastGrappleTarget = self
					Runtime:dispatchEvent({name="onGrappleTargetTouched", target=self})
				end
			end
			terrain:addEventListener("touch", terrain)
		elseif terrainType == "Ledge" then
			params.name = "Ledge"
			terrain = Ledge:new(params.x, params.y, params.ledgeExitDirection)
		elseif terrainType == "Table" then
			terrain = Table:new(params)
		elseif terrainType == "Chair Left" then
			terrain = Chair:new(params, "left")
		elseif terrainType == "Chair Right" then
			terrain = Chair:new(params, "right")
		elseif terrainType == "Firehose" then
			terrain = Firehose:new(params)
			function terrain:collision(event)
				if event.other.name == "JXL" then
					event.other.lastFirehoseTarget = self
					event.other.fsm:changeStateToAtNextTick("firehose")
					return true
				end
			end
			terrain:addEventListener("collision", terrain)
		elseif terrainType == "Generic Sensor" then
			terrain = GenericSensor:new(params)
		end
		self:insertChild(terrain)
	end
	
	function level:createPlayer(event)
		local player
		local subType = event.subType
		local params = {x = event.x,
							y = event.y,
							density = event.density,
							friction = event.friction,
							bounce=event.bounce}
		if subType == "JesterXL" then
			player = PlayerJXL:new(params)
		elseif subType == "Freeman" then
			player = PlayerFreeman:new(params)
		end
		
		table.insert(self.players, player)
		
		if self.player == nil and player.classType == "PlayerJXL" then
			self:setPlayer(player)
		end
		self:insertChild(player)
		self.gameLoop:addLoop(player)
	end
	
	function level:setPlayer(target)
		assert(target ~= nil, "You cannot set player to a nil target.")
		self.player = target
		--[[
		if self.player.classType == "PlayerJXL" then
			level.fsm:changeState(PlayerJXLState:new(level))
		elseif self.player.classType == "PlayerFreeman" then
			level.fsm:changeState(PlayerFreemanState:new(level))
		end
		]]--
	end
	
	function level:getPlayerType(classType)
		local i = 1
		local players = self.players
		while players[i] do
			local player = players[i]
			if player.classType == classType then
				return player
			end
			i = i + 1
		end
		return nil
	end
	
	function level:onSelectActivePlayer(event)
		local freeman = self:getPlayerType("PlayerFreeman")
		local jxl = self:getPlayerType("PlayerJXL")
		if event.classType == "PlayerJXL" and (self.player ~= nil and self.player.classType ~= "PlayerJXL") then
			if freeman then
				freeman.fsm:changeState("idle")
			end
			self:setPlayer(jxl)
			self.hudControls.fsm:changeState("HudControlsJXL")
			self.player.fsm:changeStateToAtNextTick("ready")
		elseif event.classType == "PlayerFreeman" and (self.player ~= nil and self.player.classType ~= "PlayerFreeman") then
			if jxl then
				jxl.fsm:changeState("idle")
			end
			self:setPlayer(freeman)
			self.hudControls.fsm:changeState("HudControlsFreeman")
			self.hudControls:setFreemanWeapon(freeman.selectedWeapon)
			self.player.fsm:changeStateToAtNextTick("ready")
		end
	end
	
	function level:createEnemy(event)
		local zombie = Zombie:new()
		zombie.x = event.x
		zombie.y = event.y
		self:insertChild(zombie)
		table.insert(self.enemies, zombie)
		self.gameLoop:addLoop(zombie)
	end
	
	function level:updateEnemyTargets()
		local players = self.players
		if players == nil then
			return true
		end
		
		local enemies = self.enemies
		if enemies == nil then
			return true
		end
		
		local i = 1
		while enemies[i] do
			local enemy = enemies[i]
			enemy:setTargets(players)
			i = i + 1
		end
	end
	
	LevelView.instance = level
	
	return level
end


return LevelView