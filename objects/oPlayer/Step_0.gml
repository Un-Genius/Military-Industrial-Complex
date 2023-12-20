#region Keys

// Movement Keys
var _key_up		= keyboard_check(ord("W"));
var _key_down	= keyboard_check(ord("S"));
var _key_left	= keyboard_check(ord("A"));
var _key_right	= keyboard_check(ord("D"));

// Raw Input
var _key_rawInput = keyboard_key;

// Additional button
var _key_ctrl	= keyboard_check(vk_control);

// Get mouse button states
var _click_left_pressed = device_mouse_check_button_pressed(0, mb_left);
var _click_left_released = device_mouse_check_button_released(0, mb_left);

var _click_right_pressed = device_mouse_check_button_pressed(0, mb_right);
var _click_right_released = device_mouse_check_button_released(0, mb_right);

// Handle left click
if (_click_left_pressed)
{
    left_mouse_state = mouse_type.pressed;
	mouseLeftPress_x = mouse_x;
	mouseLeftPress_y = mouse_y;
}
else
{
	if (_click_left_released)
	{
	    if (current_time - last_left_click_time <= double_click_threshold)
		{
	        left_mouse_state = mouse_type.released_twice;
	    }
		else
		{
			left_mouse_state = mouse_type.released;
			last_left_click_time = current_time;
	    }
	}
	else
		if left_mouse_state == mouse_type.released || left_mouse_state == mouse_type.released_twice
			left_mouse_state = mouse_type.noone;
}

// Handle right click
if (_click_right_pressed)
{
    right_mouse_state = mouse_type.pressed;
	mouseRightPress_x = mouse_x;
	mouseRightPress_y = mouse_y;
}
else
{
	if (_click_right_released)
	{
		var _difference = current_time - last_right_click_time;
	    if (_difference <= double_click_threshold)
		{
	        right_mouse_state = mouse_type.released_twice;
		}
		else
		{
			right_mouse_state = mouse_type.released;
			last_right_click_time = current_time;
	    }
	}
	else
		if right_mouse_state == mouse_type.released || right_mouse_state == mouse_type.released_twice
			right_mouse_state = mouse_type.noone;
}


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
	path_goal_multiplayer_update(x, y, goal_x, goal_y);
	
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
if left_mouse_state == mouse_type.released_twice && instance_selected != noone
{
	// Find name of selected instance
	//var _objName	= object_get_name(instance_selected.object_index);
	//var _objAsset	= asset_get_index(_objName);
	
	var _object = instance_selected.object_index;
		
	with _object
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