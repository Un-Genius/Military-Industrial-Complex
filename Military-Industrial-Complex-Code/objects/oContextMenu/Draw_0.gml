// Set Font
draw_set_font_ext(ftContextMenu, c_white, fa_left, fa_top, 1);

cm_background();

for(var i = 0; i < grid_height; i++)
{
	if cm_grid == noone exit;
		
	// Get data
	var _string = ds_grid_get(cm_grid, 0, i);
	var _script = ds_grid_get(cm_grid, 1, i);	
	var _folder = ds_grid_get(cm_grid, 2, i);
		
	if cm_break(i, _string)
		continue;
		
	height_level = mp_gui_y + slot_height;
		
	// Draw data
	draw_text(mp_gui_x + padding, height_level, _string);
				
	// Draw folder icon
	if _folder
		cm_triangle()
		
	hovering = false;
	
	if get_hover(mp_gui_x, height_level+1, mp_gui_x + width, height_level + height-1, false)
		hovering = true;
		
	// Check for mouse hover
	if hovering
	{				
		cm_file_expand(i)
			
		cm_execute(i);
			
		cm_highlight();
	}
		
	slot_height += height;
}

// Reset hover confirmation
if !hovering
	folder_timer = -1;