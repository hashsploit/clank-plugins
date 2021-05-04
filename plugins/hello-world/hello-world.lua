
local commands = {
	hello = function(params) if #params > 0 then print("Hello, " .. table.concat(params, " ") .. "!") else print("Usage: hello <names ...>") end end,
	luatime = function(params) print("Lua time: " .. os.time()) end
}

local function init()
	print("Hello world plugin initialized!")
end

local function on_connect(client)

end

local function on_disconnect(client)

end

local function on_tick()

end

return {
	init = init,
	on_connect = on_connect,
	on_disconnect = on_disconnect,
	on_tick = on_tick,
	command = commands
}
