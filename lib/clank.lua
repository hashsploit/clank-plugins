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
