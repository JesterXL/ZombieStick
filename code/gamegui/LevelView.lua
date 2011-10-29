require "gamegui.levelviews.Crate"
require "gamegui.levelviews.Floor"

require "players.PlayerJXL"
require "players.PlayerFreeman"

require "enemies.Zombie"

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
	
	local background = display.newRect(0, 0, width, height)
	background:setFillColor(255, 255, 255, 100)
	level:insert(background)
	level.background = background
	
	local levelChildren = display.newGroup()
	level:insert(levelChildren)
	level.levelChildren = levelChildren
	
	local buttonChildren = display.newGroup()
	level:insert(buttonChildren)
	level.buttonChildren = buttonChildren
	
	level.players = {}
	level.enemies = {}
	
	function level:insertChild(child)
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
	
	function level.onTouch(event)
		local target = event.target
		local player = level.player
		if player == nil then
			return
		end
		
		if event.phase == "began" then
			if target.name == "jump" then
				player:jump()
				return true
			elseif target.name == "jumpForward" then
				player:jumpForward()
				return true
			elseif target.name == "right" then
				player:moveRight()
				return true
			elseif target.name == "left" then
				player:moveLeft()
				return true
			end
		elseif event.phase == "ended" then
			if target.name == "strike" then
				player:strike()
				return true
			elseif target.name == "right" then
				player:stand()
				return true
			elseif target.name == "left" then
				player:stand()
				return true
			end
		end
	end

	function level:getButton(name, x, y)
		local button = display.newRect(0, 0, 32, 32)
		self.buttonChildren:insert(button)
		button.name = name
		button.strokeWidth = 1
		button:setFillColor(255, 0, 0, 100)
		button:setStrokeColor(255, 0, 0)
		button:addEventListener("touch", level.onTouch)
		button.x = x
		button.y = y
		return button
	end
	
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
	
	function level:startScrolling()
		Runtime:addEventListener("enterFrame", self.scrollScreen)
	end
	
	function level:stopScrolling()
		Runtime:removeEventListener("enterFrame", self.scrollScreen)
	end

	function level:drawLevel(levelVO)
		assert(levelVO, "You cannot pass in a nil levelVO.")
		
		self:removeLevelChildren()
		
		self:setBackgroundImage(levelVO.backgroundImageShort)
		
		if self.strikeButton == nil then
			print("making buttons")
			self.strikeButton = self:getButton("strike", 200, 100)
			self.rightButton = self:getButton("right", 240, 100)
			self.leftButton = self:getButton("left", 160, 100)
			self.jumpButton = self:getButton("jump", 200, 140)
			self.jumpForward = self:getButton("jumpForward", 240, 140)
		end
		
		local events = levelVO.events
		local i = 1
		while events[i] do
			local event = events[i]
			local type = event.type
			print("type: ", type)
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
		
		self:updateEnemyTargets()
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
							bounce = event.bounce}
		if terrainType == "Crate" then
			terrain = Crate:new(params)
		elseif terrainType == "Floor" then
			params.name = "Floor"
			terrain = Floor:new(params)
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
		
		print("player.classType: ", player.classType)
		if self.player == nil and player.classType == "PlayerJXL" then
			self.player = player
		end
		self:insertChild(player)
	end
	
	function level:createEnemy(event)
		local zombie = Zombie:new()
		zombie.x = 100
		zombie.y = 100
		self:insertChild(zombie)
		table.insert(self.enemies, zombie)
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
	
	return level
end


return LevelView