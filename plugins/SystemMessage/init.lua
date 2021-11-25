local sysmsg = require("plugins.SystemMessage.sysmsg")

return {
	name = "SystemMessage",
	description = "A basic System Messaging plugin and API",
	version = {
		major = 0,
		minor = 1,
		patch = 2
	},
	depends = {},
	api = sysmsg.api,
	events = {
		PLUGIN_INIT_EVENT = sysmsg.events.onInit,
		PLUGIN_SHUTDOWN_EVENT = sysmsg.events.onShutdown,
		CONNECT_EVENT = sysmsg.events.onConnect
	},
	run_on = {
		"MEDIUS_UNIVERSE_INFORMATION_SERVER",
		"MEDIUS_AUTHENTICATION_SERVER",
		"MEDIUS_LOBBY_SERVER",
		"DME_SERVER",
		"NAT_SERVER"
	},
	commands = {
		sysmsg = {
			description = "Send a system message to a specific player or as a broadcast",
			handler = sysmsg.cli
		}
	}
}

