return function()
local selectScreen = {remove=false,resultParams=nil}
selectScreen.buttons = require('buttons')()
selectScreen.clientIP = ""

function selectScreen:load()
	love.keyboard.setKeyRepeat(true)
	self.buttons:addButton("Client",battleScene.width*0.2,battleScene.width*0.4,battleScene.width*0.6,battleScene.width*0.4,scale,function()
			self.remove = true
			if self.clientIP == "" then
				self.clientIP = "localhost"
			end
			self.resultParams = {address=self.clientIP, mode="client"}
		end)
	self.buttons:addButton("Server",battleScene.width*0.2,battleScene.width*0.9,battleScene.width*0.6,battleScene.width*0.4,scale,function()
			self.remove = true
			self.resultParams = {address="", mode="server"}
		end)

	self.serverIP = require('getIP')
end

function selectScreen:update(dt)
	
end

function selectScreen:draw()
	love.graphics.push("all")
	love.graphics.setColor(255, 255, 255)
	if love.keyboard.hasTextInput() then
		love.graphics.printf("Connect to:\n"..self.clientIP, 0,battleScene.width*0.1*scale, battleScene.width, 'center', 0, scale)
	end
	love.graphics.printf("Your server IP:\n"..self.serverIP, 0,battleScene.width*1.4*scale, battleScene.width, 'center', 0, scale)
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
		self.clientIP = self.clientIP..t
	end
end

function selectScreen:keypressed(key)
	if key == "backspace" then
		self.clientIP = string.sub(self.clientIP, 1, -2)
	end
end

return selectScreen
end