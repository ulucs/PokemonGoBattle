require('confs')
require('pokeAnimate')
scene = require('battleScene')

function love.load()
	scene.load()
end

function love.update(dt)
	scene.update(dt)
end

function love.draw()
	scene.draw()
end