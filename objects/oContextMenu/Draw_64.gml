#region Variables

// Right Click
var _click_left_pressed	= device_mouse_check_button_pressed(0, mb_left);
	
// Get size of list
var _gridHeight = ds_grid_height(contextGrid);

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
	draw_rectangle(mousePressGui_x, mousePressGui_y, mousePressGui_x + width, mousePressGui_y + backgroundHeight, false);
draw_set_color(-1);
	
// Draw outline
draw_rectangle(mousePressGui_x, mousePressGui_y, mousePressGui_x + width, mousePressGui_y + backgroundHeight, true);
	
#endregion
	
#region Draw & recieve data

for(var i = 0; i < _gridHeight; i++)
{
	// Get data
	var _string = ds_grid_get(contextGrid, 0, i);
	var _script = ds_grid_get(contextGrid, 1, i);	
	var _folder = ds_grid_get(contextGrid, 2, i);
		
	if _string == "break"
	{						
		var heightLevel = mousePressGui_y + _slotHeight
		
		// Draw Line
		draw_set_alpha(0.4);
			draw_line(mousePressGui_x + padding, heightLevel + 2, mousePressGui_x + width - padding, heightLevel + 2)
		draw_set_alpha(1);
			
		// Add height to slot
		_slotHeight += padding;
	}
	else
	{			
		var heightLevel = mousePressGui_y + _slotHeight;
		
		// Draw data
		draw_text(mousePressGui_x + padding, heightLevel, _string);
				
		// Draw folder icon
		if _folder
			draw_triangle(mousePressGui_x + ((width/15)*13.5), heightLevel + 4, mousePressGui_x + ((width/15)*13.5), heightLevel + height - 4, mousePressGui_x + width - 10, heightLevel + (height/2), true);
		
		#region Hover highlight and click
		
		// Check for mouse hover
		if get_hover(mousePressGui_x, heightLevel, mousePressGui_x + width, heightLevel + height)
		{	
			_hovering = true;
			
			#region Hover over a slot for a while
			
			if openMenu = i + 0.1
			{
				// If hovering slot is a folder then open
				if _folder
				{
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
				if openMenu != i
				{
					openMenu = i;
										
					alarm[0] = 0.5 * room_speed;
				}
			}
			
			#endregion
			
			#region Execute Script
			
			if _click_left_pressed
			{
				// Execute script	
				script_execute(_script);
					
				// Stop loop
				break;
			}
			
			#endregion
			
			#region Draw Highlight
			
			draw_set_alpha(0.2);
				// Draw highlight
				draw_rectangle(mousePressGui_x,		heightLevel, mousePressGui_x + width,		heightLevel + height, false);
			draw_set_alpha(1);
				// Draw outline
				draw_rectangle(mousePressGui_x,		heightLevel, mousePressGui_x + width,		heightLevel + height, true);
				draw_rectangle(mousePressGui_x - 1, heightLevel, mousePressGui_x + width + 1,	heightLevel + height, true);
				
			#endregion
		}
		
		#endregion
		
		// Add height to slot
		_slotHeight += height;
	}
}

// Reset hover confirmation
if !_hovering
	openMenu = -1;
	
#endregion

// Reset Font
draw_set_font(ftDefault);

#region Move Context menu if out of screen

var _displayWidth = display_get_gui_width();
var _displayHeight = display_get_gui_height();

var _rightSidePos = (mousePressGui_x + width + (padding * 2));
var _bottomSidePos = (mousePressGui_y + (height*_gridHeight) + (padding * 2));

if _rightSidePos > _displayWidth
{
	mousePressGui_x -= _rightSidePos - _displayWidth;
}

if _bottomSidePos > _displayHeight
{
	mousePressGui_y -= _bottomSidePos - _displayHeight;
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
	if !get_hover(mousePressGui_x - _outsidePadding, mousePressGui_y - _outsidePadding, mousePressGui_x + width + _outsidePadding, mousePressGui_y + (height*_gridHeight) + _outsidePadding)
	{
		close_context(-1);
	}
}
else
{
	if !get_hover(mousePressGui_x - _outsidePadding - (width/2), mousePressGui_y - _outsidePadding, mousePressGui_x + width + _outsidePadding, mousePressGui_y + (height*_gridHeight) + _outsidePadding)
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
				if get_hover(mousePressGui_x, mousePressGui_y, mousePressGui_x + width, mousePressGui_y + backgroundHeight)
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