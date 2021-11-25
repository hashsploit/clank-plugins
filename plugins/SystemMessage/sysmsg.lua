local config = require("plugins.SystemMessage.config")
local events = {}

--[[
Process a message placeholders/variables with valid data and if playerObject is available

- message = string
- player = PlayerObject (optional)
--]]
local function processMessage(message, player)

	-- Byte Variable
	for i=0, 255 do
		message = message:replace("${0x"..string.format("%.2X", i), "\\x"..string.format("%.2X", i))
	end

	-- Lua Variable
	message = message:replace("${LUA_VERSION}", _VERSION)

	-- Clank Version Variable
	message = message:replace("${CLANK_VERSION}", clank._VERSION)

	-- Plugin Version Variable
	message = message:replace("${CLANK_VERSION}", config.version.major.."."..config.version.minor.."."..config.version.patch)

	-- Total Players Variable
	message = message:replace("${TOTAL_PLAYERS}", #clank.getPlayers())

	-- Date Variable
	local date_variable_prefix = "${DATE_"
	if message:match(date_variable_prefix) then
		local start_index = message:find(date_variable_prefix)
		local end_index = 0
		for i=start_index, #message do
			if message:sub(i, i) == "}" then
				end_index = i - 1
				break
			end
		end
		if end_index > 0 then
			local date_format = message:sub(start_index+#date_variable_prefix, end_index)
			message = message:replace(date_variable_prefix .. date_format .. "}", os.date(date_format))
		end
	end

	-- Player specific variables
	if player ~= nil then
		message = message:replace("${USERNAME}", player.username)
	end

	return message
end

--[[
Sends a RT_MSG_SERVER_SYSTEM_MESSAGE packet to a specific player

- player = PlayerObject table
- severity = integer 0-255
- message = string
--]]
local function send(player, severity, message)
	player.medius:sendSystemMessage(severity, message)
end

--[[
Sends a RT_MSG_SERVER_SYSTEM_MESSAGE packet to all connected players

- severity = integer 0-255
- message = string
--]]
local function broadcast(severity, message)
	for i=1, #clank.getPlayers() do
		send(clank.getPlayers()[i], severity, message)
	end
end


events.onInit = function()
	-- Do nothing
end

events.onShutdown = function()

end

events.onConnect = function()

end



local function cli(raw)

	local printUsage = function()
		print("Usage: sysmsg <player/*> <severity> <message>")
		print(" - Where <player/*> is either a player's username or * for a broadcast.")
		print(" - Where <severity> is an integer from 0-255.")
		print(" - Where <message> is a string to send to the player(s).")
	end

	if #raw < 3 then
		printUsage()
		return
	end

	local player = raw[1]
	local severity = raw[2]
	local message = raw[3]

	if type(severity) ~= "number" then
		printUsage()
		return
	end

	severity = tonumber(severity)

	if severity < 0 or severity > 255 then
		printUsage()
		return
	end

	if type(message) ~= "string" and #message == 0 then
		printUsage()
		return
	end

	if player == "*" then
		print("Broadcasting at severity " .. severity .. ": " .. processMessage(message, nil))
	else
		for i=1, #clank.getPlayers() do
			if clank.getPlayers()[i].username:lower() == player:lower() then
				send(clank.getPlayers()[i], severity, message)
				break
			end
		end
	end

end

return {
	events = events,
	cli = cli,
	api = {
		processMessage = processMessage,
		send = send,
		broadcast = broadcast
	}
}
