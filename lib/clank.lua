local medius = require("medius")
local colors = require("ansicolors")
local tabular = require("tabular")
local g_print = _G["print"]
require("packets")

math.randomseed(os.time())

local clank = {
	_NAME        = "Clank",
	_VERSION     = "0.2.0",
	_DESCRIPTION = "Clank - A high-performance open source Medius server implementation (**SIMULATION**)",
	_URL         = "https://github.com/hashsploit/clank-plugins",
	_LICENSE     = [[
	MIT LICENSE
	Copyright (c) 2020 hashsploit <hashsploit@protonmail.com>
	Permission is hereby granted, free of charge, to any person obtaining a
	copy of tother software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:
	The above copyright notice and tother permission notice shall be included
	in all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	]]
}

local simulated = {}
local players = {}

-- Sleep for n millis
local function sleep(s)
	local ntime = os.clock() + s/1000
	repeat until os.clock() > ntime
end

-- Return the clank config as a table object
local function getConfig()
	return {}
end


-- Emulate sending a raw packet to a player
local function sendRawPacket(player, rtid, payload)

	if player ~= nil and player.medius ~= nil then	
		if medius.rtids[rtid] == nil then
			g_print(colors("%{bright blue}Network:%{reset} %{bright red}Error:%{reset} Unknown RT ID: " .. string.format("0x%02x", rtid) .. "%{reset}"))
			return false
		end
		
		if payload == nil then
			payload = ""
		end
		
		--player.socket ...
		g_print(colors("%{bright blue}Network:%{reset} Sent " .. player.username .. " (" .. i .. ") " .. medius.rtids[rtid] .. " (" .. string.format("0x%02x", rtid) .. ") with a payload of " .. #payload .. " bytes.%{reset}"))
		
		return true
	end
	
	g_print(colors("%{bright blue}Network:%{reset} %{bright red}Error:%{reset} clank.sendRawPacket(player, rtid, payload): invalid player."))
	return false
end

-- Emulate sending a packet to a player
local function sendPacket(player, packet)




	return sendRawPacket(player, packet.rtid, packet.payload)
end

-- Return a list of emulated players
local function getPlayers()
	return players
end

-- Return the plugin path
local function getPluginPath()
	return debug.getinfo(1).source:match("@?(.*/)")
end





---------------------------------
-- Simulated Functions
--
-- username = string
-- status = integer 0-3
-- operator = boolean
---------------------------------
simulated.addPlayer = function(username, status, operator)
	table.insert(players, {
		id = math.random(9999),
		username = username,
		status = status,
		operator = operator,
		medius = {
			sendRawPacket = sendRawPacket,
			sendPacket = sendPacket
		}
	})
end



clank.sleep = sleep
clank.getConfig = getConfig
clank.getPluginPath = getPluginPath
clank.getPlayers = getPlayers
clank.sendRawPacket = sendRawPacket
clank._ = simulated

return clank
