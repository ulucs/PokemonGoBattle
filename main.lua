require('confs')
-- scene = require('loginScreen')()
-- I am so tired of logging in every time
scene = require('selectMode')()
playerPokemon = {{id=59,nickname='',aIV=14,dIV=13,sIV=14,move1=202,move2=95},{id=134,nickname='',aIV=15,dIV=13,sIV=3,move1=230,move2=107},{id=136,nickname='',aIV=15,dIV=13,sIV=10,move1=209,move2=24},{id=135,nickname='',aIV=15,dIV=11,sIV=9,move1=205,move2=35},{id=123,nickname='',aIV=15,dIV=12,sIV=13,move1=200,move2=51},{id=127,nickname='',aIV=15,dIV=1,sIV=15,move1=241,move2=100}}

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