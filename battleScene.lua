require('battleSceneHelpers')
local mainScene = {load=nil, update=nil, draw=nil}

mainScene.load = function()
	love.window.setMode(battleScene.width*scale,(battleScene.width*16/9)*scale,{vsync=false})

	math.randomseed(os.time())

	enemy = enemyPokemon(math.random(151))
	enemy.attack = outFromBall(enemy)
	friend = friendPokemon(math.random(151))
	friend.attack = outFromBall(friend)
end

mainScene.update = function(dt)
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
	elseif love.mouse.isDown(1) then
		attackTimer = attackTimer + dt
		if attackTimer > 1 then
			friend.attack = strongAttack(friend, enemy)
			attackTimer = 0
		end
	elseif attackTimer>0 then
		friend.attack = strikeAttack(friend, enemy)
		attackTimer = 0
	end

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
	else
		-- enemy pokemon attack "AI"
		enemy.attack = strikeAttack(enemy,friend)
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