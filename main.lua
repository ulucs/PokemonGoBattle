require('confs')
require('pokeAnimate')

function love.load()
	love.graphics.setDefaultFilter('nearest','nearest')
	love.window.setMode(battleScene.x*scale,(battleScene.y+ui.y)*scale,{vsync=false})

	bgimg = love.graphics.newImage('backgrounds/battle_background.png')
	math.randomseed(os.time())

	enemy = {hp=100, x=battleScene.x*0.75*scale, y=battleScene.y*0.425*scale, animation=nil, image=nil, id=math.random(151)}
	enemy.image = pokeImage(enemy.id)
	enemy.animation = pokeAnimate(enemy.id)
	enemy.x, enemy.y = pokePosition(enemy.id,enemy.x,enemy.y)

	friend = {hp=100, x=battleScene.x*0.3*scale, y=battleScene.y*0.83*scale, animation=nil, image=nil, id=math.random(151)}
	friend.image = pokeImageBack(friend.id)
	friend.animation = pokeAnimateBack(friend.id)
	friend.x, friend.y = pokePositionBack(friend.id,friend.x,friend.y)
end

function love.update(dt)
	enemy.animation:update(dt)
	friend.animation:update(dt)
end

function love.draw()
	drawBattleScene(bgimg, enemy,friend)
end

function drawBattleScene(bg, frPkmn, bkPkmn)
	love.graphics.draw(bg, 0, 0, 0, scale)
	if debug then
		love.graphics.print("FPS: "..love.timer.getFPS(), 1, 1) end

	frPkmn.animation:draw(frPkmn.image, frPkmn.x, frPkmn.y, 0,scale*enemyScale)
	bkPkmn.animation:draw(bkPkmn.image, bkPkmn.x, bkPkmn.y, 0,scale*friendScale)
end