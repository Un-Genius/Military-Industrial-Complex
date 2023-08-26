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

#region Clamp to room

//Clamp Objects position to be inside the (tiled) room space
var xbuf = 37;
var ybuf = 34;

x = clamp(x, xbuf, room_width - xbuf); 
y = clamp(y, ybuf, room_height - ybuf + 2);

#endregion

if x != xprevious || y != yprevious
{
	// Update doppelganger
	path_goal_multiplayer_update(x, y, pathGoalX, pathGoalY);
	
	xprevious = x;
	yprevious = y;
}

#endregion

#region Zoning

maxTroopsInf = 0;

// Toggle Zoning tool
if (keyboard_check_pressed(vk_anykey))
{
	var _tempZoningObject = zoning;
	
    switch (keyboard_lastkey)
    {
        case ord("1"):
            zoning = (zoning == objectType.oZoneCamp) ? -1 : objectType.oZoneCamp;
            break;
        
        case ord("2"):
            zoning = (zoning == objectType.oZoneMoney) ? -1 : objectType.oZoneMoney;
            break;
        
        case ord("3"):
            zoning = (zoning == objectType.oZoneSupplies) ? -1 : objectType.oZoneSupplies;
            break;
        
        case ord("4"):
            zoning = (zoning == objectType.oZoneBootCamp) ? -1 : objectType.oZoneBootCamp;
            break;
        
        case ord("5"):
            zoning = (zoning == objectType.oInfantry) ? -1 : objectType.oInfantry;
            break;
        
        default: break;
    }
	
	if instance_exists(buildingPlaceholder)
	{
		if zoning != -1
		{
			if(_tempZoningObject != zoning)
			{
				_tempZoningObject = zoning;
				
				with(buildingPlaceholder)
				{
					buildingType = _tempZoningObject;
					event_user(0);
				}
			}
		}
		else
		{
			instance_destroy(buildingPlaceholder);
			buildingPlaceholder = noone;
		}
	}
}

// Zoning functionality
if(zoning > -1 && !global.mouseUI)
{
	var _cost	= oManager.unitCost[zoning];;
	
	if buildingPlaceholder == noone
	{
		buildingPlaceholder = instance_create_layer(mouse_x, mouse_x, layer, oBuildingTool)
		
		var _zoning = zoning;
		with buildingPlaceholder
		{
			buildingType = _zoning;
			event_user(0);
		}
	}
}

#endregion

#region Selecting, Context Menu, Mousebox
// Vars
var _instFind	= noone;
var _instancesInHandList		= ds_grid_width(global.instGrid);

// Selecting, Context Menu, Mousebox
if buildingPlacement == noone && zoning == -1
{
	// Find and select instances
	if _click_left_pressed && !contextMenu
	{
		#region Find instance
	
		if instance_exists(oInfantryNew)
			_instFind = find_top_Inst(mouse_x, mouse_y, oInfantryNew);
			
		if _instFind == noone
			_instFind = find_top_Inst(mouse_x, mouse_y, oParZoneLocal);
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
	
		#region Add inst to hand
	
		if _instFind != noone
		{
			// Add to hand
			add_Inst(global.instGrid, 0, _instFind);
			
			// Set selected
			_instFind.selected = true;
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
	
	#region Select with right click - Archived
	
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
					pathGoalX = x;
					pathGoalY = y;
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
				add_context("Spawn Dummy",			scr_context_spawn_dummy, false);
				add_context("Spawn DummyStronk",	scr_context_spawn_dummyStronk, false);
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
		
		var _newSquadList = ds_list_create();
		
		#region Find most common object in hand
		// Create a ds_map to hold the frequency of each object
		var freq_map = ds_map_create();

		// Initialize variable to keep track of most common object and its count
		var most_common_object = undefined;
		var most_common_count = 0;

		// Iterate through the first row of the ds_grid
		for(var i = 0; i < ds_grid_width(global.instGrid); i++)
		{
		    var _instanceInHand = ds_grid_get(global.instGrid, i, 0);
    
		    if (_instanceInHand == 0) continue;  // Skip if it's 0
			
			var _instanceObject = _instanceInHand.object_index;
    
		    // Check if this object is already in freq_map, if not add it
		    if(!ds_map_exists(freq_map, string(_instanceObject)))
		    {
		        ds_map_add(freq_map, string(_instanceObject), 0);
		    }
    
		    // Increment the count for this object
		    var current_count = ds_map_find_value(freq_map, string(_instanceObject));
		    ds_map_replace(freq_map, string(_instanceObject), current_count + 1);
    
		    // Check if this object is now the most common
		    if(current_count + 1 > most_common_count)
		    {
		        most_common_count = current_count + 1;
		        most_common_object = _instanceObject;
		    }
		}
		#endregion
		
		for(var i = 0; i < _instancesInHandList; i++)
		{
			var _instanceInHand = ds_grid_get(global.instGrid, i, 0);
			
			if _instanceInHand == 0
				continue;
				
			if _instanceInHand.object_index != most_common_object
				continue;
				
			var _squadObjectID = _instanceInHand.squadObjectID;

			if !instance_exists(_squadObjectID) {
				ds_list_add(_newSquadList, _instanceInHand);
				continue;
			}
			
			if ds_list_find_index(squadObjectList, _squadObjectID) == -1 {
				var _pos = ds_list_find_index(_instanceInHand.squadObjectID.squad, _instanceInHand);
				ds_list_delete(_instanceInHand.squadObjectID.squad, _pos);
				ds_list_add(_newSquadList, _instanceInHand);
				continue;
			}
						
			var _handTrueSize = 0;
			for(var o = 0; o < _instancesInHandList; o++)
				if ds_grid_get(global.instGrid, o, 0) != 0
					_handTrueSize++;
			
			// Compare the units in the object squad to the units being held
			for(var o = 0; o < _instancesInHandList; o++)
			{
				var _instanceInHandRepeat = ds_grid_get(global.instGrid, o, 0);
				
				if _instanceInHandRepeat == 0
					continue;
				
				if ds_list_find_index(_squadObjectID.squad, _instanceInHandRepeat) == -1 {
					var _pos = ds_list_find_index(_instanceInHand.squadObjectID.squad, _instanceInHand);
					ds_list_delete(_instanceInHand.squadObjectID.squad, _pos);
					ds_list_add(_newSquadList, _instanceInHand);
					continue;
				}
					
				var _squadTrueSize = 0;
				for(var p = 0; p < ds_list_size(_squadObjectID.squad); p++)
					if ds_list_find_value(_squadObjectID.squad, p) != 0
						_squadTrueSize++;
						
				if _squadTrueSize != _handTrueSize {
					var _pos = ds_list_find_index(_instanceInHand.squadObjectID.squad, _instanceInHand);
					ds_list_delete(_instanceInHand.squadObjectID.squad, _pos);
					ds_list_add(_newSquadList, _instanceInHand);
					continue;
				}
			}
		}
		
		if(ds_list_size(_newSquadList) > 0)
		{
			var _squadObjInst = instance_create_layer(0, 0, "UI", oSquad)
		
			var _newSquadListSize = ds_list_size(_newSquadList);

			for(var i = 0; i < _newSquadListSize; i++)
			{
				var _squadInst = ds_list_find_value(_newSquadList, i);
				
				if _squadInst.squadObjectID == _squadObjInst
					continue;
				
				_squadInst.squadObjectID = _squadObjInst;
				ds_list_add(_squadObjInst.squad, _squadInst);
			}
			
			_squadObjInst.event_user(0);
		}
		
		ds_list_destroy(_newSquadList);
	}
}
else
{
	if zoning == 0
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
					var _object = asset_get_index(buildingName);
					spawn_unit(_object, mouse_x, mouse_y);
		
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
}

#region MouseBox

// Check for mouseBox
if mousePress == 1
{
	var _collisionList = ds_list_create();
	var _collisionBool = collision_rectangle_list(mouseLeftPress_x, mouseLeftPress_y, mouse_x, mouse_y, oInfantry, false, true, _collisionList, false);
	
	// Reset Hand
	wipe_Hand(global.instGrid, 0);
	
	// Check for collision
	if _collisionBool
	{
		for(var i = 0; i < _collisionList; i++)
		{
			var _inst = ds_list_find_value(_collisionList, i);
			
			with(_inst)
			{
				add_Inst(global.instGrid, 0, id);
				selected = true;
			}
		}
	}
	else
		if !_key_ctrl
			wipe_Hand(global.instGrid, 0)
}

#endregion

#endregion

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
			for(var o = 0; o < _instancesInHandList; o++)
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