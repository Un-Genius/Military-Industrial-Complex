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
	moveSpd = clamp(moveSpd + 0.08, 3, 20);
else
	moveSpd = clamp(moveSpd - 1, 3, 20);
	
// Sprite aims towards mouse
image_angle = point_direction(x, y, mouse_x, mouse_y) - 90;

// Set in motion
x += _hsp * moveSpd;
y += _vsp * moveSpd;

#region Clamp to room

//Clamp Objects position to be inside the (tiled) room space
var xbuf = 37;
var ybuf = 34;

x = clamp(x, xbuf, room_width - xbuf); 
y = clamp(y, ybuf, room_height - ybuf + 2);

#endregion

if x != xprevious || y != yprevious
{
	// Send position and rotation to others
	// Find self in list
	var _pos = ds_list_find_index(global.unitList, id)

	// Send position and rotation to others
	var _packet = packet_start(packet_t.move_unit);
	buffer_write(_packet, buffer_u16, _pos);
	buffer_write(_packet, buffer_f32, x);
	buffer_write(_packet, buffer_f32, y);
	packet_send_all(_packet);
}

#endregion

// Vars
var _instFind	= noone;
var _width		= ds_grid_width(global.instGrid);

// Selecting, Context Menu, Mousebox, Riding Vehicles
if buildingPlacement == noone
{
	// Find and select instances
	if _click_left_pressed && !contextMenu
	{
		#region Find instance
	
		if instance_exists(oParSquad)
			_instFind = find_top_Inst(mouse_x, mouse_y, oParSquad);
		else
			if instance_exists(oParUnit)
				_instFind = find_top_Inst(mouse_x, mouse_y, oParUnit);
		
		#endregion

		#region Check if already selected
	
		var _selectx2 = false;
		if find_Inst(global.instGrid, 0, _instFind) > -1
			_selectx2 = true;
		
		#endregion

		#region Unselect with conditions

		if !_key_ctrl && !_selectx2
		{		
			// Wipe holding hand
			wipe_Hand(global.instGrid, 0);
		}
		
		#endregion
	
		#region Add inst to hand
	
		if _instFind != noone
		{
			// Add to hand
			add_Inst(global.instGrid, 0, _instFind);
			
			// Set selected
			_instFind.selected = true;
		}
	
		#endregion
	
		#region Unselect if pressed on again
	
		if _key_ctrl && _selectx2
		{
			if _instFind.selected
			{
				var _x = find_Inst(global.instGrid, 0, _instFind);
			
				if _x != -1
					wipe_Slot(global.instGrid, _x, 0);
			}
		}
	
		#endregion

		#region Remember location of press

		// Mouse box starting position
		mouseLeftPress_x = device_mouse_x(0);
		mouseLeftPress_y = device_mouse_y(0);
	
		if _instFind == noone
			// Start mousebox
			mousePress = 1;	
		else
			// Allow dragging
			mousePress = 2;
		
		#endregion
	}
	
	#region Select with right click - Cancelled
	
	/*
	// Select with right click
	if _click_right_released
	{
		// Check if units selected
		if ds_grid_get(global.instGrid, 0, 0) == 0
		{
			#region Find instance
	
			if instance_exists(oParUnit)
				_instFind = find_top_Inst(mouse_x, mouse_y, oParUnit);
		
			#endregion
			
			#region Add inst to hand
	
			if _instFind != noone
			{
				// Add to hand
				add_Inst(global.instGrid, 0, _instFind);
			
				// Set selected
				_instFind.selected = true;
			}
	
			#endregion
			
			_click_right_double = true;
		}
	}
	*/
	
	#endregion
	
	// Context Menu
	if _click_right_released
	{
		// Reset context
		close_context(-1);
		
		#region Set and get data
		
		// Set to true
		contextMenu = true;
	
		// Update position
		mouseRightPressGui_x	= device_mouse_x_to_gui(0);
		mouseRightPressGui_y	= device_mouse_y_to_gui(0);
	
		mouseRightPress_x		= device_mouse_x(0);
		mouseRightPress_y		= device_mouse_y(0);
	
		var _mouseRightPress_x = mouseRightPress_x;
		var _mouseRightPress_y = mouseRightPress_y;
		
		// Create context menu
		var _inst = create_context(mouseRightPressGui_x, mouseRightPressGui_y);
	
		// Spawn Units through a unit
		instRightSelected = find_top_Inst(_mouseRightPress_x, _mouseRightPress_y, oParUnit);
	
		var _instSel = instRightSelected;
		
		#endregion
		
		// Add buttons
		with(_inst)
		{
			if(!instance_exists(_instSel))
			{
				var _size = ds_grid_width(global.instGrid);
				
				// Check if any units are selected
				for(var i = 0; i < _size; i++)
				{
					var _value = ds_grid_get(global.instGrid, i, 0);
					
					if(instance_exists(_value))
					{
						// Move Unit
						add_context("Move", scr_context_move, false);
						add_context("break", on_click, false);
						break;
					}
				}
				
				// Select multiple instances
				//add_context("Select all",			scr_context_select_all, false);
				add_context("Select all on screen", scr_context_select_onScreen, false);
			}
			else
			{
				with(_instSel)
				{
					goalX = x;
					goalY = y;
					moveState = action.idle;
				
					var _objectIndex = object_index;
					var _x = x;
					var _y = y;
					var _resCarry = resCarry;
					var _resRange = resRange;
					var _maxResCarry = maxResCarry;
				}
				
				switch(_objectIndex)
				{
					case oHQ:
						// Spawn units
						add_context("Spawn Units", scr_context_folder_HQspawn, true);
						break;
			
					case oHAB:
						// Spawn troops, Destroy self
						if _resCarry > 0
						{
							add_context("Spawn Units", scr_context_folder_HABspawn, true);
							add_context("break", on_click, false);
							add_context("Destroy Self", scr_context_destroy, false);
						}
						
						// Search for nearby vehicles
						var _LOG = collision_circle(_x, _y, _resRange, oTransport, false, true);
		
						// Transfer supplies
						if _LOG && _LOG.resCarry > 0
						{
							if _resCarry <= 0
								add_context("break", on_click, false);
							add_context("Grab Resources", scr_context_grab_res,	 false);
						}
						break;
					
					case oTransport:
						// Move unit
						add_context("Move", scr_context_move, false);
						
						// Dismount troops
						if ds_list_size(_instSel.riderList) > 0
						{
							add_context("break", on_click, false);
							add_context("Exit Vehicle", exit_Vehicle_All, false);
						}
					
						// Spawn Units
						if _resCarry > 0
						{
							add_context("break", on_click, false);
							add_context("Spawn Units", scr_context_folder_LOGspawn, true);
						}
				
						// Search for nearby building
						var _HAB = collision_circle(_x, _y, _resRange, oHAB, false, true);
		
						// Transfer supplies
						if _HAB
						{
							if _resCarry <= 0
								add_context("break", on_click, false);
							
							// Check if can give resources
							if _resCarry > 0
								add_context("Drop Resources", scr_context_drop_res,	 false);
							
							// Take resourcess
							if _resCarry != _maxResCarry && _HAB.resCarry > 0
								add_context("Grab Resources", scr_context_grab_res,	 false);
						}
						break;
				}
			}
			
			if(global.debugMenu)
			{
				add_context("break", on_click, false);
				add_context("Spawn Dummy",		scr_context_spawn_dummy, false);
			}
		
			// Update size
			event_user(0);
		}
	}

	// Stop mouseBox
	if _click_left_released && !contextMenu
	{
		mousePress = false;
	
		mouseLeftReleased_x = device_mouse_x(0);
		mouseLeftReleased_y = device_mouse_y(0);
	}
}
else
{
	var _halfW = (buildingPlacement.sprite_width * buildingPlacement.image_xscale)/3.5;
	var _halfH = (buildingPlacement.sprite_height * buildingPlacement.image_yscale)/3.5;
		
	var _collision	= collision_rectangle(mouse_x - _halfW, mouse_y - _halfH, mouse_x + _halfW, mouse_y + _halfH, oCollision, false, true)
	var _distance	= point_distance(instRightSelected.x, instRightSelected.y, mouse_x, mouse_y);
		
	// Check if intersecting with walls or units
	if _collision || _distance > buildingPlacement.resRange + (_halfW + _halfH)/2
	{
		buildingIntersect = true;
	}
	else
	{
		buildingIntersect = false;
	}
	
	if _click_left_pressed
	{
		// Check transport for resources
		if instRightSelected.resCarry - unitResCost.HAB < 0
		{
			// Delete ghost
			instance_destroy(buildingPlacement);
		
			// Reset variables
			buildingPlacement = noone;
			buildingIntersect = false;
		}
		else
		{	
			// check for mouse click
			if !buildingIntersect
			{
				// Take away resources
				instRightSelected.resCarry -= unitResCost.HAB;
			
				// Create instance
				spawn_unit(buildingName, mouse_x, mouse_y);
		
				// Delete ghost
				instance_destroy(buildingPlacement);
		
				// Reset variables
				buildingName = "";
				buildingPlacement = noone;
				buildingIntersect = false;
			}
		}
	}
	else
	{
		if _click_right_pressed
		{
			// Delete ghost
			instance_destroy(buildingPlacement);
		
			// Reset variables
			buildingName = "";
			buildingPlacement = noone;
			buildingIntersect = false;
		}
	}
}

#region Double select

// Double click an instance
if _click_left_double && _instFind != noone
{
	// Find name of selected instance
	var _objName	= object_get_name(_instFind.object_index);
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
			for(var o = 0; o < _width; o++)
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