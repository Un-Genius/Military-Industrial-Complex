function scr_GUI_Controls() {
	// Access parent
	with(parent)
	{
		// Hold current state
		prevState = state;
	
		// Set Target state
		state = menu.controlsPage;
	
		reset_menu();
	}


}
