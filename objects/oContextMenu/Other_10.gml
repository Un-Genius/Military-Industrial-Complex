/// @description Update size

// Set Font
draw_set_font(ftContextMenu);

// Get size of list
var _gridHeight = ds_grid_height(contextGrid);

// Size of contextMenu
width	= 0;	// Changes depending on text size
height	= font_get_size(ftContextMenu) * 1.5;	// The height per cell

// Padding added on the sides and for break
padding = 5;

backgroundHeight = height * _gridHeight;

// Get width and check for breaks
for(var i = 0; i < _gridHeight; i++)
{
	// Get data
	var _string = ds_grid_get(contextGrid, 0, i);
	
	// Get length
	var _newWidth = string_width(_string);
		
	// Update width if new width is bigger
	if _newWidth > width
		width = _newWidth
					
	// Replace height slot with break height
	if _string = "break"
		backgroundHeight -= height - padding;
}
	
// Add extra width for more space
width += 10 + padding;

// Reset Font
draw_set_font(ftDefault);