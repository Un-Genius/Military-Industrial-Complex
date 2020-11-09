function scr_GUI_Host() {
	// Access parent
	with(parent)
	{
		if !steam_initialised()
		{
			// Send message
			trace(1, "Steam not connected.");
		
			// Exit script
			exit;
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
