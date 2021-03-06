
-- Warning: This class is treated as a Singleton at very bottom.

require "com.jxl.zombiestick.gamegui.levelviews.Crate"
require "com.jxl.zombiestick.gamegui.levelviews.Floor"
require "com.jxl.zombiestick.gamegui.levelviews.GrappleTarget"
require "com.jxl.zombiestick.gamegui.levelviews.Ledge"
require "com.jxl.zombiestick.gamegui.levelviews.Table"
require "com.jxl.zombiestick.gamegui.levelviews.Chair"
require "com.jxl.zombiestick.gamegui.levelviews.Firehose"
require "com.jxl.zombiestick.gamegui.levelviews.GenericSensor"
require "com.jxl.zombiestick.gamegui.levelviews.WindowPiece"
require "com.jxl.zombiestick.gamegui.levelviews.Door"
require "com.jxl.zombiestick.gamegui.levelviews.Elevator"
require "com.jxl.zombiestick.gamegui.levelviews.ElevatorSwitch"

require "com.jxl.zombiestick.gamegui.hud.ElevatorControls"

require "com.jxl.zombiestick.players.PlayerJXL"
require "com.jxl.zombiestick.players.PlayerFreeman"
require "com.jxl.zombiestick.players.weapons.SwordPolygon"


require "com.jxl.zombiestick.enemies.Zombie"

require "com.jxl.zombiestick.core.GameLoop"
require "com.jxl.zombiestick.gamegui.CharacterSelectView"
require "com.jxl.zombiestick.gamegui.hud.HudControls"
require "com.jxl.zombiestick.gamegui.FloatingText"

require "com.jxl.zombiestick.mementos.LevelViewMemento"
require "com.jxl.zombiestick.services.SaveGameService"

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
	level.levelVO = nil
	level.players = nil
	level.enemies = nil
	level.movies = nil
	
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

	local floatingText = FloatingText:new()
	level:insert(floatingText)
	level.floatingText = floatingText
	
	
	
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

		self.levelVO = levelVO

		self.floatingText:init()
		self.players = {}
		Runtime:dispatchEvent({name="onLevelViewPlayersChanged", target=self, players=self.players})
		self.enemies = {}
		self.movies = {}
		
		self:setBackgroundImage(levelVO.backgroundImageShort)
		
		if self.hudControls == nil then
			local hudControls = HudControls:new(width, height)
			self:insert(hudControls)
			hudControls:addEventListener("onLeftButtonTouch", self)
			hudControls:addEventListener("onRightButtonTouch", self)
			hudControls:addEventListener("onAttackButtonTouch", self)
			hudControls:addEventListener("onJumpButtonTouch", self)
			hudControls:addEventListener("onJumpLeftButtonTouch", self)
			hudControls:addEventListener("onJumpRightButtonTouch", self)
			hudControls:addEventListener("onEnterButtonTouch", self)
			self.hudControls = hudControls
			self.gameLoop:addLoop(hudControls)
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
		
		self.movies = levelVO.movies
		
		Runtime:removeEventListener("onGenericSensorCollision", self)
		Runtime:addEventListener("onGenericSensorCollision", self)
		
		if self.characterSelectView == nil then
			local characterSelectView = CharacterSelectView:new(0, 0)
			self:insert(characterSelectView)
			characterSelectView:addEventListener("onSelectActivePlayer", self)
			self.characterSelectView = characterSelectView
		end
		self.characterSelectView:redraw(self.players)

		if self.saveGameButton == nil then
			local saveGameButton = display.newRect(0, 0, 60, 60)
			saveGameButton:setFillColor(255, 0, 0)
			function saveGameButton:touch(event)
				if event.phase == "began" then
					local service = SaveGameService:new()
					local result = service:save(level)
					native.showAlert("Save Game", "Game saved: " .. tostring(result), { "OK"})
					--Runtime:dispatchEvent({name="onSaveGame", target=self})

				end
			end
			saveGameButton:addEventListener("touch", saveGameButton)
			self:insert(saveGameButton)
			self.saveGameButton = saveGameButton
		end

		self:updateEnemyTargets()
		self.gameLoop:reset()
		self.gameLoop:start()
		
		-- [jwarden 6.9.2012] TODO: need to make this read from the level
		-- vs. manually updated setPlayer and hudControls state
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
	
	function level:onEnterButtonTouch(event)
		if event.phase == "began" then
			local enterButton = event.button
			local lc = self.levelChildren
			local n = lc.numChildren
			local i
			print("enterButton: ", enterButton)
			for i=1,n do
				local child = lc[i]
				print("name: ", child.name, ", enterButton.targetDoorName: ", enterButton.targetDoorName)
				if child.name ~= nil and child.name == enterButton.targetDoorName then
					print("child.anme: ", child.name, ", enterButton.targetDoorName: ", enterButton.targetDoorName)
					--print("*** px: ", self.player.x, ", py: ", self.player.y, ", cx: ", child.x, ", cy: ", child.y, ", classType: ", child.classType)
					self.player.x = child.x
					self.player.y = child.y
					return true
				end
			end
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
							ledgeExitDirection = event.ledgeExitDirection,
							customName = event.customName,
							targetDoor = event.targetDoor,
							targetMovie = event.targetMovie,
							targetElevator = event.targetElevator}
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
		elseif terrainType == "Window Piece" then
			terrain = WindowPiece:new(params)
		elseif terrainType == "Firehose" then
			terrain = Firehose:new(params)
			function terrain:collision(event)
				if event.other.classType == "PlayerJXL" then
					event.other.lastFirehoseTarget = self
					event.other.fsm:changeStateToAtNextTick("firehose")
					return true
				end
			end
			terrain:addEventListener("collision", terrain)
		elseif terrainType == "Generic Sensor" then
			terrain = GenericSensor:new(params)
		elseif terrainType == "Door" then
			terrain = Door:new(params)
		elseif terrainType == "Elevator" then
			Runtime:removeEventListener("onElevatorCollision", self)
			Runtime:addEventListener("onElevatorCollision", self)
			terrain = Elevator:new(params.x, params.y, params.height, self.levelChildren, params.customName)
			self.gameLoop:addLoop(terrain)
		elseif terrainType == "Elevator Switch" then
			Runtime:removeEventListener("onElevatorSwitchCollision", self)
			Runtime:addEventListener("onElevatorSwitchCollision", self)
			terrain = ElevatorSwitch:new(params)
		end
		terrain.gameObjectVO = event
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
		assert(player ~= nil, "Player cannot be nil.")
		player.gameObjectVO = event
		table.insert(self.players, player)
		Runtime:dispatchEvent({name="onLevelViewPlayersChanged", target=self, players=self.players})
		
		if self.player == nil and player.classType == "PlayerJXL" then
			self:setPlayer(player)
		end
		self:insertChild(player)
		self.gameLoop:addLoop(player)
	end
	
	function level:setPlayer(target)
		assert(target ~= nil, "You cannot set player to a nil target.")
		self.player = target
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
		zombie.gameObjectVO = event
		zombie:addEventListener("onZombieDestroyed", self)
		zombie.x = event.x
		zombie.y = event.y
		self:insertChild(zombie)
		table.insert(self.enemies, zombie)
		self.gameLoop:addLoop(zombie)
	end

	function level:onZombieDestroyed(event)
		event.target:removeEventListener("onZombieDestroyed", self)
		self.gameLoop:removeLoop(event.target)
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
	
	function level:onGenericSensorCollision(event)
		local sensor = event.target
		if sensor.targetMovie ~= nil and sensor.targetMovie ~= "" then
			local movies = self.movies
			local i = 1
			local movie
			while movies[i] do
				movie = movies[i]
				if movie.name == sensor.targetMovie then
					break
				end
				i = i + 1
			end
			
			if movie.played == true then
				return true
			end
			
			if movie.pause == true then
				self.gameLoop:pause()
				self.hudControls.isVisible = false
				self.characterSelectView.isVisible = false
				self.player.fsm:changeState("idle")
			end
			
			self.currentMovie = movie
			
			if self.moviePlayer == nil then
				local moviePlayer = MoviePlayerView:new()
				self.moviePlayer = moviePlayer
				moviePlayer:addEventListener("onMovieEnded", self)
				moviePlayer:startMovie(movie)
				self:insert(moviePlayer)
			end
			
		end
	end
	
	function level:createElevatorControls()
		if self.elevatorControls == nil then
			local elevatorControls = ElevatorControls:new()
			self.elevatorControls = elevatorControls
		--	elevatorControls.x = self.width - elevatorControls.width
		--	elevatorControls.y = 4
			elevatorControls:addEventListener("onUpElevatorButtonTouched", self)
			elevatorControls:addEventListener("onDownElevatorButtonTouched", self)
		end
	end
	
	function level:getElevatorByName(targetName)
		local i = 1
		local lc = self.levelChildren
		while lc[i] do
			local child = lc[i]
			if child and child.classType == "Elevator" and child.customName == targetName then
				return child
			end
			i = i + 1
		end
		return false
	end
	
	function level:onElevatorCollision(event)
		if event.phase == "began" then
			self.currentElevator = event.target
			self:createElevatorControls()
			self.elevatorControls.isVisible = true
		else
			if self.elevatorControls ~= nil then
				self.elevatorControls.isVisible = false
			end
			self.currentElevator = nil
		end	
	end
	
	function level:onElevatorSwitchCollision(event)
		if event.phase == "began" then
			self.currentElevator = self:getElevatorByName(event.target.targetElevator)
			self:createElevatorControls()
			self.elevatorControls.isVisible = true
		else
			if self.elevatorControls ~= nil then
				self.elevatorControls.isVisible = false
			end
			self.currentElevator = nil
		end
	end
	
	function level:onUpElevatorButtonTouched(event)
		print("LevelView::onUpElevatorButtonTouched")
		self.currentElevator:goUp()
	end
	
	function level:onDownElevatorButtonTouched(event)
		print("LevelView::onDownElevatorButtonTouched")
		self.currentElevator:goDown()
	end
	
	function level:onMovieEnded(event)
		if self.currentMovie.pause == true then
			self.gameLoop:start()
			self.hudControls.isVisible = true
			self.characterSelectView.isVisible = true
		end
		
		self.currentMovie.played = true
		
		self.currentMovie = nil
		
		self.player.fsm:changeState("ready")
	end

	function level:getTargetsAroundMe(item, distance)
		assert(item ~= nil, "You cannot pass a nil item.")
		assert(distance ~= nil, "You cannot pass a nil distance")
		local players = self.players
		if players == nil or #players < 1 then return nil end
		local targets = {}
		local i = 1
		local deltaX, deltaY, player, playerDistance
		while players[i] do
			local player = players[i]
			deltaX = item.x - target.x
			deltaY = item.y - target.y
			playerDistance = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
			if playerDistance <= distance then
				table.insert(targets, player)
			end
			i = i + 1
		end
		return targets
	end

	function level:getEnemiesAroundMe(player, distance)
		assert(player ~= nil, "You cannot pass a nil player.")
		assert(distance ~= nil, "You cannot pass a nil distance")
		local enemies = self.enemies
		if enemies == nil or #enemies < 1 then return nil end
		local targets = {}
		local i = 1
		local deltaX, deltaY, player, playerDistance
		local enemy = nil
		if distance > 0 then
			while enemies[i] do
				enemy = enemies[i]
				deltaX = enemy.x - target.x
				deltaY = enemy.y - target.y
				enemyDistance = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
				if enemyDistance <= distance then
					table.insert(targets, enemy)
				end
				i = i + 1
			end
		else
			while enemies[i] do
				enemy = enemies[i]
				deltaX = enemy.x - target.x
				deltaY = enemy.y - target.y
				enemyDistance = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
				table.insert(targets, {enemy = enemy, distance = enemyDistance, classType="Lua table"})
				i = i + 1
			end
		end
		return targets
	end

	function level:getEnemiesInFrontOfMe(player, distance)
		assert(player ~= nil, "You cannot pass a nil player.")
		assert(distance ~= nil, "You cannot pass a nil distance")
		local enemies = self.enemies
		if enemies == nil or #enemies < 1 then return nil end
		local targets = {}
		local i = 1
		local deltaX, deltaY, playerDistance
		local enemy = nil
		local direction = player.direction
		while enemies[i] do
			enemy = enemies[i]
			--print("e.x: ", enemy.x, ", p.x: ", player.x, ", diff: ", math.abs(player.x - enemy.x))
			--print("direction: ", direction)
			--print(enemy.x <= player.x)
			if (direction == "left" and enemy.x <= player.x) or (direction == "right" and enemy.x >= player.x) then
				--print("enemy.x: ", enemy.x, ", w: ", enemy.width, ", e.cw: ", enemy.contentWidth)
				deltaX = enemy.x - player.x
				deltaY = enemy.y - player.y
				enemyDistance = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
				--print("\tenemyDistance: ", enemyDistance)
				if enemyDistance <= distance then
					table.insert(targets, enemy)
				end
			end
			i = i + 1
		end
		return targets
	end

	function level:getMemento()
		local memento = LevelViewMemento:new()

		local screenShot = display.captureScreen(false)
		local baseDirectory = system.DocumentsDirectory
		local date = os.date()
		local fileName = "LevelView_" .. tostring(date) .. ".jpg"
		local result, err = display.save(self, fileName, baseDirectory)
		print("result: ", result, ", err: ", err)

		memento.iconImage 			= fileName
		memento.saveDate 			= date
		local gameObjectMementos 	= {}

		local levelChildren = self.levelChildren
		local len = levelChildren.numChildren
		for i=1,len do
			local child = levelChildren[i]
			--assert(child.gameObjectVO ~= nil, "Found a level child that doesn't have a GameObjectVO associated with it.")
			if child.gameObjectVO ~= nil then
				-- for now, just save x and y, in order found
				local childMemento = {x = child.x, y = child.y}
				table.insert(gameObjectMementos, childMemento)
			else
				print("no vo: ", child, ", classType: ", child.classType)
			end
		end
		memento.levelMemento = gameObjectMementos
		screenShot:removeSelf()

		return memento
	end

	function level:setMemento(levelMemento)

	end
	
	LevelView.instance = level
	
	return level
end


return LevelView