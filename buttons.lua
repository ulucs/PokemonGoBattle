return function()
local buttons = {}

buttons.drawStack = {}
buttons.updateStack = {}

function buttons.drawButton(label,x,y,width,height,scale)
	return function()
		love.graphics.push("all")
		love.graphics.setColor(0, 0, 0)
		love.graphics.polygon('fill', x ,y , (x+width) ,y , (x+width) ,(y+height) , x ,(y+height) )
		love.graphics.setColor(255, 255, 255)
		love.graphics.polygon('line', x ,y , (x+width) ,y , (x+width) ,(y+height) , x ,(y+height) )
		love.graphics.printf(label, x , (2*y+height-12) /2, width, 'center', 0, 1)
		love.graphics.pop()
	end
end

function buttons.isPressed(x,y,width,height,scale)
	return function(mouseX, mouseY)
		return mouseX > x  and mouseX < (x+width)  and
			mouseY > y  and mouseY < (y+height) 
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

function buttons:mousepressed(x,y,button,istouch)
	for _,v in ipairs(self.updateStack) do
		if v.condition(x,y) then
			v.result()
			return
		end
	end
end

return buttons
end