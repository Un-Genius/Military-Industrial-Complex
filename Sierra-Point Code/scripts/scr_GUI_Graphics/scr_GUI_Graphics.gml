function scr_GUI_Graphics() {
	// Access parent
	with(parent)
	{
		// Hold current state
		prevState = state;
	
		// Set Target state
		state = menu.graphicsPage;
	
		reset_menu();
	}


}
