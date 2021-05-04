local tp = require("plugins.hello-world.hello-world")

return {
	name = "hello-world",
	description = "Hello World is an example Clank Plugin",
	version = {
		major = 0,
		minor = 1,
		revision = 0
	},
	init = tp.init,
	events = {
		TICK_EVENT = tp.on_tick,
		CONNECT_EVENT = tp.on_connect,
		DISCONNECT_EVENT = tp.on_disconnect
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

