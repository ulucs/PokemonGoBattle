require('confs')

local resultScene = {}

function resultScene:load(result)
	self.result = result
end

function resultScene.update(dt)

end

function resultScene:draw()
	local width = battleScene.width
	local height = width*16/9
	love.graphics.setColor(0,0,0)
	love.graphics.polygon('fill', 0,0, width,0, width,height, 0,height )

	love.graphics.setColor(255, 255, 255)
	love.graphics.print("You "..self.result, width/2, height/2, 0, scale)
end

return resultScene