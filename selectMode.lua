return function()
local selectScreen = {remove=false,resultParams=nil}
selectScreen.buttons = require('buttons')()
selectScreen.roomName = ""

function selectScreen:load()
	love.keyboard.setKeyRepeat(true)
	self.buttons:addButton("Client",battleScene.width*0.2,battleScene.width*0.4,battleScene.width*0.6,battleScene.width*0.4,scale,function()
			self.remove = true
			if self.roomName == "" then
				self.roomName = "localhost"
			end
			self.resultParams = {address=self.roomName}
		end)
end

function selectScreen:update(dt)
	
end

function selectScreen:draw()
	love.graphics.push("all")
	love.graphics.setColor(255, 255, 255)
	if love.keyboard.hasTextInput() then
		love.graphics.printf("Connect to room:\n"..self.roomName, 0,battleScene.width*0.1 , battleScene.width, 'center', 0, 1)
	end
	love.graphics.pop()
	self.buttons:draw()
end

function selectScreen:close()
	love.keyboard.setKeyRepeat(false)
	return 'battleScene', self.resultParams
end

function selectScreen:mousepressed(x,y)
	self.buttons:mousepressed(x,y)
end

function selectScreen:textinput(t)
	-- try to put in emojis now, fuckers
	if string.len(t) == 1 then
		self.roomName = self.roomName..t
	end
end

function selectScreen:keypressed(key)
	if key == "backspace" then
		self.roomName = string.sub(self.roomName, 1, -2)
	end
end

return selectScreen
end