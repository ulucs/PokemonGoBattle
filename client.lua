return function()
local client = {}
client.socket = require('socket')

local address = "ec2-52-87-243-27.compute-1.amazonaws.com"
local port = 3300

client.entity = nil
client.updaterate = 0.1

client.tcp = nil
client.t = nil

client.payload = ""
client.msgStack = {}
client.parsed = {A=nil,P=nil}

client.init = false

function client.pokeEncode(pokeObj)
	local str = "P:"
	return str..pokeObj.id.."a"..pokeObj.aIV.."d"..pokeObj.dIV.."s"..pokeObj.sIV.."h"..pokeObj.hp
end

function client.pokeDecode(pokestr)
	local pokeId, pokeA, pokeD, pokeS, pokeHP = string.match(pokestr,"(%d+)a(%d+)d(%d+)s(%d+)h(%d+)")
	return {id=tonumber(pokeId),aIV=tonumber(pokeA),dIV=tonumber(pokeD),sIV=tonumber(pokeS),hp=tonumber(pokeHP)}
end

function client:parser(data)
	local mtype, enum= data:match("([A-Z]):([adsh0-9]+)")
	if mtype and enum then
		self.init = true
		self.parsed[mtype] = (mtype=='P') and self.pokeDecode(enum) or tonumber(enum)
	end
end

function client:load(roomname)
	self.tcp = self.socket.tcp()
	self.tcp:settimeout(0.01)
	self.tcp:connect(address, port)
	self.tcp:send("R:"..roomname.."\r\n")

	self.t = 0
end

function client:addPayload(str)
	self.payload = str .. "\r\n"
end

function client:update(dt)
	self.t = self.t+dt
	if self.t>self.updaterate and self.payload then
		self.tcp:send(self.payload)
		self.t = 0
	end
	repeat
		local data, msg = self.tcp:receive()
		if data then
			print(data)
			self:parser(data)
			if self.init then
				self.payload = nil
			end
		end
	until not data
end

function client:close()
	self.tcp:shutdown("both")
end

return client
end