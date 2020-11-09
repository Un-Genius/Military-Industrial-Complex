function scr_GUI_Sounds() {
	// Access parent
	with(parent)
	{
		// Hold current state
		prevState = state;
	
		// Set Target state
		state = menu.soundsPage;
	
		reset_menu();
	}


}
