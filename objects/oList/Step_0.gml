var _height = ds_grid_height(optionGrid);
var _width = ds_grid_width(optionGrid);

for(i = 0; i < _height; i++)
{
	// Find Data
	var _sel	= ds_grid_get(optionGrid, 2, i);
	
	// Coordinates
	var _x1 = x + outerPadding;
	var _y1 = y + outerPadding + (fntSize * (i + 1)) + (innerPadding * (i + 1));
	var _x2 = x + width - outerPadding;
	var _y2 = _y1 + fntSize;
	
	// Get if hovering
	var _hover = get_hover(_x1, _y1, _x2, _y2);
	
	if(_hover)
	{
		// Set hover variable
		hoverID = i;
		
		// Change value
		if(_sel > -1)
		{
			var _wheel = mouse_wheel_up() - mouse_wheel_down();
			
			// Wheel input
			if(_wheel != 0)
			{
				// slim width from empty slots
				for(var o = 0; o < _width; o++)
				{
					if o + 1 < _width
					{
						// Get var in list to check
						var _var = ds_grid_get(optionGrid, o, i);

						if _var == -1
							_width = o - 1;
					}
				}
				
				// Change selected with wheel
				_sel += _wheel;
				
				// Clamp
				_sel = clamp(_sel, 0, _width - 3);
				
				// Apply to list	
				ds_grid_set(optionGrid, 2, i, _sel);
				
				// Save in global list
				var _pos = ds_grid_get(optionGrid, 0, i);
				ds_grid_set(global.savedSettings, 1, _pos, _sel);
				
				var _scriptName = "scr_GUI_list" + string(_pos);			
				
				var _script = asset_get_index(_scriptName)
				
				// Do special event
				if _script != -1
					script_execute(asset_get_index(_scriptName));
			}
		}
	}
}