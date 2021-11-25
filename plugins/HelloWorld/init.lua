local hello = require("plugins.HelloWorld.hello")

return {
	name = "HelloWorld",
	description = "Hello World is an example Clank Plugin",
	version = {
		major = 0,
		minor = 1,
		patch = 0
	},
	depends = {},
	events = {
		PLUGIN_INIT_EVENT = hello.init,
		PLUGIN_SHUTDOWN_EVENT = hello.shutdown,
		TICK_EVENT = hello.onTick,
		CONNECT_EVENT = hello.onConnect,
		DISCONNECT_EVENT = hello.onDisconnect
	},
--	run_on = 0x01 | 0x02 | 0x04 | 0x08 | 0x10
	run_on = {
		"MEDIUS_UNIVERSE_INFORMATION_SERVER",
		"MEDIUS_AUTHENTICATION_SERVER",
		"MEDIUS_LOBBY_SERVER",
		"DME_SERVER",
		"NAT_SERVER"
	},
	commands = {
		hello = {
			description = "Says hello!",
			handler = hello.command.hello
		},
		luatime = {
			description = "Prints the Lua os.time()",
			handler = hello.command.luatime
		}
	}
}

