local config = {
	
	-- This message is sent to players who connect for the first time.
	-- to keep track of who already joined, a list of players is kept in players.txt
	new_player_message = {

		-- Whether new player messages are enabled or not.
		enabled = false,

		-- All Medius Messages require a severity ranging from 0 to 255.
		-- In some titles a severity >= 1 means an error occured and may cause the player to disconnect.		
		severity = 0,

		-- If your game uses special bytes to represent special characters/attributes
		-- you can insert a byte by using ${0x03} to represent the byte 0x03. Range 0x00 to 0xFF.
		-- You can also use ${USERNAME} to represent the player's username.
		message = "Welcome ${USERNAME}, to the revived server!"
	},
	
	-- This message is sent to the player when they join the server.
	connect_message = {
		enabled = true,
		severity = 0,
		message = "Hello ${USERNAME}! This is the default connect message. You can configure it in plugins/SystemMessage/config.lua"
	},
	
	-- This message is broadcasted to all players when the server is shutting down.
	shutdown_message_broadcast = {
		enabled = false,
		severity = 0,
		message = ""
	}
	
}

return config

