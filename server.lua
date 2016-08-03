return function()
local server = {}
server.socket = require('socket')

server.udp = nil

server.payload = nil
server.msgStack = {}
server.parsed = {A=nil,P=nil}

function server.pokeEncode(pokeObj)
	local str = "P:"
	return str..pokeObj.id.."a"..pokeObj.aIV.."d"..pokeObj.dIV.."s"..pokeObj.sIV.."h"..pokeObj.hp
end

function server.pokeDecode(pokestr)
	local pokeId, pokeA, pokeD, pokeS, pokeHP = string.match(pokestr,"(%d+)a(%d+)d(%d+)s(%d+)h(%d+)")
	return {id=tonumber(pokeId),aIV=tonumber(pokeA),dIV=tonumber(pokeD),sIV=tonumber(pokeS),hp=tonumber(pokeHP)}
end

function server:parser(data)
	local mtype, enum= data:match("([A-Z]):([adsh0-9]+)")
	if mtype and enum then
		self.parsed[mtype] = (mtype=='P') and self.pokeDecode(enum) or tonumber(enum)
	end
end

function server:load()
	self.udp = self.socket.udp()
	self.udp:settimeout(0.013)
	self.udp:setsockname('*', 3300)
end

function server:addPayload(str)
	self.payload = str
end

function server:update(dt)
	local data, msg_or_ip, port_or_nil = self.udp:receivefrom()
	if data then
		self:parser(data)
		if self.payload then
			self.udp:sendto(self.payload, msg_or_ip, port_or_nil)
			self.payload = nil
		else
			self.udp:sendto("r", msg_or_ip, port_or_nil)
		end
	end
end

return server
end