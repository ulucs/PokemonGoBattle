return function()
local buttons = {}

buttons.drawStack = {}
buttons.updateStack = {}

function buttons.drawButton(label,x,y,width,height,scale)
	return function()
		love.graphics.push("all")
		love.graphics.setColor(0, 0, 0)
		love.graphics.polygon('fill', x*scale,y*scale, (x+width)*scale,y*scale, (x+width)*scale,(y+height)*scale, x*scale,(y+height)*scale)
		love.graphics.setColor(255, 255, 255)
		love.graphics.polygon('line', x*scale,y*scale, (x+width)*scale,y*scale, (x+width)*scale,(y+height)*scale, x*scale,(y+height)*scale)
		love.graphics.printf(label, x*scale, (2*y+height-12)*scale/2, width, 'center', 0, scale)
		love.graphics.pop()
	end
end

function buttons.isPressed(x,y,width,height,scale)
	return function(down, getX, getY)
		return down and getX > x*scale and getX < (x+width)*scale and
			getY > y*scale and getY < (y+height)*scale
	end
end

function buttons:addButton(label,x,y,width,height,scale,onClick)
	table.insert(self.drawStack,self.drawButton(label,x,y,width,height,scale))
	local mouseFunc = {}
	mouseFunc.condition = self.isPressed(x,y,width,height,scale)
	mouseFunc.result = onClick
	table.insert(self.updateStack,mouseFunc)
end

function buttons:draw()
	for _,v in ipairs(self.drawStack) do
		v()
	end
end

function buttons:update()
	for _,v in ipairs(self.updateStack) do
		if v.condition(love.mouse.isDown(1),love.mouse.getX(),love.mouse.getY()) then
			v.result()
			return
		end
	end
end

return buttons
end