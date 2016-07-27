require('battleSceneHelpers')
network = require('client')
local mainScene = {load=nil, update=nil, draw=nil}

mainScene.load = function()
	love.window.setMode(battleScene.width*scale,(battleScene.width*16/9)*scale,{vsync=false})

	math.randomseed(os.time())

	ourpokemon = {}
	counter = 1
	for i=1,6 do
		table.insert(ourpokemon,math.random(151))
	end

	network:load()

	enemy = placeholderMon()
	friend = friendPokemon(ourpokemon[counter])
	friend.attack = outFromBall(friend)
	network:addPayload("P:"..ourpokemon[counter])
end

mainScene.update = function(dt)
	local receiveCommands
	if not enemy.placeholder then
		receiveCommands = friend.battleReady and enemy.battleReady and not friend.fainted and not enemy.fainted
		-- own pokemon attacking logic
		if friend.attack then
			moveAnimUpdate(friend, dt)
		-- own pokemon fainting logic
		elseif friend.fainted then
			counter = counter+1
			friend = friendPokemon(ourpokemon[counter])
			friend.attack = outFromBall(friend)
			network:addPayload("P:"..ourpokemon[counter])
		elseif checkFaint(friend) then
			friend.attack = returnToBall(friend)
			friend.fainted = true
		-- own pokemon attacking logic
		elseif receiveCommands then
			if love.mouse.isDown(1) then
				attackTimer = attackTimer + dt
				if attackTimer > 1 then
					friend.attack = strongAttack(friend, enemy)
					attackTimer = 0
	
					network:addPayload("A:2")
				end
			elseif attackTimer>0 then
				friend.attack = strikeAttack(friend, enemy)
				attackTimer = 0
	
				network:addPayload("A:1")
			end
		end
	end

	network:update(dt)

	if not enemy.placeholder then
		-- enemy pokemon animation
		if enemy.attack then
			moveAnimUpdate(enemy, dt)
		-- enemy pokemon fainting
		elseif enemy.fainted then
			enemy = placeholderMon()
		elseif checkFaint(enemy) then
			enemy.attack = returnToBall(enemy)
			enemy.fainted = true
		elseif receiveCommands then
			-- if attack data from opposite side
			if network.parsed['A'] == 1 then
				enemy.attack = strikeAttack(enemy,friend)
				network.parsed['A'] = nil
			elseif network.parsed['A'] == 2 then
				enemy.attack = strongAttack(enemy,friend)
				network.parsed['A'] = nil
			end
		end
		enemy.animation:update(dt)
	elseif enemy.placeholder and network.parsed['P'] then
		enemy = enemyPokemon(network.parsed['P'])
		enemy.attack = outFromBall(enemy)
		network.parsed['P'] = nil
	end
	friend.animation:update(dt)
end

mainScene.draw = function()
	drawBattleScene(battleScene.bg, enemy,friend)
	drawHealthBars(enemy,friend)
	drawUI()
end

return mainScene