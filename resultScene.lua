return function()
require('confs')
local resultScene = {remove=false}
resultScene.buttons = require('buttons')()

function resultScene:load(result)
	self.result = result
	self.buttons:addButton("Play again?", 0.2*battleScene.width, 0.8*battleScene.width, battleScene.width*0.6, 0.38*battleScene.width, scale, function()
		self.remove = true end)
end

function resultScene:update(dt)

end

function resultScene:draw()
	local width = battleScene.width*scale
	local height = width*16/9
	love.graphics.setColor(0,0,0)
	love.graphics.polygon('fill', 0,0, width,0, width,height, 0,height )

	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("You "..self.result, 0, height/1.6/scale, width/scale, 'center', 0, scale)

	self.buttons:draw()
end

function resultScene.close()
	return 'selectMode', nil
end

function resultScene:mousepressed(x,y)
	self.buttons:mousepressed(x,y)
end

return resultScene
end