socket = require('socket')
client = {}
local port = 3300

client.entity = nil
client.updaterate = 0.1

client.udp = nil
client.t = nil

client.payload = ""
client.msgStack = {}
client.parsed = {A=nil,P=nil}

function client:parser(data)
	print(data)
	local mtype, enum = data:match("([A-Z]):([0-9]+)")
	if mtype and enum then
		self.parsed[mtype] = tonumber(enum)
	end
end

function client:load(address)
	self.udp = socket.udp()
	self.udp:settimeout(0)
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
		self.payload = "y"
		self.t = 0
	end
	repeat
		local data, msg = self.udp:receive()
		if data then
			self:parser(data)
		end
	until not data
end

return client