/// @description Update size

var _grid_height = ds_grid_height(cm_grid);

cm_background_height = height * _grid_height;

// Get width and check for breaks
for(var i = 0; i < _grid_height; i++)
{
	var _string = ds_grid_get(cm_grid, 0, i);
	
	var _new_width = string_width(_string);
		
	// Update width if new width is bigger
	if _new_width > width
		width = _new_width
					
	if _string == "break"
		cm_background_height -= height - padding;
}
	
// Add extra width for more space
width += 10 + padding;