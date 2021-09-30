
local commands = {
	hello = function(params) if #params > 0 then print("Hello, " .. table.concat(params, " ") .. "!") else print("Usage: hello <names ...>") end end,
	luatime = function(params) print("Lua time: " .. os.time()) end
}

local function init()
	print("Loaded!")
end

local function shutdown()
	print("Unloaded!")
end

local function onConnect(client)

end

local function onDisconnect(client)

end

local function onTick()

end

return {
	init = init,
	shutdown = shutdown,
	onConnect = onConnect,
	onDisconnect = onDisconnect,
	onTick = onTick,
	command = commands
}
