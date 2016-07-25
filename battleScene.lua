require('battleSceneHelpers')
local mainScene = {load=nil, update=nil, draw=nil}

mainScene.load = function()
	love.window.setMode(battleScene.width*scale,(battleScene.width*16/9)*scale,{vsync=false})

	math.randomseed(os.time())

	enemy = enemyPokemon(math.random(151))
	friend = friendPokemon(math.random(151))
end

mainScene.update = function(dt)
	enemy.animation:update(dt)
	friend.animation:update(dt)
	if friend.attack ~= nil then
		attackUpdate(friend, dt)
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
end

mainScene.draw = function()
	drawBattleScene(battleScene.bg, enemy,friend)
	drawHealthBars(enemy,friend)
	drawUI()
end

return mainScene