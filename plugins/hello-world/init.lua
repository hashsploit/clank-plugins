local tp = require("plugins.hello-world.hello-world")

return {
	name = "hello-world",
	description = "Hello World is an example Clank Plugin",
	version = {
		major = 0,
		minor = 1,
		revision = 0
	},
	events = {
		PLUGIN_INIT_EVENT = tp.init,
		PLUGIN_SHUTDOWN_EVENT = tp.shutdown,
		TICK_EVENT = tp.onTick,
		CONNECT_EVENT = tp.onConnect,
		DISCONNECT_EVENT = tp.onDisconnect
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
			handler = tp.command.hello
		},
		luatime = {
			description = "Prints the Lua os.time()",
			handler = tp.command.luatime
		}
	}
}

