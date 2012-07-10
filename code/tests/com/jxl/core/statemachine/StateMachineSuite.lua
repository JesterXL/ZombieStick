module(..., package.seeall)

function suite_setup()
	require "com.jxl.core.statemachine.State"
	require "com.jxl.core.statemachine.StateMachine"
	require "com.jxl.core.statemachine.BaseState"
end

function setup()
	machine = StateMachine:new()
end

function teardown()
	machine = nil
end

function test_classWorks()
	assert_not_nil(machine)
end

function test_verifyInitialStateIsNil()
	assert_nil(machine.state)
end

function test_verifyInitialStateIsNullWithStates()
	local initial = "playing"
	machine:addState(initial)
	machine:addState("stopped")
	assert_nil(machine.state)
end

function test_verifyInitialStateIsNotNil()
	local initial = "playing"
	machine:addState(initial)
	machine:addState("stopped")
	machine:setInitialState(initial)
	assert_equal(initial, machine.state)
end

function test_enter()
	local t = {}
	local hitCallback = false
	function t.onPlayingEnter(event)
		assert_equal(event.toState, "playing")
		assert_equal(event.fromState, "idle")
		hitCallback = true
	end
	machine:addState("idle")
	machine:addState("playing", { enter = t.onPlayingEnter, from="*"})
	machine:setInitialState("idle")
	assert_true(machine:canChangeStateTo("playing"), "Not alowed to change to state playing.")
	assert_true(machine:changeState("playing"))
	assert_equal("playing", machine.state)
	assert_true(hitCallback, "Didn't hit the onPlayingEnter callback.")
end

function test_preventInitialOnEnterEvent()
	local t = {}
	local hitCallback = false
	function t.onPlayingEnter(event)
		hitCallback = true
	end
	machine:addState("idle")
	machine:addState("playing", { enter = t.onPlayingEnter, from="*"})
	machine:setInitialState("idle")
	assert_false(hitCallback, "Hit the callback when I had no initial state set.")
end

function test_exit()
	local t = {}
	local hitCallback = false
	function t.onPlayingExit(event)
		hitCallback = true
	end
	machine:addState("idle", {exit = t.onPlayingExit})
	machine:addState("playing", {from="*"})
	machine:setInitialState("idle")
	machine:changeState("playing")
	assert_true(hitCallback, "Never called onPlayingExit.")
end

function test_ensurePathAcceptable()
	machine:addState("prone")
	machine:addState("standing", {from="*"})
	machine:addState("running", {from={"standing"}})
	machine:setInitialState("standing")
	assert_true(machine:changeState("running"), "Failed to ensure correct path.")
end

function test_ensurePathUnacceptable()
	machine:addState("prone")
	machine:addState("standing", {from="*"})
	machine:addState("running", {from={"standing"}})
	machine:setInitialState("prone")
	assert_false(machine:changeState("running"), "Failed to ensure correct path.")
end

function test_hierarchical()
	local t = {}
	local calledonAttack = false
	local calledOnMeleeAttack = false
	function t.onAttack(event)
		calledonAttack = true
	end

	function t.onMeleeAttack(event)
		calledOnMeleeAttack = true
	end

	machine:addState("idle", {from="*"})
	machine:addState("attack",{from = "idle", enter = t.onAttack})
	machine:addState("melee attack", {parent = "attack", from = "attack", enter = t.onMeleeAttack})
	machine:addState("smash",{parent = "melee attack", enter = t.onSmash})
	machine:addState("missle attack",{parent = "attack", enter = onMissle})

	machine:setInitialState("idle")

	assert_true(machine:canChangeStateTo("attack"), "Cannot change to state attack from idle!?")
	assert_false(machine:canChangeStateTo("melee attack"), "Somehow we're allowed to change to melee attack even though we're not in the attack base state.")
	assert_false(machine:changeState("melee attack"), "We're somehow allowed to bypass the attack state and go straigt into the melee attack state.")
	assert_true(machine:changeState("attack"), "We're not allowed to go to the attack state from the idle state?")
	assert_false(machine:canChangeStateTo("attack"), "We're allowed to change to a state we're already in?")
	assert_true(machine:canChangeStateTo("melee attack"), "We're not allowed to go to our child state melee attack from attack?")
	assert_true(machine:changeState("melee attack"), "I don't get it, we're in the parent attack state, why can't we change?")
	assert_true(machine:canChangeStateTo("smash"), "We're not allowed to go to our smash child state from our parent melee attack state?")
	
	assert_true(machine:canChangeStateTo("attack"), "We're not allowed to go back to our parent attack state?")
	assert_true(machine:changeState("smash"), "We're not allowed to actually change state to our smash child state.")
	assert_false(machine:changeState("attack"))
	assert_true(machine:changeState("melee attack"))
	assert_true(machine:canChangeStateTo("attack"))
	assert_true(machine:canChangeStateTo("smash"))
	assert_true(machine:changeState("attack"))
end

--[[
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

function runBaseStateTests()
	print("*** statemachinetests.lua, runBaseStateTests running...")
	
	
	local baseState = BaseState:new("idle")
	local attackState = BaseState:new("attack", nil, "idle")
	
	local stateMachine = StateMachine:new()
	stateMachine:addState2(baseState)
	stateMachine:addState2(attackState)
	
	stateMachine:setInitialState("idle")
	
	local foo = {}
	function foo:timer(event)
		print("--- can change to attack: ", stateMachine:canChangeStateTo("attack"))
		stateMachine:changeState("attack")
	end
	
	timer.performWithDelay(1000, foo)
end




--runStateMachineTestsSucka()
--runHierarchicalStateMachineTestsSucka()
runBaseStateTests()
]]--