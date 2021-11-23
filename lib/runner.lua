
-- Set relative path loader
package.path = package.path .. ";./lib/?.lua"

-- Load dependencies
local colors = require("ansicolors")
local tabular = require("tabular")
clank = require("clank")

local console_thread = nil
local running = true
local g_plugin_path = clank.getPluginPath
local g_print = _G["print"]
local plugins = {}
local commands = {}

local function startsWith(str, start)
	return str:sub(1, #start) == start
end

local function endsWith(str, ending)
	return ending == "" or str:sub(-#ending) == ending
end

local function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

local function loadPlugin(plugin, plugin_path)

	local function pluginPath()
		return "./"..plugin_path.."/"
	end
	
	clank.getPluginPath = pluginPath
	local config = plugin()
	clank.getPluginPath = g_plugin_path
	
	local function verToStr(version)
		return version.major.."."..version.minor.."."..version.revision
	end
	
	local function log(...)
		local msg = ...
		if msg == nil then
			msg = ""
		end
		g_print("["..config.name.."] ".. tostring(msg))
	end
	
	-- Perform plugin sanity inspections
	
	if config == nil or type(config) ~= "table" then
		log("Plugin init.lua is not a valid init script")
		return
	end
	
	-- Name check
	if config["name"] == nil or type(config["name"]) ~= "string" then
		log("init.lua: 'name' must be a string")
		return
	end
	if #config["name"] < 3 or #config["name"] > 32 then
		log("init.lua: 'name' must be more than 3 characters but less than 32")
		return
	end
	if not config["name"]:match("[A-Za-z0-9-_]") then
		log("init.lua: 'name' must be alphanumeric [A-Za-z0-9-_]")
		return
	end
	-- TODO check if path name contains name
	
	-- Description check
	if config["description"] == nil or type(config["description"]) ~= "string" then
		log("init.lua: 'description' must be a string")
		return
	end
	
	-- Version check
	if config["version"] == nil or type(config["version"]) ~= "table" then
		log("init.lua: 'version' must be a table")
		return
	end
	if config["version"]["major"] == nil or tonumber(config["version"]["major"]) == nil then
		log("init.lua: 'version.major' must be a number from 0-255")
		return
	end
	if tonumber(config["version"]["major"]) < 0 or tonumber(config["version"]["major"]) > 255 then
		log("init.lua: 'version.major' must be a number from 0-255")
		return
	end
	if config["version"]["minor"] == nil or tonumber(config["version"]["minor"]) == nil then
		log("init.lua: 'version.minor' must be a number from 0-255")
		return
	end
	if tonumber(config["version"]["minor"]) < 0 or tonumber(config["version"]["minor"]) > 255 then
		log("init.lua: 'version.minor' must be a number from 0-255")
		return
	end
	if config["version"]["revision"] == nil or tonumber(config["version"]["revision"]) == nil then
		log("init.lua: 'version.revision' must be a number from 0-255")
		return
	end
	if tonumber(config["version"]["revision"]) < 0 or tonumber(config["version"]["revision"]) > 255 then
		log("init.lua: 'version.revision' must be a number from 0-255")
		return
	end
	
	-- Events check
	if config["events"] == nil or type(config["events"]) ~= "table" then
		log("init.lua: 'events' must be a table")
		return
	end
	for k, v in pairs(config["events"]) do
		if not endsWith(k, "_EVENT") and type(v) ~= "function" then
			log("init.lua: 'events."..k.."' must be a function")
			return
		end
	end
	
	-- Run_on check
	local valid_emulation_modes = {
		'MEDIUS_UNIVERSE_INFORMATION_SERVER',
		'MEDIUS_AUTHENTICATION_SERVER',
		'MEDIUS_LOBBY_SERVER',
		'DME_SERVER',
		'NAT_SERVER'
	}
	if config['run_on'] == nil then
		log("init.lua: 'run_on' must be a table or an integer")
		return
	end
	if type(config['run_on']) ~= "number" and type(config['run_on']) ~= "table" then
		log("init.lua: 'run_on' must be a table or an integer")
		return
	end
	if type(config['run_on']) == "table" then
		for _, v in pairs(config['run_on']) do
			local valid = false
			for _, z in pairs(valid_emulation_modes) do
				if v == z then
					valid = true
				end
			end
			if not valid then
				log("init.lua: 'run_on' does not have a valid emulation mode: " .. v)
				log("Valid 'run_on' table values: " .. table.concat(valid_emulation_modes, ", "))
				return
			end
		end
	end
	
	-- Commands check
	if config["commands"] == nil or type(config["commands"]) ~= "table" then
		log("init.lua: 'commands' must be a table")
		return
	end
	for cmd, parts in pairs(config["commands"]) do
		if type(cmd) ~= "string" then
			log("init.lua: 'commands' key must be a string")
			return
		end
		if cmd == "exit" then
			log("init.lua: 'commands.exit' is a reserved command and cannot be used")
			return
		end
		if parts == nil or type(parts) ~= "table" then
			log("init.lua: 'commands' value must be a table")
			return
		end
		if parts.description == nil or type(parts.description) ~= "string" then
			log("init.lua: 'commands."..cmd..".description' must be a string")
			return
		end
		if parts.handler == nil or type(parts.handler) ~= "function" then
			log("init.lua: 'commands."..cmd..".handler' must be a function")
			return
		end
		
		local command = {
			command = cmd,
			description = parts.description,
			func = parts.handler
		}
		
		table.insert(commands, command)
	end
	
	plugins[config.name] = {}
	plugins[config.name]["config"] = config
	plugins[config.name]["enabled"] = true
	
	_G["print"] = log
	clank.getPluginPath = pluginPath
	
	-- Run plugin init sequence
	if config.events.PLUGIN_INIT_EVENT ~= nil then
		local status, msg = pcall(config.events.PLUGIN_INIT_EVENT)
		if not status then
			_G["print"] = g_print
			print(colors("%{bright red}Error:%{reset} while issuing PLUGIN_INIT_EVENT for "..config.name))
			print(msg)
			_G["print"] = log
			plugins[config.name]["enabled"] = false
		end
	end
	
	
	if plugins[config.name].enabled then
		_G["print"] = g_print
		print(colors("%{bright green}Success:%{reset} Loaded "..config.name.." v"..verToStr(config.version).." @ "..tostring(config).."%{reset}"))
		_G["print"] = log
	end
	
	-- internal plugin loop
	while plugins[config.name].enabled do
		_G["print"] = log
		
		if config.events.TICK_EVENT ~= nil then
			local status, msg = pcall(config.events.TICK_EVENT)
			if not status then
				_G["print"] = g_print
				print(colors("%{bright red}Error:%{reset} while issuing TICK_EVENT for "..config.name))
				print(msg)
				_G["print"] = log
			end
		end
		
		local a = coroutine.yield()
		
		if a ~= nil then
			if type(a) == "function" then
				a()
			end
		end
		
		_G["print"] = g_print
		clank.getPluginPath = g_plugin_path
	end
	
	-- Remove bound cli commands
	for cmd, parts in pairs(config["commands"]) do
		for k, v in pairs(commands) do
			if cmd == v.command then
				table.remove(commands, k)
				break
			end
		end
	end
	
	-- Run plugin shutdown sequence
	if config.events.PLUGIN_SHUTDOWN_EVENT ~= nil then
		_G["print"] = log
		local status, msg = pcall(config.events.PLUGIN_SHUTDOWN_EVENT)
		if not status then
			print("Error while shutting down: " .. msg)
		end
	end
	
	_G["print"] = g_print
	clank.getPluginPath = g_plugin_path
	
	table.remove(plugins, config.name)
	plugins[config.name] = nil
	
	print("Unloaded "..config.name.." v"..verToStr(config.version))
end


local function loadSource(path)

	_G["print"] = g_print
	clank.getPluginPath = g_plugin_path
	
	local file = io.open(path.."/init.lua", "rb")
	
	if file == nil or not file then
		file = io.open(path.."/init.lub", "rb")
		
		if file == nil or not file then
			print(colors("%{bright red}Error:%{reset} file "..path.."/init.lua not found!"))
			return
		end
	end
	
	local source = file:read("*a")
	local status, chunk = pcall(load, source)
	
	if not status then
		print(colors("%{bright red}Error:%{reset} failed to load source "..path..": "..chunk))
		return
	end
	
	if type(chunk) ~= "function" then
		print(colors("%{bright red}Error%{reset} bad source "..path.."/init.lua !"))
		return
	end
	
	for k, v in pairs(plugins) do
		if v.path == path then
			print(colors("%{bright red}Error:%{reset} plugin '"..k.."' already loaded!"))
			return
		end
	end
	
	local plugin_thread = coroutine.create(function()
		loadPlugin(chunk, path)
		local status, msg = pcall(loadPlugin, chunk, path)
		if not status then
			_G["print"] = g_print
			print(colors("%{bright red}Error:%{reset} failed to load plugin '"..path.."': "..msg))
			return
		end
	end)
	
	coroutine.resume(plugin_thread)
	clank.sleep(10)
	local loaded = false
	
	for k, v in pairs(plugins) do
		if string.find(path, k, nil, "plain") then
			plugins[k]["enabled"] = true
			plugins[k]["thread"] = plugin_thread
			plugins[k]["path"] = path
			loaded = true
			break
		end
	end
	
	_G["print"] = g_print
	clank.getPluginPath = g_plugin_path
	
	if not loaded then
		print(colors("%{bright red}Error:%{reset} failed to load plugin "..path))
	end
	
end



local function console()
	while running do
		coroutine.yield()
		
		_G["print"] = g_print
		clank.getPluginPath = g_plugin_path
		io.write(colors("%{blink reverse}>%{reset} "))
		local cmd = io.read("*L")
		
		if cmd == nil then
			running = false
			return
		end
		
		cmd = cmd:gsub("\r", "")
		cmd = cmd:gsub("\n", "")
		cmd = split(cmd)
		
		if cmd[1] == "exit" then
			running = false
			return
		elseif cmd[1] == "help" or cmd[1] == "?" then
			print(colors("%{underline}    Commands (%{bright green}*%{reset}%{underline} are built in)    %{reset}"))
			print(colors(" - exit,^D%{bright green}*%{reset} = Quit the clank debugger"))
			print(colors(" - help,?%{bright green}*%{reset} = Show available commands"))
			print(colors(" - load,lo%{bright green}*%{reset} <plugin> = Load a plugin"))
			print(colors(" - unload,ul%{bright green}*%{reset} <plugin> = Unload a plugin"))
			print(colors(" - reload,re%{bright green}*%{reset} [plugin] = Reload a plugin or all plugins"))
			print(colors(" - threads,t%{bright green}*%{reset} = Show available threads"))
			print(colors(" - inspect,i%{bright green}*%{reset} <plugin> = Show configuration of <plugin>"))
			print(colors(" - ginspect,g%{bright green}*%{reset} = Show all globals"))
			
			for i=1, #commands do
				print(colors(" - %{bright blue}"..commands[i].command.."%{reset} = "..commands[i].description.." ("..tostring(commands[i].func):gsub("function: ", "")..")"))
			end
			
		elseif cmd[1] == "load" or cmd[1] == "lo" then
			if #cmd == 2 then
				local status, msg = pcall(loadSource, "plugins/"..cmd[2])
				collectgarbage("collect")
				if not status then
					print(msg)
				end
			else
				print("Usage: "..cmd[1].." <plugin>")
			end
		elseif cmd[1] == "unload" or cmd[1] == "ul" then
			if #cmd == 2 then
				local success = false
				for k, v in pairs(plugins) do
					if k == cmd[2] then
						success = true
						v.enabled = false
					end
				end
				if not success then
					print(colors("%{bright red}Error:%{reset} no plugin by name of '"..cmd[2].."'"))
				end
				collectgarbage("collect")
				print("Unloaded plugin '"..cmd[2].."'")
			else
				print("Usage: "..cmd[1].." <plugin>")
			end
		elseif cmd[1] == "reload" or cmd[1] == "re" then
			if #cmd == 2 then
				-- Unload specific plugin
				local success = false
				for k, v in pairs(plugins) do
					if k == cmd[2] then
						success = true
						v.enabled = false
					end
				end
				if not success then
					print(colors("%{bright red}Error:%{reset} no plugin by name of '"..cmd[2].."'"))
				end
				for k, v in pairs(plugins) do
					local status, msg = pcall(coroutine.resume, v.thread)
					if not status then
						print(msg)
					end
					if coroutine.status(v.thread) == "dead" then
						plugins[k] = nil
					end
				end
				collectgarbage("collect")
				clank.sleep(100)
				-- Load specific plugin
				local status, msg = pcall(loadSource, "plugins/"..cmd[2])
				if not status then
					print(msg)
				end
			elseif #cmd == 1 then
				local plugin_names = {}
				-- Unload plugins
				for k, v in pairs(plugins) do
					v.enabled = false
					table.insert(plugin_names, k)
				end
				for k, v in pairs(plugins) do
					local status, msg = pcall(coroutine.resume, v.thread)
					if not status then
						print(msg)
					end
					if coroutine.status(v.thread) == "dead" then
						plugins[k] = nil
					end
				end
				collectgarbage("collect")
				clank.sleep(100)
				-- Load plugins
				for _, v in pairs(plugin_names) do
					local status, msg = pcall(loadSource, "plugins/" .. v)
					if not status then
						print(msg)
					end
				end
			else
				print("Usage: "..cmd[1].." [plugin]")
			end
		elseif cmd[1] == "threads" or cmd[1] == "t" then
			local _plugins = {}
			for k, v in pairs(plugins) do
				local status = (coroutine.status(v.thread) == "suspended" and "loaded" or "unloaded")
				table.insert(_plugins, {plugin=k,status=status,thread=tostring(v.thread)})
			end
			print(colors(tabular(_plugins, nil, true)))
		elseif cmd[1] == "inspect" or cmd[1] == "i" then
			if #cmd >= 2 then
				local success = false
				for k, v in pairs(plugins) do
					if k == cmd[2] then
						success = true
						print(tabular(v, nil, true))
					end
				end
				if not success then
					print(colors("%{bright red}Error:%{reset} no plugin by name of '"..cmd[2].."'"))
				end
			else
				print("Usage: "..cmd[1].." <plugin>")
			end
		elseif cmd[1] == "ginspect" or cmd[1] == "g" then
			print(tabular(_G, nil, true))
		end
		
		for i=1, #commands do
			if cmd[1] == commands[i].command then
				table.remove(cmd, 1)
				local status, err = pcall(commands[i].func, cmd)
				
				if not status then
					print(colors("%{bright red}Error:%{reset} "..err))
				end
			end
		end
		
	end
end


print(colors("Args: "..#arg.." [%{cyan}"..table.concat(arg, "%{reset}, %{cyan}").."%{reset}]"))

console_thread = coroutine.create(function()
	console()
end)

_G["print"] = g_print
print("Initializing plugins ...")

for i=1, #arg do
	loadSource(arg[i])
end

_G["print"] = g_print

while running do
	
	for k, v in pairs(plugins) do
		local status, msg = pcall(coroutine.resume, v.thread)
		if not status then
			print(msg)
		end
		if coroutine.status(v.thread) == "dead" then
			plugins[k] = nil
		end
	end
	
	local status, msg = pcall(coroutine.resume, console_thread)
	if not status then
		print(msg)
	end
	
end

-- One last iteration
for k, v in pairs(plugins) do
	coroutine.resume(v.thread)
end

_G["print"] = g_print

print("Terminated")

