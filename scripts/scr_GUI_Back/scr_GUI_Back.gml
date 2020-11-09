function scr_GUI_Back() {
	// Access parent
	with(parent)
	{	
		// Set Target state
		switch(state)
		{
			case menu.loadingPage:
			case menu.hostPage:
			case menu.joinPage:
		
				// Return home
				state = menu.public;	
			
				// Say goodbye
		        var _buffer = packet_start(packet_t.leaving);
		        packet_send_all(_buffer);
			
				// Reset steam
				steam_lobby_leave();
				steam_reset_state();
			
				break;
			
			case menu.public:
		
				// Return home
				state = menu.home;	
			
				break;
			
			case menu.graphicsPage:
			case menu.soundsPage:
			case menu.controlsPage:
			case menu.optionsPage:
				
				// Check if ingame
				if inGame
					state = menu.inGame;
				else
					// Return home
					state = menu.home;	
						
				break;
			
			default:
			{
				state = prevState;
			}
		}
	
		reset_menu();
	}


}
