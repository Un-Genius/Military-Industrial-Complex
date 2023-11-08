#region Keys

// Movement Keys
var _key_up		= keyboard_check(ord("W"));
var _key_down	= keyboard_check(ord("S"));
var _key_left	= keyboard_check(ord("A"));
var _key_right	= keyboard_check(ord("D"));

// Additional button
var _key_ctrl	= keyboard_check(vk_control);

// Left Click
var _click_left_pressed		= device_mouse_check_button_pressed(0, mb_left);
var _click_left_released	= device_mouse_check_button_released(0, mb_left);

// Right Click
var _click_right_pressed	= device_mouse_check_button_pressed(0, mb_right);
var _click_right_released	= device_mouse_check_button_released(0, mb_right);

// Raw Input
var _key_rawInput = keyboard_key;

#region Double Click

var _click_left_double = false;
var _click_right_double = false;

if doublePress == 3
{
	_click_right_double = true;
	
	// Reset
	doublePress = 0;
}
else
{
	if doublePress == 1
	{	
		if _click_left_pressed
		{
			doublePress = 2;
			_click_left_double = true;
		}
	
		if _click_right_pressed
		{
			doublePress = 2;
			_click_right_double = true;
		}
	}
	else
	{
		// If pressed, 
		if _click_left_pressed
		{
			doublePress = 1;
			alarm[0] = 0.25 * room_speed;
		}

		// If pressed, 
		if _click_right_pressed
		{
			doublePress = 1;
			alarm[1] = 0.25 * room_speed;
		}
	}
}

#endregion

#endregion

#region Player Movement and Sprite

// Movement calculation
var _hsp = _key_right - _key_left;
var _vsp = _key_down	- _key_up;

// Faster when moving for longer
if _vsp != 0 || _hsp != 0
	movementSpeed = clamp(movementSpeed + 0.08, 3, 20);
else
	movementSpeed = clamp(movementSpeed - 1, 3, 20);
	
// Sprite aims towards mouse
image_angle = point_direction(x, y, mouse_x, mouse_y) - 90;

// Set in motion
x += _hsp * movementSpeed;
y += _vsp * movementSpeed;

clamp_to_room();

if x != xprevious || y != yprevious
{
	// Update doppelganger
	path_goal_multiplayer_update(x, y, pathGoalX, pathGoalY);
	
	xprevious = x;
	yprevious = y;
}

#endregion

zoning_switch()
zoning_display()

instance_selected		= noone;
instances_selected_list = ds_grid_width(global.instGrid);

select_instance();
context_menu_open();
mouse_box_close();
create_zone();
mouse_box();

#region Double select

// Double click an instance
if _click_left_double && instance_selected != noone
{
	// Find name of selected instance
	var _objName	= object_get_name(instance_selected.object_index);
	var _objAsset	= asset_get_index(_objName);
		
	with _objAsset
	{
		// Get current camera position
		var _camX = camera_get_view_x(view_camera[0]);
		var _camY = camera_get_view_y(view_camera[0]);
		var _camW = camera_get_view_width(view_camera[0]);
		var _camH = camera_get_view_height(view_camera[0]);
		
		if bbox_right	> _camX
		&& bbox_left	< _camX + _camW
		&& bbox_bottom	> _camY
		&& bbox_top		< _camY + _camH
		{
			// Add inst to hand
			add_Inst(global.instGrid, 0, id);
			
			selected = true;
		}
	}
}

#endregion

#region Store hand in keys

// Check for input
if _key_rawInput
{
	var _height		= ds_grid_height(global.instGrid);
	
	// Find correct number
	for(var i = 0; i < _height - 2; i++)
	{		
		if _key_rawInput == ord(string(i))
		{
			for(var o = 0; o < instances_selected_list; o++)
			{
				var _hand = ds_grid_get(global.instGrid, o, 0);
				
				if _key_ctrl
				{
					// Replace key with hand					
					ds_grid_set(global.instGrid, o, i, _hand);
				}
				else
				{
					// Replace hand with key
					var _key = ds_grid_get(global.instGrid, o, i);
					
					if _hand != 0
						_hand.selected = false;
										
					if _key != 0
						_key.selected = true;
					
					ds_grid_set(global.instGrid, o, 0, _key);
				}				
			}
			break;
		}
	}
}

#endregion