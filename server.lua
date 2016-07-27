socket = require('socket')
server = {}

server.udp = nil

server.payload = nil
server.msgStack = {}
server.parsed = {A=nil,P=nil}

function server:parser(data)
	print(data)
	local mtype, enum = data:match("([A-Z]):([0-9])")
	if mtype and enum then
		self.parsed[mtype] = tonumber(enum)
	end
end

function server:load()
	self.udp = socket.udp()
	self.udp:settimeout(0)
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
		end
	end

end

return server