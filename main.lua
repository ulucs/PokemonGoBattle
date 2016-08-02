require('confs')
scene = require('loginScreen')()

function love.load()
	love.window.setMode(battleScene.width*scale,(battleScene.width*16/9)*scale,{vsync=false})
	math.randomseed(os.time())
	scene:load()
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
	scene = nil
	collectgarbage()
	scene = require(nextScene)()
	scene:load(params)
end

function love.mousepressed(x, y, button, istouch)
	if scene.mousepressed then
		scene:mousepressed(x,y,button,istouch)
	end
end

function love.mousereleased(x,y,button,istouch)
	if scene.mousereleased then
		scene:mousereleased(x,y,button,istouch)
	end
end

function love.textinput(t)
    if scene.textinput then
    	scene:textinput(t)
    end
end

function love.keypressed(key)
    if scene.keypressed then
    	scene:keypressed(key)
    end
end