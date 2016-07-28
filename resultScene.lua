return function()
require('confs')
local resultScene = {remove=false}

function resultScene:load(result)
	self.result = result
end

function resultScene:update(dt)
	if love.mouse.isDown(1) then
		self.remove = true
	end
end

function resultScene:draw()
	local width = battleScene.width*scale
	local height = width*16/9
	love.graphics.setColor(0,0,0)
	love.graphics.polygon('fill', 0,0, width,0, width,height, 0,height )

	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("You "..self.result, 0, height/1.6/scale, width/scale, 'center', 0, scale)

	love.graphics.printf("Play again?", 0, height/scale, width/scale, 'center', 0, scale)
end

function resultScene.close()
	return 'selectMode', nil
end

return resultScene
end