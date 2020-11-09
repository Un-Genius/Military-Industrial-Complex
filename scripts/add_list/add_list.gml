function add_list(_inst, _ref) {
	var _savedSettings = global.savedSettings;

	// Set values
	with(_inst)
	{	
		var _width = ds_grid_width(_savedSettings);
		var _height = ds_grid_height(optionGrid);
	
		ds_grid_resize(optionGrid, _width, _height + 1)
	
		ds_grid_add(optionGrid, 0, _height, _ref);
	
		// Add values to list
		for(var i = 1; i < _width; i++)
		{	
			var _value = ds_grid_get(_savedSettings, i - 1, _ref);
		
			// Add value to grid
			ds_grid_add(optionGrid, i, _height, _value);	
		}
	}
}
