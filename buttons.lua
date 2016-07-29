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
	return function(mouseX, mouseY)
		return mouseX > x*scale and mouseX < (x+width)*scale and
			mouseY > y*scale and mouseY < (y+height)*scale
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

function buttons:mouseActions(x,y,button,istouch)
	for _,v in ipairs(self.updateStack) do
		if v.condition(x,y) then
			v.result()
			return
		end
	end
end

return buttons
end