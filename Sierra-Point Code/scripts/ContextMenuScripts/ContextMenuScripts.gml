function cm_background()
{
	// Draw background
	draw_set_color(c_dkgray);
		draw_rectangle(mp_gui_x, mp_gui_y, mp_gui_x + width, mp_gui_y + cm_background_height, false);
	draw_set_color(-1);
	
	// Draw outline
	draw_rectangle(mp_gui_x, mp_gui_y, mp_gui_x + width, mp_gui_y + cm_background_height, true);
}

function cm_break(i, _string)
{		
	if _string != "break"
		return false
		
	var _height_level = mp_gui_y + slot_height
		
	// Draw Line
	draw_set_alpha(0.4);
		draw_line(mp_gui_x + padding, _height_level + 2, mp_gui_x + width - padding, _height_level + 2)
	draw_set_alpha(1);
		
	// Add height to slot
	slot_height += padding;
	
	return true
}

function cm_folder(i)
{
	// Get data
	var _folder = ds_grid_get(cm_grid, 2, i);
	
	var height_level = mp_gui_y + slot_height;
		
	// Draw data
	draw_text(mp_gui_x + padding, height_level, _string);
	
	cm_triangle();
				

}

function cm_triangle()
{
	var _folder = ds_grid_get(cm_grid, 2, i);
	
	// Draw folder icon
	if !_folder
		exit;
		
	// Define the base position and size variables
	var base_x = mp_gui_x;
	var base_y = height_level;
	var triangle_width = width;
	var triangle_height = height;

	// Calculate the coordinates for the three points of the triangle
	var point1_x = base_x + ((triangle_width / 15) * 13.5);
	var point1_y = base_y + 4;

	var point2_x = base_x + ((triangle_width / 15) * 13.5);
	var point2_y = base_y + triangle_height - 4;

	var point3_x = base_x + triangle_width - 7;
	var point3_y = base_y + (triangle_height / 2);

	// Now use the variables to draw the triangle
	draw_triangle(point1_x, point1_y, point2_x, point2_y, point3_x, point3_y, true);
}

function cm_file_expand(i)
{
	// Start timer
	if folder_timer != i
	{
		folder_timer = i;
										
		alarm[0] = 0.5 * room_speed;
	}
	
	if folder_timer < i + 0.1
		exit;
		
	var _script = ds_grid_get(cm_grid, 1, i);	
	var _folder = ds_grid_get(cm_grid, 2, i);
	var _scriptArg = ds_grid_get(cm_grid, 3, i);
		
	if !_folder
	{
		var _level = level;
					
		var _list = oPlayer.contextInstList;
		
		var _listSize = ds_list_size(_list);
							
		// Check if not already in list
		for(var o = 0; o < _listSize; o++)
		{
			var _contextMenu = ds_list_find_value(_list, o);
			if _contextMenu.level != _level + 1
				continue;
				
			close_context(_contextMenu);
		}
		
		exit;
	}
	
	if _scriptArg != -1
		script_execute_ext(_script, _scriptArg);
	else
		script_execute(_script);
}

function cm_execute(i)
{
	if !click_left_pressed
		exit;
	
	var _script = ds_grid_get(cm_grid, 1, i);	
	var _script_arg = ds_grid_get(cm_grid, 3, i);
	
	if _script == 0
		exit;

	if _script_arg != -1
		script_execute_ext(_script, _script_arg);
	else
		script_execute(_script);
}

function cm_highlight()
{
	var _x2 = mp_gui_x + width;
	var _y2 = height_level + height;
	
	draw_set_alpha(0.2);
		// Draw highlight
		draw_rectangle(mp_gui_x, height_level, _x2, _y2, false);
	draw_set_alpha(1);
	
	// Draw outline
	draw_rectangle(mp_gui_x, height_level, _x2, _y2, true);
	draw_rectangle(mp_gui_x - 1, height_level, _x2 + 1, _y2, true);
}

function cm_update_position()
{
	var _displayWidth = display_get_gui_width();
	var _displayHeight = display_get_gui_height();

	var _rightSidePos = (mp_gui_x + width + (padding * 2));
	var _bottomSidePos = (mp_gui_y + (height*grid_height) + (padding * 2));

	if _rightSidePos > _displayWidth
	{
		mp_gui_x -= _rightSidePos - _displayWidth;
	}

	if _bottomSidePos > _displayHeight
	{
		mp_gui_y -= _bottomSidePos - _displayHeight;
	}
}

function cm_close_distance()
{
	var _main = ds_list_find_value(oPlayer.contextInstList, 0);
	var _inst = -1;
	var _x1 = mp_gui_x - outside_padding;
	var _x2 = mp_gui_x + width + outside_padding;
	var _y1 = mp_gui_y - outside_padding;
	var _y2 = mp_gui_y + (height*grid_height) + outside_padding
	
	if !_main
	{
		_inst = id;
		_x1 = mp_gui_x - outside_padding - (width/2);
	}
	
	hovering_proximity = get_hover(_x1, _y1,_x2, _y2)
	if hovering_proximity
		exit;

	close_context(_inst);
}

function cm_close()
{
	if !click_left_pressed
		exit;
	
	// Check if not hovering over other menus
	var _list = oPlayer.contextInstList
	var _size = ds_list_size(_list)
	
	for(var i = 0; i < _size; i++)
	{
		var _contextMenu = ds_list_find_value(_list, i);

		if !_contextMenu.hovering
			continue;
			
		hovering = true;
	}
	
	if hovering
		exit;
	
	close_context(-1);
}