require "com.jxl.core.statemachine.State"
require "com.jxl.core.statemachine.StateMachine"

function onPlayingEnter(event)
	print("onPlayingEnter")
end

function onPlayingExit(event)
	print("onPlayingExit")
end

function onPausedEnter(event)
	print("onPausedEnter")
end

function onStoppedEnter(event)
	print("onStoppedEnter")
end

function runStateMachineTestsSucka()
	print("statemachinetests.lua, running...")
	t = {}
	function t:onTransitionDenied(event)
		print("t::onTransitionDenied, event: ", event)
	end
	function t:onTransitionComplete(event)
		print("t::onTransitionComplete, event: ", event)
	end
	
	playerSM = StateMachine:new()
	playerSM:addState("playing", { enter = onPlayingEnter, exit = onPlayingExit, from = {"paused","stopped"} })
	playerSM:addState("paused",{ enter = onPausedEnter, from = "playing"})
	playerSM:addState("stopped",{ enter = onStoppedEnter, from = "*"})
	
	playerSM:addEventListener("onTransitionDenied", t)
	playerSM:addEventListener("onTransitionComplete", t)

	playerSM:setInitialState("stopped")
	
	print("playerSM: ", playerSM)
	
end

runStateMachineTestsSucka()