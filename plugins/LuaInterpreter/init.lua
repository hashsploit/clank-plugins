
local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

local function eval(params)
	local cmd = table.concat(params, " ")
	
	if starts_with(cmd, "=") then
		cmd = "print(" .. cmd:sub(2) .. ")"
	end
	
	local func, err = load(cmd)
	if not func then
		print("Error: " .. err)
		return
	end
	
	local status, msg = pcall(func)
	
	if not status then
		print("Error: " .. msg)
	end
end

return {
	name = "LuaInterpreter",
	description = "Lua interpreter from the CLI",
	version = {
		major = 0,
		minor = 1,
		revision = 0
	},
	events = {
		PLUGIN_INIT_EVENT = function() print("Initialized.") end,
		PLUGIN_SHUTDOWN_EVENT = nil
	},
	run_on = {
		"MEDIUS_UNIVERSE_INFORMATION_SERVER",
		"MEDIUS_AUTHENTICATION_SERVER",
		"MEDIUS_LOBBY_SERVER",
		"DME_SERVER",
		"NAT_SERVER"
	},
	commands = {
		lua = {
			description = "Evaluate Lua syntax.",
			handler = eval
		}
	}
}

