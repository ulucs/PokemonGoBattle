return function()
local client = {}
client.socket = require('socket')

local port = 3300

client.entity = nil
client.updaterate = 0.2

client.udp = nil
client.t = nil

client.payload = ""
client.msgStack = {}
client.parsed = {A=nil,P=nil}

function client.pokeEncode(pokeObj)
	local str = "P:"
	return str..pokeObj.id.."a"..pokeObj.aIV.."d"..pokeObj.dIV.."s"..pokeObj.sIV
end

function client.pokeDecode(pokestr)
	local pokeId, pokeA, pokeD, pokeS = string.match(pokestr,"(%d+)a(%d+)d(%d+)s(%d+)")
	return {id=tonumber(pokeId),aIV=tonumber(pokeA),dIV=tonumber(pokeD),sIV=tonumber(pokeS)}
end

function client:parser(data)
	local mtype, enum= data:match("([A-Z]):([ads0-9]+)")
	if mtype and enum then
		self.parsed[mtype] = (mtype=='P') and self.pokeDecode(enum) or tonumber(enum)
	end
end

function client:load(address)
	self.udp = self.socket.udp()
	self.udp:settimeout(0.013)
	self.udp:setpeername(address, port)

	self.t = 0
end

function client:addPayload(str)
	self.payload = str
end

function client:update(dt)
	self.t = self.t+dt
	if self.t>self.updaterate then
		self.udp:send(self.payload)
		self.t = 0
	end
	repeat
		local data, msg = self.udp:receive()
		if data then
			self:parser(data)
			self.payload = "y"
		end
	until not data
end

return client
end