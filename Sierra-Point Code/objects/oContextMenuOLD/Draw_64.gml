#region Variables

// Right Click
var _click_left_pressed	= device_mouse_check_button_pressed(0, mb_left);
	
// Get size of list
var _gridHeight = ds_grid_height(cm_grid);

// Padding added on the sides and for break
var _outsidePadding = 300;
	
var _slotHeight = 0;	// Current height to calculate

// Check if hovering over contextMenu
var _hovering = false;

#endregion

// Set Font
draw_set_font(ftContextMenu);

#region Draw background

// Draw background
draw_set_color(c_dkgray);
	draw_rectangle(mp_gui_x, mp_gui_y, mp_gui_x + width, mp_gui_y + cm_background_height, false);
draw_set_color(-1);
	
// Draw outline
draw_rectangle(mp_gui_x, mp_gui_y, mp_gui_x + width, mp_gui_y + cm_background_height, true);
	
#endregion
	
#region Draw & recieve data

for(var i = 0; i < _gridHeight; i++)
{
	// Get data
	var _string = ds_grid_get(cm_grid, 0, i);
	var _script = ds_grid_get(cm_grid, 1, i);	
	var _folder = ds_grid_get(cm_grid, 2, i);
	var _scriptArg = ds_grid_get(cm_grid, 3, i);
		
	if _string == "break"
	{						
		var height_level = mp_gui_y + _slotHeight
		
		// Draw Line
		draw_set_alpha(0.4);
			draw_line(mp_gui_x + padding, height_level + 2, mp_gui_x + width - padding, height_level + 2)
		draw_set_alpha(1);
			
		// Add height to slot
		_slotHeight += padding;
	}
	else
	{			
		var height_level = mp_gui_y + _slotHeight;
		
		// Draw data
		draw_text(mp_gui_x + padding, height_level, _string);
				
		// Draw folder icon
		if _folder
			draw_triangle(mp_gui_x + ((width/15)*13.5), height_level + 4, mp_gui_x + ((width/15)*13.5), height_level + height - 4, mp_gui_x + width - 7, height_level + (height/2), true);
		
		#region Hover highlight and click
		
		// Check for mouse hover
		if get_hover(mp_gui_x, height_level, mp_gui_x + width, height_level + height)
		{	
			_hovering = true;
			
			#region Hover over a slot for a while
			
			if folder_timer = i + 0.1
			{
				// If hovering slot is a folder then open
				if _folder
				{
					if _scriptArg != -1
						script_execute_ext(_script, _scriptArg);
					else
						script_execute(_script);
				}
				else
				{
					var _level = level;
					
					with(oPlayer)
					{
						var _listSize = ds_list_size(contextInstList);
							
						// Check if not already in list
						for(var o = 0; o < _listSize; o++)
						{
							var _contextMenu = ds_list_find_value(contextInstList, o);
							if _contextMenu.level == _level + 1
							{
								close_context(_contextMenu);
							}
						}
					}
				}
			}
			else
			{				
				// Start timer
				if folder_timer != i
				{
					folder_timer = i;
										
					alarm[0] = 0.5 * room_speed;
				}
			}
			
			#endregion
			
			#region Execute Script
			
			if _click_left_pressed
			{
				// Execute script	
				if _scriptArg != -1
					script_execute_ext(_script, _scriptArg);
				else
					script_execute(_script);
					
				// Stop loop
				break;
			}
			
			#endregion
			
			#region Draw Highlight
			
			draw_set_alpha(0.2);
				// Draw highlight
				draw_rectangle(mp_gui_x,		height_level, mp_gui_x + width,		height_level + height, false);
			draw_set_alpha(1);
				// Draw outline
				draw_rectangle(mp_gui_x,		height_level, mp_gui_x + width,		height_level + height, true);
				draw_rectangle(mp_gui_x - 1, height_level, mp_gui_x + width + 1,	height_level + height, true);
				
			#endregion
		}
		
		#endregion
		
		// Add height to slot
		_slotHeight += height;
	}
}

// Reset hover confirmation
if !_hovering
	folder_timer = -1;
	
#endregion

// Reset Font
draw_set_font(ftDefault);

#region Move Context menu if out of screen

var _displayWidth = display_get_gui_width();
var _displayHeight = display_get_gui_height();

var _rightSidePos = (mp_gui_x + width + (padding * 2));
var _bottomSidePos = (mp_gui_y + (height*_gridHeight) + (padding * 2));

if _rightSidePos > _displayWidth
{
	mp_gui_x -= _rightSidePos - _displayWidth;
}

if _bottomSidePos > _displayHeight
{
	mp_gui_y -= _bottomSidePos - _displayHeight;
}

#endregion

#region Close when mouse is far away

with(oPlayer)
{
	// Check if context menu is main
	var _main = ds_list_find_value(contextInstList, 0);
}

if _main
{
	if !get_hover(mp_gui_x - _outsidePadding, mp_gui_y - _outsidePadding, mp_gui_x + width + _outsidePadding, mp_gui_y + (height*_gridHeight) + _outsidePadding)
	{
		close_context(-1);
	}
}
else
{
	if !get_hover(mp_gui_x - _outsidePadding - (width/2), mp_gui_y - _outsidePadding, mp_gui_x + width + _outsidePadding, mp_gui_y + (height*_gridHeight) + _outsidePadding)
	{
		close_context(id);
	}
}

#endregion

#region Exit contextMenu
	
// Stop contextMenu if not hovering over a slot
if _click_left_pressed
{
	// Check all context menus
	_hovering = false;
	
	// Check if not hovering over other menus
	with(oPlayer)
	{
		var _size = ds_list_size(contextInstList)
	
		for(var i = 0; i < _size; i++)
		{
			var _contextMenu = ds_list_find_value(contextInstList, i);
				
			with(_contextMenu)
			{					
				// Check if hovering over background
				if get_hover(mp_gui_x, mp_gui_y, mp_gui_x + width, mp_gui_y + cm_background_height)
				{
					_hovering = true;
						
				}
			}
		}
	}
	
	if !_hovering
		close_context(-1);
}

#endregion