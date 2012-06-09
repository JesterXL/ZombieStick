require "com.jxl.core.statemachine.BaseState"
ReloadState = {}

function ReloadState:new()
	local state = BaseState:new("reload")
	local BULLET_LOAD_TIME = 100
	
	function state:onEnterState(event)
		print("ReloadState::onEnterState")
		local player = self.entity
		player.startReloadTime = 0
	end
	
	function state:onExitState(event)
		print("RestingState::onExitState")
		local player = self.entity
	end
	
	function state:tick(time)
		local player = self.entity
		player.startReloadTime = player.startReloadTime + time
		print("player.startReloadTime: ", player.startReloadTime, ", time: ", time)
		if player.startReloadTime >= BULLET_LOAD_TIME then
			if player:canReload() then
				player:setGunAmmo(player.gunAmmo + 1)
				if player.gunReloadSound == nil then
					player.gunReloadSound = audio.loadSound("sound-hk-reload.wav")
				end
				audio.play(player.gunReloadSound)
				player.startReloadTime = 0
				return true
			else
				if player.gunAmmo == player.MAX_GUN_AMMO then
					if player.gunClipInsertSound == nil then
						player.gunClipInsertSound = audio.loadSound("sound-hk-clip-insert.wav")
					end
					audio.play(player.gunClipInsertSound)
				end
				player.fsm:changeStateToAtNextTick("ready")
				return true
			end
		end
	end
	
	return state
end

return RestingState