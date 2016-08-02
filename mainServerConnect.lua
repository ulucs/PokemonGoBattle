return function(user,pass)
	local http = require("socket.http")
	local json = require("dkjson")
	local ltn12 = require("ltn12")

	local source = "username="..user.."&password="..pass
	local respbody = {}

	local r,c = http.request({
		url = "http://localhost:3000/gameLogin",
		method = "POST",
		source = ltn12.source.string(source),
		headers = {
		    ["Accept"] = "*/*",
		    ["Accept-Encoding"] = "gzip, deflate",
		    ["Accept-Language"] = "en-us",
		    ["Content-Type"] = "application/x-www-form-urlencoded",
		    ["content-length"] = string.len(source)
		},
		sink = ltn12.sink.table(respbody)
	})

	return json.decode(table.concat(respbody))
end