require('battleSceneHelpers')
network = require('client')
local mainScene = {load=nil, update=nil, draw=nil}

mainScene.load = function()
	love.window.setMode(battleScene.width*scale,(battleScene.width*16/9)*scale,{vsync=false})

	math.randomseed(os.time())

	enemy = enemyPokemon(math.random(151))
	enemy.attack = outFromBall(enemy)
	friend = friendPokemon(math.random(151))
	friend.attack = outFromBall(friend)

	network:load()
end

mainScene.update = function(dt)
	local recieveCommands = friend.battleReady and enemy.battleReady and not friend.fainted and not enemy.fainted
	-- own pokemon attacking logic
	if friend.attack then
		moveAnimUpdate(friend, dt)
	-- own pokemon fainting logic
	elseif friend.fainted then
		friend = friendPokemon(math.random(151))
		friend.attack = outFromBall(friend)
	elseif checkFaint(friend) then
		friend.attack = returnToBall(friend)
		friend.fainted = true
	-- own pokemon attacking logic
	elseif recieveCommands then
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

	network:update(dt)

	-- enemy pokemon animation
	if enemy.attack then
		moveAnimUpdate(enemy, dt)
	-- enemy pokemon fainting
	elseif enemy.fainted then
		enemy = enemyPokemon(math.random(151))
		enemy.attack = outFromBall(enemy)
	elseif checkFaint(enemy) then
		enemy.attack = returnToBall(enemy)
		enemy.fainted = true
	elseif recieveCommands then
		-- if attack data from opposite side
		if network.parsed['A'] == 1 then
			enemy.attack = strikeAttack(enemy,friend)
			network.parsed = {}
		elseif network.parsed['A'] == 2 then
			enemy.attack = strongAttack(enemy,friend)
			network.parsed = {}
		end
	end
	enemy.animation:update(dt)
	friend.animation:update(dt)
end

mainScene.draw = function()
	drawBattleScene(battleScene.bg, enemy,friend)
	drawHealthBars(enemy,friend)
	drawUI()
end

return mainScene