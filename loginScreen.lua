playerPokemon = nil
return function()
require('confs')
local loginScreen = {remove=false,resultParams=nil}
loginScreen.gui = require('Gspot')()
loginScreen.login = require('mainServerConnect')

function loginScreen:load(params)
	self.username = self.gui:input('Username', {battleScene.width*0.4,battleScene.width*0.6,battleScene.width*0.5,20})
	self.password = self.gui:inputPassword('Password', {battleScene.width*0.4,battleScene.width*0.75,battleScene.width*0.5,20})
	self.loginButton = self.gui:button('Login', {x = battleScene.width*0.3 , y = battleScene.width*1.1 , w = battleScene.width*0.4 , h = 16 })
	self.loginButton.click = function (this, x, y)
		--playerPokemon = self.login(self.username.value,self.password.value)
		--print(playerPokemon[1]['id'])
		print(self.username.value)
		--self.remove = true
	end
end

function loginScreen:close()
	return 'selectMode'
end

function loginScreen:update(dt)
	self.gui:update(dt)
end

function loginScreen:draw()
	self.gui:draw()
end

function loginScreen:keypressed(key)
	if self.gui.focus then
		self.gui:keypress(key)
	end
end

function loginScreen:mousepressed(x,y, button)
	self.gui:mousepress(x, y, button)
end

function loginScreen:mousereleased(x,y, button)
	self.gui:mouserelease(x, y, button)
end

function loginScreen:textinput(key)
	if self.gui.focus then
		self.gui:textinput(key)
	end
end

return loginScreen

end