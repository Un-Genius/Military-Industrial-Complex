#region Get data

var _key_ctrl				= keyboard_check(vk_control);
var _click_left_released	= mouse_check_button_released(mb_left);

var _mouse_x = device_mouse_x(0);
var _mouse_y = device_mouse_y(0);

with(oPlayer)
{
	// MouseBox data
	var _mousePress	= mousePress;
	
	var _mousePress_x = mouseLeftPress_x;
	var _mousePress_y = mouseLeftPress_y;
}

var _mouseDragAmount = point_distance(_mousePress_x, _mousePress_y, _mouse_x, _mouse_y);

#endregion

#region MouseBox

// Check for mouseBox
if _mousePress == 1
{
	// Check for collision
	if collision_rectangle(_mousePress_x, _mousePress_y, mouse_x, mouse_y, self, false, false)
	{
		add_Inst(global.instGrid, 0, id);
		selected = true;
	}
	else
	{
		#region Unselect from mouseBox
		
		if !_key_ctrl
		{
			var _x = find_Inst(global.instGrid, 0, id);
			if _x != -1
				wipe_Slot(global.instGrid, _x, 0);
		}

		#endregion
	}
}

#endregion

#region Selecting & Dragging unit around

if selected && _mousePress == 2 && _mouseDragAmount >= 3
{
	release = true;
}

if _click_left_released && release
{
	// Drop instance
	release = false;
	
	// Set goal
	goalX	= _mouse_x;
	goalY	= _mouse_y;
	
	// Update children
	event_user(1);
}

#endregion

#region Update position

var _size = ds_list_size(childList);

var _x = 0;
var _y = 0;

// Find average
for(var i = 0; i < _size; i++)
{
	var _inst = ds_list_find_value(childList, i);
	
	_x += _inst.x;
	_y += _inst.y;
}

// calculate average
_x = _x/_size;
_y = _y/_size;

// Overwrite current position
x = _x;
y = _y;

#endregion

#region Resources

// Check if needed
if resCarry != maxResCarry
{
	var _HQ = collision_circle(x, y, resRange, oHQ, false, true);
		
	// Check if HAB or HQ nearby
	if _HQ
	{
		resCarry = maxResCarry;
	}
	else
	{
		// Get resources if not transport
		if object_index != oTransport
		{
			var _HAB = collision_circle(x, y, resRange, oHAB, false, true);
		
			if _HAB && _HAB.resCarry > 0
			{
				// Find needed resources
				var _reqRes = maxResCarry - resCarry;
			
				// Find how much resources other can supply
				_reqRes -= _HAB.resCarry;
			
				// Fill request
				if _reqRes - _HAB.resCarry < 0
				{
					resCarry = maxResCarry;
					_HAB.resCarry -= maxResCarry;
				}
				else
				{
					resCarry = _reqRes - _HAB.resCarry;
					_HAB.resCarry -= _HAB.resCarry;
				
				}
			}
			else
			{
				var _TRANS = collision_circle(x, y, resRange, oTransport, false, true);
				
				if _HAB && _HAB.resCarry > 0
				{
					// Find needed resources
					var _reqRes = maxResCarry - resCarry;
			
					// Find how much resources other can supply
					_reqRes -= _TRANS.resCarry;
			
					// Fill request
					if _reqRes - _TRANS.resCarry < 0
					{
						resCarry = maxResCarry;
						_TRANS.resCarry -= maxResCarry;
					}
					else
					{
						resCarry = _reqRes - _TRANS.resCarry;
						_TRANS.resCarry -= _TRANS.resCarry;
					}
				}
			}
		}
	}
}

#endregion

#region Suppressed effect

// Suppress effect comes from the proximmity of a bullet
// Check bullet code for more

// Check if suppressed
if(suppressMax != 0 && suppressMax <= suppressAmount)
{
	// Cause a suppressed effect
	suppressed = true;
		
	// Max out
	if(suppressAmount > suppressMax*2)
	{
		suppressAmount = suppressMax*2;
	}
}

#endregion

#region Enter/Chase Vehicle - DISABLED
/*
if enterVeh != noone && type == unitType.inf
{	
	with enterVeh
	{
		// Find new position
		var _newX = x - lengthdir_x(((sprite_width/2)*image_xscale) + 28, image_angle);
		var _newY = y - lengthdir_y(((sprite_width/2)*image_xscale) + 28, image_angle);
	}
	
	if point_distance(_newX, _newY, goalX, goalY) > 4
	{	
		for(var i = 0; i < hp; i++)
		{
			var _inst = ds_list_find_value(childList, i);
			
			with(_inst)
			{
				moveState = action.idle

				veh_position(enterVeh);
			}
		}

	}
	else
	{
		if point_distance(x, y, _newX, _newY) < 8
		{
			for(var i = 0; i < hp; i++)
			{
				var _inst = ds_list_find_value(childList, i);
			
				with(_inst)
				{
					enter_Vehicle_One(enterVeh);
				}
			}
		}
	}
}
*/
#endregion

#region Reactive after leaving Vehicle - DISABLED
/*
if riding
{
	with(enterVeh)
	{
		// Find new position
		var _newX = x - lengthdir_x(((sprite_width/2)*image_xscale) + 28, image_angle);
		var _newY = y - lengthdir_y(((sprite_width/2)*image_xscale) + 28, image_angle);
	}

	// Update Children position
	var _size = ds_list_size(childList);

	// Find average
	for(var i = 0; i < _size; i++)
	{
		var _inst = ds_list_find_value(childList, i);
	
		with(_inst)
		{
			x = _newX;
			y = _newY;
		
			// set as goal
			goalX = _newX;
			goalY = _newY;
			
			// Delete from vehicles list
			var _index = ds_list_find_index(enterVeh.riderList, id)
			ds_list_delete(enterVeh.riderList, _index);
	
			// Reset variables
			enterVeh	= noone;
			riding		= false;
		}
	}
}
*/
#endregion

#region Health

if hp <= 0
	instance_destroy(self);

#endregion

// sorting
depth -= y - 100;