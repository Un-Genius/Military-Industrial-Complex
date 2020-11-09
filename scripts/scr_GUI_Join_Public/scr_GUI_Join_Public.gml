function scr_GUI_Join_Public() {
	// Get id
	var _id = id;

	with(oManager)
	{
		// Get position in list
		var _pos = ds_list_find_index(instPublic_list, _id);
		
		// Set menu
		state = menu.loadingPage;
		reset_menu();
	}

	// Join lobby
	steam_lobby_list_join(_pos);
}
