local anim8 = require('anim8')
require('spriteData')

-- forgive me lord for I have sinned
-- I should do some ""metaprogramming"" to set these data instances straight

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

function pokePosition(pokeNumber,X,Y)
	local sprite = pokemonSizes[pokeNumber]
	return X-sprite.X*scale*enemyScale/2, Y-scale*enemyScale*sprite.Y
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

function pokePositionBack(pokeNumber,X,Y)
	local sprite = pokemonSizes[pokeNumber]
	return X-sprite.X*scale*friendScale/2, Y-scale*friendScale*sprite.Y
end

function enemyPokemon(Pid)
	local enemy = {hp=100, x=battleScene.width*0.75*scale, y=battleScene.height*0.425*scale, animation=nil, image=nil, id=Pid}
	enemy.image = pokeImage(enemy.id)
	enemy.animation = pokeAnimate(enemy.id)
	enemy.x, enemy.y = pokePosition(enemy.id,enemy.x,enemy.y)
	return enemy
end

function friendPokemon(Pid)
	local friend = {hp=100, x=battleScene.width*0.3*scale, y=battleScene.height*0.83*scale, animation=nil, image=nil, id=Pid}
	friend.image = pokeImageBack(friend.id)
	friend.animation = pokeAnimateBack(friend.id)
	friend.x, friend.y = pokePositionBack(friend.id,friend.x,friend.y)
	return friend
end