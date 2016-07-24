require('confs')
require('pokeAnimate')

function love.load()
	love.graphics.setDefaultFilter('nearest','nearest')
	love.window.setMode(battleScene.width*scale,(battleScene.width*16/9)*scale,{vsync=false})

	bgimg = love.graphics.newImage('backgrounds/battle_background.png')
	math.randomseed(os.time())

	enemy = enemyPokemon(math.random(151))
	friend = friendPokemon(math.random(151))
end

function love.update(dt)
	enemy.animation:update(dt)
	friend.animation:update(dt)
end

function love.draw()
	drawBattleScene(bgimg, enemy,friend)
	drawHealthBars(enemy,friend)
	drawUI()
end

function drawBattleScene(bg, frPkmn, bkPkmn)
	love.graphics.draw(bg, 0, 0, 0, scale)
	if debug then
		love.graphics.print("FPS: "..love.timer.getFPS(), 0,0,0, scale) end

	frPkmn.animation:draw(frPkmn.image, frPkmn.x, frPkmn.y, 0,scale*enemyScale)
	bkPkmn.animation:draw(bkPkmn.image, bkPkmn.x, bkPkmn.y, 0,scale*friendScale)
end

function drawHealthBars(frPkmn, bkPkmn)
	love.graphics.push("all")
	love.graphics.setColor(60, 11, 11)
	love.graphics.polygon('fill', 0,healthbars.y*scale, battleScene.width*scale,healthbars.y*scale, battleScene.width*scale,(healthbars.y+healthbars.height)*scale, 0,(healthbars.y+healthbars.height)*scale)
	love.graphics.pop()

	love.graphics.print(pokemonNames[bkPkmn.id].."" , 5*scale, (healthbars.y+5)*scale, 0, scale)
	love.graphics.printf(pokemonNames[frPkmn.id].."", 0, (healthbars.y+22)*scale, battleScene.width-5, 'right', 0, scale)

	love.graphics.push("all")
	love.graphics.setColor(12, 244, 0)
	love.graphics.polygon('fill', 6*scale,(healthbars.y+24)*scale, 6*scale,(healthbars.y+34)*scale, (battleScene.width/2-16)*scale,(healthbars.y+34)*scale, (battleScene.width/2-16)*scale,(healthbars.y+24)*scale)
	love.graphics.polygon('fill', (battleScene.width-6)*scale,(healthbars.y+7)*scale, (battleScene.width-6)*scale,(healthbars.y+17)*scale, (battleScene.width/2+16)*scale,(healthbars.y+17)*scale, (battleScene.width/2+16)*scale,(healthbars.y+7)*scale)
	love.graphics.pop()


	love.graphics.printf("VS",0, (healthbars.y+14)*scale, battleScene.width, 'center', 0, scale)
end

function drawUI()
	love.graphics.push("all")
	love.graphics.setColor(11, 6, 57)
	love.graphics.polygon('fill', 0*scale,(ui.y+0)*scale, 0*scale,(ui.y+ui.height-0)*scale, (ui.width-0)*scale,(ui.y+ui.height-0)*scale, (ui.width-0)*scale,(ui.y+0)*scale)
	love.graphics.pop()
end
