local clank = {}

local function sleep(s)
	local ntime = os.clock() + s/1000
	repeat until os.clock() > ntime
end

local function getConfig()
	return {}
end

local function getPluginPath()
	return debug.getinfo(1).source:match("@?(.*/)")
end

local function onConnection(func)
	
end

clank.sleep = sleep
clank.getConfig = getConfig
clank.getPluginPath = getPluginPath

return clank
