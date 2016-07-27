require('confs')
scene = require('battleScene')

function love.load()
	love.window.setMode(battleScene.width*scale,(battleScene.width*16/9)*scale,{vsync=false})
	math.randomseed(os.time())
	scene:load("localhost")
end

function love.update(dt)
	if not scene.remove then
		scene:update(dt)
	else
		sceneTransfer()
	end
end

function love.draw()
	scene:draw()
end

function sceneTransfer()
	local nextScene, params = scene:close()
	scene = require(nextScene)
	scene:load(params)
end