return function()
local mainScene = {ourpokemon={},counter=nil,enemyCounter=nil,enemy=nil,friend=nil,network=nil,remove=false,resultParams=nil}
mainScene.animation = require('battleSceneAnimations')
mainScene.gui = require('Gspot')()

noPokemon = 6

function mainScene:load(loadmode)
	self.network = require(loadmode.mode)()

	self.counter = 1
	self.enemyCounter = 1
	self.currentMon = 0
	self.nextMon = nil
	self.nextAttack = nil

	self.network:load(loadmode.address)

	self.pokeButtons = {}
	self.pokeImages = {}
	self.calcPokeY = function(n)
		return ui.y+math.fmod(n,3)*37
	end
	self.calcPokeX = function(n)
		return math.floor((n-1)/3)*148
	end

	for i,v in ipairs(playerPokemon) do
		table.insert(self.ourpokemon, self.animation:friendPokemon(v))
		table.insert(self.pokeImages, love.graphics.newImage("pokemonSprites/icon/"..v.id..".png"))
		local pokeBtn = self.gui:button('', {x=self.calcPokeX(i)*scale, y=self.calcPokeY(i)*scale, w=32*scale, h=32*scale})
		pokeBtn.click = function (this,x,y)
			if self.ourpokemon[i]['hp'] > 0 and not self.friend.currentAnimation then
				self.nextMon = i
			end
		end
	end

	self.fastButton = self.gui:button('', {x=37*scale, y=(ui.y+16)*scale, w=106*scale, h=36*scale})
	self.fastButton.click = function(this,x,y)
		if not self.friend.currentAnimation then
			self.nextAttack = 1
		end
	end

	self.strongButton = self.gui:button('', {x=37*scale, y=(ui.y+62)*scale, w=106*scale, h=36*scale})
	self.strongButton.click = function(this,x,y)
		if not self.friend.currentAnimation then
			self.nextAttack = 2
		end
	end

	self.enemy = self.animation:placeholderMon()
	self.friend = self.animation:placeholderMon()
end

function mainScene:update(dt)
	local receiveCommands
	if not self.enemy.placeholder then
		receiveCommands = self.friend.battleReady and self.enemy.battleReady
		-- own pokemon attacking logic
		if self.friend.currentAnimation then
			self.animation.moveAnimUpdate(self.friend, dt)
		-- own pokemon attacking logic moved
		elseif receiveCommands and self.nextAttack then
			if self.nextAttack == 2 then
				self.friend.currentAnimation = self.animation:strongAttack(self.friend, self.enemy, self.friend.move2)
				self.network:addPayload("A:"..self.friend.move2)
			elseif self.nextAttack == 1 then
				self.friend.currentAnimation = self.animation:strikeAttack(self.friend, self.enemy, self.friend.move1)
				self.network:addPayload("A:"..self.friend.move1)
			end
			self.nextAttack = nil
		end
	elseif self.enemyCounter>noPokemon and not self.friend.currentAnimation then
		self.resultParams = "Win"
		self.remove = true
		return   
	end

	-- own pokemon fainting logic
	if self.friend.fainted and not self.friend.currentAnimation then
		if self.counter>noPokemon then
			if self.enemy.hp <=0 or self.enemy.placeholder then
				self.enemyCounter = self.enemyCounter+1
			end
			self.resultParams = self.enemyCounter>noPokemon and "Draw" or "Lose"
			self.remove = true
			return
		end
		self.friend = self.animation:placeholderMon()
		-- self.friend = self.animation:friendPokemon(self.ourpokemon[self.counter])
		-- self.friend.currentAnimation = self.animation.outFromBall(self.friend)
		-- self.network:addPayload(self.network.pokeEncode(self.ourpokemon[self.counter]))
	elseif self.animation.checkFaint(self.friend) and not self.friend.currentAnimation then
		self.counter = self.counter+1
		self.friend.currentAnimation = self.animation.returnToBall(self.friend)
		self.friend.fainted = true
	--sending out new pokemon
	elseif self.nextMon and self.friend.placeholder then
		self.currentMon = self.nextMon
		self.nextMon = nil
		self.friend = self.ourpokemon[self.currentMon]
		self.friend.currentAnimation = self.animation.outFromBall(self.friend)
		self.fastButton.label = self.animation.moveData[self.friend.move1]["moveName"]
		self.strongButton.label = self.animation.moveData[self.friend.move2]["moveName"]
		self.network:addPayload(self.network.pokeEncode(self.friend))
	elseif self.nextMon and not self.friend.currentAnimation then
		self.friend.currentAnimation = self.animation.returnToBall(self.friend)
		self.network:addPayload("W:1")
	end

	self.network:update(dt)

	if not self.friend.placeholder then
		if not self.enemy.placeholder then
			-- enemy pokemon animation
			if self.enemy.currentAnimation then
				self.animation.moveAnimUpdate(self.enemy, dt)
			-- enemy pokemon fainting
			elseif self.animation.checkFaint(self.enemy) then
				self.enemy.currentAnimation = self.animation.returnToBall(self.enemy)
				self.enemy.fainted = true
				self.enemyCounter = self.enemyCounter+1
			elseif receiveCommands and self.network.parsed['A'] then
				-- if attack data from opposite side
				if self.network.parsed['A'] > 199 then
					self.enemy.currentAnimation = self.animation:strikeAttack(self.enemy,self.friend,self.network.parsed['A'])
					self.network.parsed['A'] = nil
				elseif self.network.parsed['A'] < 200 then
					self.enemy.currentAnimation = self.animation:strongAttack(self.enemy,self.friend,self.network.parsed['A'])
					self.network.parsed['A'] = nil
				end
			elseif self.network.parsed['W'] then
				self.enemy.currentAnimation = self.animation.returnToBall(self.enemy)
				self.network.parsed['W'] = nil
			end
		elseif self.network.parsed['P'] then
			self.enemy = self.animation:enemyPokemon(self.network.parsed['P'])
			self.enemy.currentAnimation = self.animation.outFromBall(self.enemy)
			self.network.parsed['P'] = nil
		end
		-- oh wow
		-- it's really like I don't know how to use this
		if self.friend.scale == 0 then
			self.friend.scale = friendScale
		end
		self.friend.genericAnimation:update(dt)
	end
	if not self.enemy.placeholder then
		self.enemy.genericAnimation:update(dt)
	end
	self.gui:update(dt)
end

function mainScene:draw()
	self.animation:drawBattleScene(battleScene.bg, self.enemy,self.friend)
	self.animation:drawHealthBars(self.enemy,self.friend)
	-- self.animation:drawUI(self.ourpokemon,self.currentMon)
	self.gui:draw()
	for i,v in ipairs(self.ourpokemon) do
		love.graphics.push("all")
		if v.hp <= 0 then
			love.graphics.setColor(126, 126, 126) 
		end
		love.graphics.draw(self.pokeImages[i], self.calcPokeX(i)*scale, self.calcPokeY(i)*scale, 0, scale)
		love.graphics.pop()
	end
end

function mainScene:close()
	local params = self.resultParams
	local towards = 'resultScene'
	return towards, params
end

function mainScene:mousepressed(x,y,button,istouch)
	self.gui:mousepress(x, y, button)
end

function mainScene:mousereleased(x,y, button)
	self.gui:mouserelease(x, y, button)
end

return mainScene
end