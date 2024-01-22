function scr_GUI_Save() {
	with(oNetwork)
	{
		#region Save options
			
		//https://www.youtube.com/watch?v=QmxQb1BFQRE&t=0s
			
		// Create a root list
		var _root_list = ds_list_create();
			
		// Create a map
		var _map = ds_map_create();
		ds_list_add(_root_list, _map);
		ds_list_mark_as_map(_root_list, ds_list_size(_root_list)-1);
			
		// Turn options data into lists
		var _height = ds_grid_height(global.savedSettings);
			
		// Create one list for the Y line
		var _savedOptions = ds_list_create();
		ds_map_add_list(_map, "savedOptions", _savedOptions);
			
		for(var i = 0; i < _height; i++)
		{												
			// Find data
			var _value = ds_grid_get(global.savedSettings, 1, i);
				
			// Add data to list
			ds_list_add(_savedOptions, _value);
		}
			
		// Wrap the root LIST up in a MAP
		var _wrapper = ds_map_create();
		ds_map_add_list(_wrapper, "ROOTS", _root_list);
			
		// Save all to a string
		var _string = json_encode(_wrapper);
		saveStringToFile("options.sav", _string);
			
		// Nuke the data
		ds_map_destroy(_wrapper);
			
		trace(1, "Options saved");
			
		#endregion
	}
}
