require "components.ImageBox"
require "components.ProgressBar"
require "components.AutoSizeText"
CharacterView = {}

function CharacterView:new()
	local view = display.newGroup()

	function view:init()
		local image = ImageBox:new(self, 64, 64, "assets/images/character-portrait-jxl.jpg")
		self.image = image

		local healthText = AutoSizeText:new(self)
		self.healthText = healthText
		healthText:setSize(100, 11)
		healthText:setTextColor(0, 0, 0)
		healthText:setFontSize(11)
		healthText.x = image.x + image.width + 2

		local healthBar = ProgressBar:new(self, 100, 8, {50, 50, 50}, {200, 0, 200})
		self.healthBar = healthBar
		healthBar.x = healthText.x
		healthBar.y = healthText.y + healthText.height + 2

		local staminaText = AutoSizeText:new(self)
		self.staminaText = staminaText
		staminaText:setSize(100, 11)
		staminaText:setTextColor(0, 0, 0)
		staminaText:setFontSize(11)
		staminaText.x = healthBar.x
		staminaText.y = healthBar.y + healthBar.height + 2

		local staminaBar = ProgressBar:new(self, 100, 8, {50, 50, 50}, {0, 0, 255})
		self.staminaBar = staminaBar
		staminaBar.x = staminaText.x
		staminaBar.y = staminaText.y + staminaText.height + 2

		local stateField = AutoSizeText:new(self)
		self.stateField = stateField
		stateField:setSize(100, 20)
		stateField:setTextColor(0, 0, 0)
		stateField:setFontSize(11)
		stateField.x = staminaBar.x
		stateField.y = staminaBar.y + staminaBar.height + 2

		gameLoop:addLoop(self)
	end

	function view:setPlayer(player)
		self.player = player
	end

	function view:tick(time)
		if self.player == nil then return true end
		local player = self.player
		self.healthText:setText(player.health .. "/" .. player.maxHealth)
		self.healthBar:setProgress(player.health, player.maxHealth)
		self.staminaText:setText(player.stamina .. "/" .. player.maxStamina)
		self.staminaBar:setProgress(player.stamina, player.maxStamina)
		self.stateField:setText("State: " .. player.fsm.state)
	end

	view:init()

	return view
end

return CharacterView