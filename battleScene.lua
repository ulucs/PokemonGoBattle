return function()
local mainScene = {ourpokemon=playerPokemon,counter=nil,enemyCounter=nil,enemy=nil,friend=nil,attackTimer=0,network=nil,remove=false,resultParams=nil}
mainScene.animation = require('battleSceneAnimations')

noPokemon = 6

function mainScene:load(loadmode)
	self.network = require(loadmode.mode)()

	self.counter = 1
	self.enemyCounter = 1

	self.network:load(loadmode.address)

	self.enemy = self.animation:placeholderMon()
	self.friend = self.animation:friendPokemon(self.ourpokemon[self.counter])
	self.friend.attack = self.animation.outFromBall(self.friend)
	self.network:addPayload(self.network.pokeEncode(self.ourpokemon[self.counter]))
end

function mainScene:update(dt)
	local receiveCommands
	if not self.enemy.placeholder then
		receiveCommands = self.friend.battleReady and self.enemy.battleReady and not self.friend.fainted and not self.enemy.fainted
		-- own pokemon attacking logic
		if self.friend.attack then
			self.animation.moveAnimUpdate(self.friend, dt)
		-- own pokemon attacking logic
		elseif receiveCommands then
			if love.mouse.isDown(1) then
				self.attackTimer = self.attackTimer + dt
				if self.attackTimer > 0.5 then
					self.friend.attack = self.animation:strongAttack(self.friend, self.enemy, self.friend.move2)
					self.attackTimer = 0
	
					self.network:addPayload("A:"..self.friend.move2)
				end
			elseif self.attackTimer>0 then
				self.friend.attack = self.animation:strikeAttack(self.friend, self.enemy, self.friend.move1)
				self.attackTimer = 0
	
				self.network:addPayload("A:"..self.friend.move1)
			end
		end
	elseif self.enemyCounter>noPokemon and not self.friend.attack then
		self.resultParams = "Win"
		self.remove = true
		return   
	end

	-- own pokemon fainting logic
	if self.friend.fainted and not self.friend.attack then
		self.counter = self.counter+1
		if self.counter>noPokemon then
			if self.enemy.hp <=0 or self.enemy.placeholder then
				self.enemyCounter = self.enemyCounter+1
			end
			self.resultParams = self.enemyCounter>noPokemon and "Draw" or "Lose"
			self.remove = true
			return
		end
		self.friend = self.animation:friendPokemon(self.ourpokemon[self.counter])
		self.friend.attack = self.animation.outFromBall(self.friend)
		self.network:addPayload(self.network.pokeEncode(self.ourpokemon[self.counter]))
	elseif self.animation.checkFaint(self.friend) and not self.friend.attack then
		self.friend.attack = self.animation.returnToBall(self.friend)
		self.friend.fainted = true
	end

	self.network:update(dt)

	if not self.enemy.placeholder then
		-- enemy pokemon animation
		if self.enemy.attack then
			self.animation.moveAnimUpdate(self.enemy, dt)
		-- enemy pokemon fainting
		elseif self.enemy.fainted then
			self.enemy = self.animation:placeholderMon()
		elseif self.animation.checkFaint(self.enemy) then
			self.enemy.attack = self.animation.returnToBall(self.enemy)
			self.enemy.fainted = true
			self.enemyCounter = self.enemyCounter+1
		elseif receiveCommands and self.network.parsed['A'] then
			-- if attack data from opposite side
			if self.network.parsed['A'] > 199 then
				self.enemy.attack = self.animation:strikeAttack(self.enemy,self.friend,self.network.parsed['A'], self.friend.move2)
				self.network.parsed['A'] = nil
			elseif self.network.parsed['A'] < 200 then
				self.enemy.attack = self.animation:strongAttack(self.enemy,self.friend,self.network.parsed['A'], self.friend.move2)
				self.network.parsed['A'] = nil
			end
		end
		self.enemy.animation:update(dt)
	elseif self.enemy.placeholder and self.network.parsed['P'] then
		self.enemy = self.animation:enemyPokemon(self.network.parsed['P'])
		self.enemy.attack = self.animation.outFromBall(self.enemy)
		self.network.parsed['P'] = nil
	end
	self.friend.animation:update(dt)
end

function mainScene:draw()
	self.animation:drawBattleScene(battleScene.bg, self.enemy,self.friend)
	self.animation:drawHealthBars(self.enemy,self.friend)
	self.animation.drawUI()
end

function mainScene:close()
	local params = self.resultParams
	local towards = 'resultScene'
	return towards, params
end

return mainScene
end