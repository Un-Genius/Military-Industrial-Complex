function scr_GUI_Options() {
	// Access parent
	with(parent)
	{
		// Hold current state
		prevState = state;
	
		// Set Target state
		state = menu.optionsPage;
	
		reset_menu();
	}


}
