function scr_GUI_Public() {
	// Access parent
	with(parent)
	{
		// refresh list
		alarm[0] = 1;
	
		// Hold current state
		prevState = state;
	
		// Set Target state
		state = menu.public;
	
		reset_menu();
	}
}
