/// @arg name
/// @arg pos
/// @arg values...
function add_setting() {

	// Amout of additional arguments
	var _argCount = argument_count;
	
	// Set values
	var _savedSettings = global.savedSettings;

	var _height = ds_grid_height(_savedSettings);
	var _width = ds_grid_width(_savedSettings);
	
	if _argCount > _width
		_width = _argCount;

	ds_grid_resize(_savedSettings, _width, _height + 1);
	
	for(var i = 0; i < _width; i++)
	{		
		if _argCount > i
			ds_grid_add(_savedSettings, i, _height, argument[i]);
		else
			ds_grid_add(_savedSettings, i, _height, -1);
	}


}
