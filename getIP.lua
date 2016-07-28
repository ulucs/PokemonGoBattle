local socket = require("socket")

local s = socket.udp()
s:setpeername("74.125.115.104",80)
local ip, _ = s:getsockname()

return ip