return function()
local selectScreen = {remove=false,resultParams=nil}
selectScreen.buttons = require('buttons')()

function selectScreen:load()
	self.buttons:addButton("Server",battleScene.width*0.2,battleScene.width*0.4,battleScene.width*0.6,battleScene.width*0.4,scale,function()
		
			self.remove = true
			self.resultParams = {address="", mode="server"}
		end)
	self.buttons:addButton("Client",battleScene.width*0.2,battleScene.width*0.9,battleScene.width*0.6,battleScene.width*0.4,scale,function()
		
			self.remove = true
			self.resultParams = {address="localhost", mode="client"}
		end)

	self.serverIP = require('getIP')
end

function selectScreen:update(dt)
	
end

function selectScreen:draw()
	love.graphics.push("all")
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("Server IP:\n"..self.serverIP, 0,battleScene.width*0.1*scale, battleScene.width, 'center', 0, scale)
	love.graphics.pop()
	self.buttons:draw()
end

function selectScreen:close()
	return 'battleScene', self.resultParams
end

function selectScreen:mouseActions(x,y)
	self.buttons:mouseActions(x,y)
end

return selectScreen
end