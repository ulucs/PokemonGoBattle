local animations = {}

animations.anim8 = require('anim8')
animations.spriteData = require('spriteData')
animations.pokemonData = require('pokemonData')
animations.moveData = require('moveData')
animations.typeData = require('typeData')

function animations:damageFunc(attacker,attacked,move)
	local pokeAtt = (self.pokemonData[attacker.id]["attack"]+attacker.aIV)+5
	local pokeDef = (self.pokemonData[attacker.id]["defense"]+attacked.dIV)+5
	local superE = 1
	for i,v in ipairs(self.pokemonData[attacked.id]["types"]) do
		superE = superE * self.typeData.typeMultp[self.typeData.type2num[self.moveData[move]["type"]]][self.typeData.type2num[v]]
	end
	return math.floor(1.8*superE*pokeAtt/pokeDef*self.moveData[move]["power"])
end

function animations:pokemonHP(pokemon)
	return (self.pokemonData[pokemon.id]["hp"]+pokemon.sIV)+100
end

-- forgive me lord for I have sinned
-- I should do some ""metaprogramming"" to set these data instances straight

function animations.drawPokemon(pokemon)
	pokemon.genericAnimation:draw(pokemon.image, pokemon.x, pokemon.y, 0, pokemon.scale, pokemon.scale,pokemon.xo,pokemon.yo)
end

function animations:pokeAnimate(pokeNumber)
	-- watch me fearlessly continue to sin
	local sprite = self.spriteData.pokemonSizes[pokeNumber]
	local sheet = self.spriteData.sheetSizes[pokeNumber]
	return self.anim8.newAnimation(
		(self.anim8.newGrid(sprite.X,sprite.Y, sheet.X,sheet.Y, 0,0,0))(
			'1-'..(sheet.X/sprite.X), '1-'..(sheet.Y/sprite.Y-1), 
			'1-'..sprite.frameNo-(sheet.X/sprite.X)*(sheet.Y/sprite.Y-1),
			sheet.Y/sprite.Y), 0.066)
end

function animations.pokeImage(pokeNumber)
	local imageStr = string.format("pokemonSprites/front/%03d.png", pokeNumber)
	return love.graphics.newImage(imageStr)
end

function animations:pokeOffset(pokeNumber)
	local sprite = self.spriteData.pokemonOffsets[pokeNumber]
	return sprite[1], sprite[2]
end

function animations:pokeAnimateBack(pokeNumber)
	-- watch me fearlessly continue to sin
	local sprite = self.spriteData.pokemonSizesBack[pokeNumber]
	local sheet = self.spriteData.sheetSizesBack[pokeNumber]
	return self.anim8.newAnimation(
		(self.anim8.newGrid(sprite.X,sprite.Y, sheet.X,sheet.Y, 0,0,0))(
			'1-'..(sheet.X/sprite.X), '1-'..(sheet.Y/sprite.Y-1), 
			'1-'..sprite.frameNo-(sheet.X/sprite.X)*(sheet.Y/sprite.Y-1),
			sheet.Y/sprite.Y), 0.066)
end

function animations:pokeImageBack(pokeNumber)
	local imageStr = string.format("pokemonSprites/back/%03d.png", pokeNumber)
	return love.graphics.newImage(imageStr)
end

function animations:pokeOffsetBack(pokeNumber)
	local sprite = self.spriteData.pokemonOffsetsBack[pokeNumber]
	return sprite[1], sprite[2]
end

function animations:enemyPokemon(pokeObject)
	local enemy = {maxhp=self:pokemonHP(pokeObject), hp=pokeObject.hp, x=battleScene.width*0.75 , y=battleScene.height*0.425 , genericAnimation=nil, image=nil, id=pokeObject.id, aIV=pokeObject.aIV, dIV=pokeObject.dIV, scale=enemyScale, currentAnimation=nil, xo=nil, yo=nil, fainted=false, recall=false, battleReady=false}
	enemy.image = self.pokeImage(enemy.id)
	enemy.genericAnimation = self:pokeAnimate(enemy.id)
	enemy.xo, enemy.yo = self:pokeOffset(enemy.id)
	return enemy
end

function animations:placeholderMon()
	local enemy = {maxhp=100, hp=100, x=0, y=0, genericAnimation=nil, image=nil, id=1, scale=0, currentAnimation=nil, xo=nil, yo=nil, fainted=false, recall=false, battleReady=false, placeholder = true}
	enemy.image = self.pokeImage(enemy.id)
	enemy.genericAnimation = self:pokeAnimate(enemy.id)
	enemy.xo, enemy.yo = 0,0
	return enemy
end

function animations:friendPokemon(pokeObject)
	local friend = {maxhp=self:pokemonHP(pokeObject), hp=self:pokemonHP(pokeObject), x=battleScene.width*0.3 , y=battleScene.height*0.83 , genericAnimation=nil, image=nil, id=pokeObject.id, move1=pokeObject.move1, move2=pokeObject.move2, aIV=pokeObject.aIV, dIV=pokeObject.dIV, sIV=pokeObject.sIV, scale=friendScale, currentAnimation=nil, xo=nil, yo=nil, fainted=false, recall=false, battleReady=false}
	friend.image = self:pokeImageBack(friend.id)
	friend.genericAnimation = self:pokeAnimateBack(friend.id)
	friend.xo, friend.yo = self:pokeOffsetBack(friend.id)
	return friend
end

function animations:strikeAttack(attacker, attacked, moveno)
	local move = self.moveData[moveno]
	local attack = {ti=nil, xPath=nil, yPath=nil, scalePath=nil, xScale=nil, yScale=nil, scaleScale=nil, animationStart=nil, timeScale=nil, terminate=nil}
	attack.ti = 0
	attack.xPath = lambda('t','t<0.5 and 8*t^3 or 8*(1-t)^3')
		--function(t) if t<0.5 then return 8*t^3 else return 8*(1-t)^3 end end
	attack.yPath = attack.xPath
	attack.scalePath = attack.xPath
	attack.xScale = 0.6*(-attacker.x+attacked.x)
	attack.yScale = 0.6*(-attacker.y+attacked.y)
	attack.scaleScale = 0.6*(-attacker.scale+attacked.scale)
	attack.animationStart = {attacker.x,attacker.y,attacker.scale}
	attack.animationEnd = {attacker.x,attacker.y,attacker.scale}
	attack.timeScale = move.duration
	attack.terminate = function()
		attacked.hp = attacked.hp - self:damageFunc(attacker,attacked,moveno)
	end
	return attack
end

function animations:strongAttack(attacker, attacked, moveno)
	local move = self.moveData[moveno]
	local attack = {ti=nil, xPath=nil, yPath=nil, scalePath=nil, xScale=nil, yScale=nil, scaleScale=nil, animationStart=nil, timeScale=nil, terminate=nil}
	attack.ti = 0
	attack.xPath = lambda('t','t<0.5 and 8*t^3 or 2*(1-t)')
		--function(t) if t<0.5 then return 8*t^3 else return 2*(1-t) end end
	attack.yPath = attack.xPath
	attack.scalePath = attack.xPath
	attack.xScale = 0.8*(-attacker.x+attacked.x)
	attack.yScale = 0.8*(-attacker.y+attacked.y)
	attack.scaleScale = 0.8*(-attacker.scale+attacked.scale)
	attack.animationStart = {attacker.x,attacker.y,attacker.scale}
	attack.animationEnd = {attacker.x,attacker.y,attacker.scale}
	attack.timeScale = move.duration
	attack.terminate = function()
		attacked.hp = attacked.hp - self:damageFunc(attacker,attacked,moveno)
	end
	return attack
end

function animations.returnToBall(attacked)
	attacked.battleReady = false

	local attack = {ti=nil, xPath=nil, yPath=nil, scalePath=nil, xScale=nil, yScale=nil, scaleScale=nil, animationStart=nil, timeScale=nil, terminate=nil}
	attack.ti = 0
	attack.xPath = lambda('t','t')
	attack.yPath = attack.xPath
	attack.scalePath = lambda('t','t^2')
	attack.xScale = 0
	attack.yScale = 0
	attack.scaleScale = -attacked.scale
	attack.animationStart = {attacked.x,attacked.y,attacked.scale}
	attack.animationEnd = {attacked.x,attacked.y,0}
	attack.timeScale = 1
	attack.terminate = function() attacked.placeholder = true end
	return attack
end

function animations.outFromBall(attacked)
	attacked.placeholder = false

	local attack = {ti=nil, xPath=nil, yPath=nil, scalePath=nil, xScale=nil, yScale=nil, scaleScale=nil, animationStart=nil, timeScale=nil, terminate=nil}
	attack.ti = 0
	attack.xPath = lambda('t','t')
	attack.yPath = attack.xPath
	attack.scalePath = lambda('t','t')
	attack.xScale = 0
	attack.yScale = 0
	attack.scaleScale = attacked.scale
	attack.animationStart = {attacked.x,attacked.y,0}
	attack.animationEnd = {attacked.x,attacked.y,attacked.scale}
	attack.timeScale = 1
	attack.terminate = function() attacked.battleReady = true end
	return attack
end

function animations.pauseAnim(attacked)
	local attack = {ti=nil, xPath=nil, yPath=nil, scalePath=nil, xScale=nil, yScale=nil, scaleScale=nil, animationStart=nil, timeScale=nil, terminate=nil}
	attack.ti = 0
	attack.xPath = lambda('','0')
	attack.yPath = attack.xPath
	attack.scalePath = lambda('','0')
	attack.xScale = 0
	attack.yScale = 0
	attack.scaleScale = attacked.scale
	attack.animationStart = {attacked.x,attacked.y,attacked.scale}
	attack.animationEnd = {attacked.x,attacked.y,attacked.scale}
	attack.timeScale = 0.5
	attack.terminate = function() end
	return attack
end

function animations.moveAnimUpdate(attacker,dt)
	local attackAnim = attacker.currentAnimation
	attackAnim.ti = attackAnim.ti + dt/attackAnim.timeScale
	attacker.x = attackAnim.animationStart[1] + attackAnim.xScale*attackAnim.xPath(attackAnim.ti)
	attacker.y = attackAnim.animationStart[2] + attackAnim.yScale*attackAnim.yPath(attackAnim.ti)
	attacker.scale = attackAnim.animationStart[3] + attackAnim.scaleScale*attackAnim.scalePath(attackAnim.ti)
	if attackAnim.ti>=1 then
		attacker.x = attackAnim.animationEnd[1]
		attacker.y = attackAnim.animationEnd[2]
		attacker.scale = attackAnim.animationEnd[3]
		attackAnim.terminate()
		attacker.currentAnimation = nil
	end
end

function animations.checkFaint(attacked)
	return attacked.hp<=0
end

function animations:drawBattleScene(bg, frPkmn, bkPkmn)
	love.graphics.draw(bg, 0, 0, 0, 1)
	if debug then
		love.graphics.print("FPS: "..love.timer.getFPS(), 0,0,0, 1) end

	self.drawPokemon(frPkmn)
	self.drawPokemon(bkPkmn)
end

function animations:drawHealthBars(frPkmn, bkPkmn)
	-- love.graphics.push("all")
	-- love.graphics.setColor(60, 11, 11)
	-- love.graphics.polygon('fill', 0,healthbars.y , battleScene.width ,healthbars.y , battleScene.width ,(healthbars.y+healthbars.height) , 0,(healthbars.y+healthbars.height) )
	-- love.graphics.pop()
	love.graphics.draw(healthbars.bg, 0, healthbars.y , 0, healthbars.width , healthbars.height )

	if not bkPkmn.placeholder then
	love.graphics.print(self.spriteData.pokemonNames[bkPkmn.id].."" , 5 , (healthbars.y+5) , 0, 1)
	end
	if not frPkmn.placeholder then
		love.graphics.printf(self.spriteData.pokemonNames[frPkmn.id].."", 0, (healthbars.y+22) , battleScene.width-6, 'right', 0, 1)
	end

	love.graphics.push("all")
	love.graphics.setColor(244*(1-bkPkmn.hp/bkPkmn.maxhp),244*bkPkmn.hp/bkPkmn.maxhp,0)
	love.graphics.polygon('fill', 6 ,(healthbars.y+24) , 6 ,(healthbars.y+34) , (battleScene.width/2-16) ,(healthbars.y+34) , (battleScene.width/2-16) ,(healthbars.y+24) )
	love.graphics.setColor(255, 255, 255)
	if not bkPkmn.placeholder then
		love.graphics.printf(math.max(bkPkmn.hp,0).."/"..bkPkmn.maxhp, 6 , (healthbars.y+23) , (battleScene.width/2-22), 'center', 0, 1)
	end
	love.graphics.setColor(244*(1-frPkmn.hp/frPkmn.maxhp),244*frPkmn.hp/frPkmn.maxhp,0)
	love.graphics.polygon('fill', (battleScene.width-6) ,(healthbars.y+7) , (battleScene.width-6) ,(healthbars.y+17) , (battleScene.width/2+16) ,(healthbars.y+17) , (battleScene.width/2+16) ,(healthbars.y+7) )
	love.graphics.pop()


	love.graphics.printf("VS",0, (healthbars.y+14) , battleScene.width, 'center', 0, 1)
end

function animations:drawUI(ourpokemon,currentMon)
	-- love.graphics.push("all")
	-- love.graphics.setColor(11, 6, 57)
	-- love.graphics.polygon('fill', 0 ,(ui.y+0) , 0 ,(ui.y+ui.height-0) , (ui.width-0) ,(ui.y+ui.height-0) , (ui.width-0) ,(ui.y+0) )
	-- love.graphics.pop()
	-- love.graphics.draw(ui.bg, 0, ui.y , 0, 1)
end

return animations