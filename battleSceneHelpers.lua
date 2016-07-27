function drawBattleScene(bg, frPkmn, bkPkmn)
	love.graphics.draw(bg, 0, 0, 0, scale)
	if debug then
		love.graphics.print("FPS: "..love.timer.getFPS(), 0,0,0, scale) end

	drawPokemon(frPkmn)
	drawPokemon(bkPkmn)
end

function drawHealthBars(frPkmn, bkPkmn)
	-- love.graphics.push("all")
	-- love.graphics.setColor(60, 11, 11)
	-- love.graphics.polygon('fill', 0,healthbars.y*scale, battleScene.width*scale,healthbars.y*scale, battleScene.width*scale,(healthbars.y+healthbars.height)*scale, 0,(healthbars.y+healthbars.height)*scale)
	-- love.graphics.pop()
	love.graphics.draw(healthbars.bg, 0, healthbars.y*scale, 0, healthbars.width*scale, healthbars.height*scale)

	love.graphics.print(pokemonNames[bkPkmn.id].."" , 5*scale, (healthbars.y+5)*scale, 0, scale)
	if not frPkmn.placeholder then
		love.graphics.printf(pokemonNames[frPkmn.id].."", 0, (healthbars.y+22)*scale, battleScene.width-6, 'right', 0, scale)
	end

	love.graphics.push("all")
	love.graphics.setColor(2.44*(100-bkPkmn.hp),2.44*bkPkmn.hp,0)
	love.graphics.polygon('fill', 6*scale,(healthbars.y+24)*scale, 6*scale,(healthbars.y+34)*scale, (battleScene.width/2-16)*scale,(healthbars.y+34)*scale, (battleScene.width/2-16)*scale,(healthbars.y+24)*scale)
	if debug then
		love.graphics.setColor(2.44*(100-frPkmn.hp),2.44*frPkmn.hp,0)
	end
	love.graphics.polygon('fill', (battleScene.width-6)*scale,(healthbars.y+7)*scale, (battleScene.width-6)*scale,(healthbars.y+17)*scale, (battleScene.width/2+16)*scale,(healthbars.y+17)*scale, (battleScene.width/2+16)*scale,(healthbars.y+7)*scale)
	love.graphics.pop()


	love.graphics.printf("VS",0, (healthbars.y+14)*scale, battleScene.width, 'center', 0, scale)
end

function drawUI()
	-- love.graphics.push("all")
	-- love.graphics.setColor(11, 6, 57)
	-- love.graphics.polygon('fill', 0*scale,(ui.y+0)*scale, 0*scale,(ui.y+ui.height-0)*scale, (ui.width-0)*scale,(ui.y+ui.height-0)*scale, (ui.width-0)*scale,(ui.y+0)*scale)
	-- love.graphics.pop()
	love.graphics.draw(ui.bg, 0, ui.y*scale, 0, scale)
end