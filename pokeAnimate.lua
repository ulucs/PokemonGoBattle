local anim8 = require('anim8')
require('spriteData')

-- forgive me lord for I have sinned
-- I should do some ""metaprogramming"" to set these data instances straight

function drawPokemon(pokemon)
	pokemon.animation:draw(pokemon.image, pokemon.x, pokemon.y, 0,scale*pokemon.scale,scale*pokemon.scale,pokemon.xo,pokemon.yo)
end

function pokeAnimate(pokeNumber)
	-- watch me fearlessly continue to sin
	local sprite = pokemonSizes[pokeNumber]
	local sheet = sheetSizes[pokeNumber]
	return anim8.newAnimation(
		(anim8.newGrid(sprite.X,sprite.Y, sheet.X,sheet.Y, 0,0,0))(
			'1-'..(sheet.X/sprite.X), '1-'..(sheet.Y/sprite.Y-1), 
			'1-'..sprite.frameNo-(sheet.X/sprite.X)*(sheet.Y/sprite.Y-1),
			sheet.Y/sprite.Y), 0.066)
end

function pokeImage(pokeNumber)
	local imageStr = string.format("pokemonSprites/front/%03d.png", pokeNumber)
	return love.graphics.newImage(imageStr)
end

function pokeOffset(pokeNumber)
	local sprite = pokemonOffsets[pokeNumber]
	return sprite[1], sprite[2]
end

function pokeAnimateBack(pokeNumber)
	-- watch me fearlessly continue to sin
	local sprite = pokemonSizesBack[pokeNumber]
	local sheet = sheetSizesBack[pokeNumber]
	return anim8.newAnimation(
		(anim8.newGrid(sprite.X,sprite.Y, sheet.X,sheet.Y, 0,0,0))(
			'1-'..(sheet.X/sprite.X), '1-'..(sheet.Y/sprite.Y-1), 
			'1-'..sprite.frameNo-(sheet.X/sprite.X)*(sheet.Y/sprite.Y-1),
			sheet.Y/sprite.Y), 0.066)
end

function pokeImageBack(pokeNumber)
	local imageStr = string.format("pokemonSprites/back/%03d.png", pokeNumber)
	return love.graphics.newImage(imageStr)
end

function pokeOffsetBack(pokeNumber)
	local sprite = pokemonOffsetsBack[pokeNumber]
	return sprite[1], sprite[2]
end

function enemyPokemon(Pid)
	local enemy = {hp=100, x=battleScene.width*0.75*scale, y=battleScene.height*0.425*scale, animation=nil, image=nil, id=Pid, scale=enemyScale, attack=nil, xo=nil, yo=nil, fainted=false, battleReady=false, placeholder=false}
	enemy.image = pokeImage(enemy.id)
	enemy.animation = pokeAnimate(enemy.id)
	enemy.xo, enemy.yo = pokeOffset(enemy.id)
	return enemy
end

function placeholderMon()
	local enemy = {hp=100, x=0, y=0, animation=nil, image=nil, id=1, scale=0, attack=nil, xo=nil, yo=nil, fainted=false, battleReady=false, placeholder = true}
	enemy.image = pokeImage(enemy.id)
	enemy.animation = pokeAnimate(enemy.id)
	enemy.xo, enemy.yo = 0,0
	return enemy
end

function friendPokemon(Pid)
	local friend = {hp=100, x=battleScene.width*0.3*scale, y=battleScene.height*0.83*scale, animation=nil, image=nil, id=Pid, scale=friendScale, attack=nil, xo=nil, yo=nil, fainted=false, battleReady=false, placeholder=false}
	friend.image = pokeImageBack(friend.id)
	friend.animation = pokeAnimateBack(friend.id)
	friend.xo, friend.yo = pokeOffsetBack(friend.id)
	return friend
end

function strikeAttack(attacker, attacked)
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
	attack.timeScale = 1
	attack.terminate = function()
		attacked.hp = attacked.hp-25
	end
	return attack
end

function strongAttack(attacker, attacked)
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
	attack.timeScale = 2
	attack.terminate = function()
		attacked.hp = attacked.hp-40
	end
	return attack
end

function returnToBall(attacked)
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
	attack.terminate = function() end
	return attack
end

function outFromBall(attacked)
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

function pauseAnim(attacked)
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

function moveAnimUpdate(attacker,dt)
	local attackAnim = attacker.attack
	attackAnim.ti = attackAnim.ti + dt/attackAnim.timeScale
	attacker.x = attackAnim.animationStart[1] + attackAnim.xScale*attackAnim.xPath(attackAnim.ti)
	attacker.y = attackAnim.animationStart[2] + attackAnim.yScale*attackAnim.yPath(attackAnim.ti)
	attacker.scale = attackAnim.animationStart[3] + attackAnim.scaleScale*attackAnim.scalePath(attackAnim.ti)
	if attackAnim.ti>=1 then
		attacker.x = attackAnim.animationEnd[1]
		attacker.y = attackAnim.animationEnd[2]
		attacker.scale = attackAnim.animationEnd[3]
		attackAnim.terminate()
		attacker.attack = nil
	end
end

function checkFaint(attacked)
	return attacked.hp<=0
end