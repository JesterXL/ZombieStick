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
	print("statemachinetests.lua, runStateMachineTestsSucka running...")
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

function onIdle(event)
	print("onIdle")
end

function onAttack(event)
	print("onAttack")
end

function onMeleeAttack(event)
	print("onMeleeAttack")
end

function onSmash(event)
	print("onSmash")
end

function onPunch(event)
	print("onPunch")
end

function onMissle(event)
	print("onMissle")
end

function onDead(event)
	print("onDead")
end

function onDie(event)
	print("onDie")
end

function runHierarchicalStateMachineTestsSucka()
	
	print("statemachinetests.lua, runHierarchicalStateMachineTestsSucka running...")
	t = {}
	function t:onTransitionDenied(event)
		print("t::onTransitionDenied, event: ", event)
	end
	function t:onTransitionComplete(event)
		print("t::onTransitionComplete, event: ", event)
	end
	
	monsterSM = StateMachine:new()
	monsterSM:addState("idle",{enter = onIdle, from = "attack"})
	monsterSM:addState("attack",{enter = onAttack, from = "idle"})
	monsterSM:addState("melee attack",{parent = "attack", enter = onMeleeAttack, from = "attack"})
	monsterSM:addState("smash",{parent = "melee attack", enter = onSmash})
	monsterSM:addState("punch",{parent = "melee attack", enter = onPunch})
	monsterSM:addState("missle attack",{parent = "attack", enter = onMissle})
	monsterSM:addState("die",{enter = onDead, from = "attack", enter = onDie})
	
	monsterSM:addEventListener("onTransitionDenied", t)
	monsterSM:addEventListener("onTransitionComplete", t)
	
	monsterSM:setInitialState("idle")
	
	local foo = {}
	function foo:timer(event)
		local canSmash = monsterSM:canChangeStateTo("smash")
		print("canSmash: ", canSmash)
		monsterSM:changeState("smash")
	end
	
	timer.performWithDelay(1000, foo)
	
end



--runStateMachineTestsSucka()
runHierarchicalStateMachineTestsSucka()