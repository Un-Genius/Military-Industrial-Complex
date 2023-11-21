function scr_GUI_Host() {
	// Access parent
	with(parent)
	{
		if !steam_is_user_logged_on()
		{
			// Send message
			trace(2, "Unable to host online lobby.");
			
			lobby = true;
			lobby_owner = id;
			// Exit script
			//exit;
		}
	
		creating_lobby	= true;
		playersReady	= 0;
	
		// Hold current state
		prevState		= state;
	
		// Set Target state
		state			= menu.hostPage;
	
		reset_menu();
	}


}
