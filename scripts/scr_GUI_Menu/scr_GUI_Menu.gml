function scr_GUI_Menu() {
	// Change room
	room = room_goto(rm_menu);

	// Access parent
	with(parent)
	{	
		// Dont hold current state
	
		// Set Target state
		state = menu.home;
	
		reset_menu();
		
		// Say goodbye
		var _buffer = packet_start(packet_t.leaving);
		packet_send_all(_buffer);
			
		// Reset steam
		steam_lobby_leave();
		steam_reset_state();
	}
}
