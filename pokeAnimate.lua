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