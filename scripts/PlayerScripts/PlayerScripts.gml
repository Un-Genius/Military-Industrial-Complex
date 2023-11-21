function clamp_to_room()
{
	//Clamp Objects position to be inside the (tiled) room space
	var xbuf = 37;
	var ybuf = 34;

	x = clamp(x, xbuf, room_width - xbuf); 
	y = clamp(y, ybuf, room_height - ybuf + 2);
}

function zoning_switch()
{
	// Toggle Zoning tool
	if!(keyboard_check_pressed(vk_anykey))
		exit;
	
	var _prev_zoning = zoning;
	
	switch(keyboard_lastkey)
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
	
	if(_prev_zoning == zoning)
		exit;
		
	if zoning == -1
	{
		if instance_exists(buildingPlaceholder)
			instance_destroy(buildingPlaceholder);
			
		buildingPlaceholder = noone;
		exit;
	}
		
	_prev_zoning = zoning;
				
	with(buildingPlaceholder)
	{
		buildingType = _prev_zoning;
		event_user(0);
	}
}

function zoning_display()
{
	// Zoning functionality
	if zoning == -1
		exit;
	
	if global.mouseUI
		exit;
	
	//var _cost = oManager.unitCost[zoning];;
	
	if buildingPlaceholder != noone
		exit;
	
	buildingPlaceholder = instance_create_layer(mouse_x, mouse_x, layer, oBuildingTool)
		
	var _zoning = zoning;
	with buildingPlaceholder
	{
		buildingType = _zoning;
		event_user(0);
	}
}

function select_instance()
{
	var _click_left_pressed = device_mouse_check_button_pressed(0, mb_left);
	if _click_left_pressed
	{
		mouseLeftPress_x = mouse_x;
		mouseLeftPress_y = mouse_y;
	}
	
	if buildingPlacement != noone 
		exit;

	if zoning != -1
		exit;
	
	if contextMenu
		exit;
	
	var _click_left_hold = device_mouse_check_button(0, mb_left)
	var _key_ctrl	= keyboard_check(vk_control);
	var _selectx2 = false;
	
	if _click_left_hold
	{
		var _dragging = 3 < point_distance(mouse_x, mouse_y, mouseLeftPress_x, mouseLeftPress_y);
		
		if _dragging
		{
			if instance_selected == noone
				mousePress = press_type.box;	
			else
				mousePress = press_type.drag;
		}
	}
	
	if !_click_left_pressed
		exit;
		
	if instance_exists(oSquad) && zoom < 1.5
		instance_selected = find_top_Inst(mouse_x, mouse_y, oSquad);
		
	if instance_selected == noone && instance_exists(oInfantryNew)
		instance_selected = find_top_Inst(mouse_x, mouse_y, oInfantryNew);
		
	if instance_selected == noone && instance_exists(oParZoneLocal)
		instance_selected = find_top_Inst(mouse_x, mouse_y, oParZoneLocal);

	// Check if already selected	
	if find_Inst(global.instGrid, 0, instance_selected) > -1
		_selectx2 = true;

	// Unselect
	if !_key_ctrl && !_selectx2
		wipe_Hand(global.instGrid, 0);
		
	if instance_selected != noone && instance_selected.object_index == oSquad
	{
		select_squad_instances(instance_selected)
		instance_selected = noone;
	}
	
	// Unselect if pressed on again
	else if _key_ctrl && _selectx2 && instance_selected.selected
	{
		var _x = find_Inst(global.instGrid, 0, instance_selected);
			
		if _x != -1
			wipe_Slot(global.instGrid, _x, 0);
	}
	
	// Add inst to hand
	if instance_selected != noone
	{
		add_Inst(global.instGrid, 0, instance_selected);

		instance_selected.selected = true;
	}
}

function context_menu_open()
{
	var _click_right_released	= device_mouse_check_button_released(0, mb_right);
	var _key_shft	= keyboard_check(vk_shift);
	
	if !_key_shft
	{
		switch(right_press_type)
		{
			case press_type.once:
				_movement_type = "move";
			case press_type.twice:
				_movement_type = "haste";
				scr_context_move(_movement_type);
				
				mouseRightPress_x = mouse_x;
				mouseRightPress_y = mouse_y;
				
			scr_context_move(_movement_type);
		}
		exit;
	}
	
	if buildingPlacement != noone 
		exit;

	if zoning != -1
		exit;
	
	// Context Menu
	if !_click_right_released
		exit;
		
	// Reset context
	close_context(-1);
		
	// Set and get data
	contextMenu = true;
	mouseRightPressGui_x	= device_mouse_x_to_gui(0);
	mouseRightPressGui_y	= device_mouse_y_to_gui(0);
	mouseRightPress_x		= mouse_x;
	mouseRightPress_y		= mouse_y;
	
	// Spawn Units through a unit
	instRightSelected = find_top_Inst(mouseRightPress_x, mouseRightPress_y, oParUnit);
	
	if instRightSelected == noone
		instRightSelected = find_top_Inst(mouseRightPress_x, mouseRightPress_y, oParZoneLocal);
		
	if instance_exists(instRightSelected)
	{
		with(instRightSelected)
		{
			add_Inst(global.instGrid, 0, id);
			selected = true;
		}
	}
	
	var _instSel = instRightSelected;
	
	var _cm_inst = create_context(mouseRightPressGui_x, mouseRightPressGui_y);
	
	context_menu_select_all(_instSel);
	
	var unique_list = ds_list_create();
	var _inst_in_hand;
	var _size = ds_grid_width(global.instGrid);
		
	ds_list_add(unique_list, _instSel);
	context_menu_unit_actions(_instSel);

	for (var i = 0; i < _size; i++)
	{
	    _inst_in_hand = ds_grid_get(global.instGrid, i, 0);
		
	    if(_inst_in_hand == 0)
			continue;
		
		if ds_list_find_index(unique_list, _inst_in_hand) != -1
			continue;

	    ds_list_add(unique_list, _inst_in_hand);
		context_menu_unit_actions(_inst_in_hand);
	}

	context_menu_debug();
	
	with _cm_inst event_user(0);
	
	ds_list_destroy(unique_list);
}
function context_menu_select_all(_instSel)
{
	if(instance_exists(_instSel))
		exit;

	// var _size = ds_grid_width(global.instGrid);
				
	/*/ Check if any units are selected
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
	}*/
				
	// Select multiple instances
	var _inst = instance_find(oContextMenu, 0);
	with(_inst) { 
		add_context("Select all",			scr_context_select_all,			false);
		add_context("Select all on screen", scr_context_select_onScreen,	false);
		add_context("break", on_click, false);
		add_context("Spawn AI",				scr_create_squad,		false, [mouse_x, mouse_y, objectType.oInfantryAI, 3]);
		add_context("break", on_click, false);		
	}
}
function context_menu_unit_actions(_instSel)
{
	if(!instance_exists(_instSel))
		exit;
		
	with(_instSel)
	{
		pathGoalX = x;
		pathGoalY = y;
		moveState = action.idle;
				
		var _objectIndex = object_index;
		var _x = x;
		var _y = y;
	}
	
	with(instance_find(oContextMenu, 0)) { 
		switch(_objectIndex)
		{
			case oZoneBootCamp:
				// Spawn units
				//add_context("Train Infantry", scr_context_spawn_object, false, [objectType.oInfantry, 7]);
				add_context("Train Infantry Squad", scr_create_squad, false, [x, y, objectType.oInfantry, 7]);
				break;
			
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
				//add_context("Move", scr_context_move, false);
						
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
}
function context_menu_debug()
{
	if(!global.debugMenu)
		exit;
	with(instance_find(oContextMenu, 0)) { 
		//add_context("break", on_click, false);
		//add_context("Spawn AI",	scr_context_spawn_object, false, [oInfantryAI, 3]);
		//add_context("Spawn AI Spawner",	scr_context_spawn_ai_spawner, false);
	}
}

function mouse_box_close()
{
	if buildingPlacement != noone 
		exit;

	if zoning != -1
		exit;
	
	var _click_left_released	= device_mouse_check_button_released(0, mb_left);
	
	if !_click_left_released
		exit;
	
	if contextMenu
		exit;

	mousePress = false;
	mouseLeftReleased_x = mouse_x;
	mouseLeftReleased_y = mouse_y;
		
	var _newSquadList = ds_list_create();
	var _key_shft	= keyboard_check(vk_shift);
		
	// Find most common object in hand
	var freq_map = ds_map_create();
	var most_common_object = undefined;
	var most_common_count = 0;

	for(var i = 0; i < instances_selected_list; i++)
	{
		var _instanceInHand = ds_grid_get(global.instGrid, i, 0);
		if (_instanceInHand == 0) continue;
			
		var _instanceObject = _instanceInHand.object_index;
		if(!ds_map_exists(freq_map, string(_instanceObject)))
		    ds_map_add(freq_map, string(_instanceObject), 0);
    
		var current_count = ds_map_find_value(freq_map, string(_instanceObject));
		ds_map_replace(freq_map, string(_instanceObject), current_count + 1);
    
		if(current_count + 1 > most_common_count)
		{
		    most_common_count = current_count + 1;
		    most_common_object = _instanceObject;
		}
	}
	
	if !_key_shft
	{
		ds_list_destroy(_newSquadList);
		exit;
	}

	for(var i = 0; i < instances_selected_list; i++)
	{
		var _instanceInHand = ds_grid_get(global.instGrid, i, 0);
			
		if _instanceInHand == 0
			continue;
				
		if _instanceInHand.object_index != most_common_object
			continue;
			
		var _squadObjectID = _instanceInHand.squadObjectID;

		if !instance_exists(_squadObjectID)
		{
			ds_list_add(_newSquadList, _instanceInHand);
			continue;
		}
			
		if ds_list_find_index(squadObjectList, _squadObjectID) == -1
		{
			var _pos = ds_list_find_index(_instanceInHand.squadObjectID.squad, _instanceInHand);
			ds_list_delete(_instanceInHand.squadObjectID.squad, _pos);
			ds_list_add(_newSquadList, _instanceInHand);
			continue;
		}
						
		var _handTrueSize = 0;
		for(var o = 0; o < instances_selected_list; o++)
			if ds_grid_get(global.instGrid, o, 0) != 0
				_handTrueSize++;
			
		// Compare the units in the object squad to the units being held
		for(var o = 0; o < instances_selected_list; o++)
		{
			var _instanceInHandRepeat = ds_grid_get(global.instGrid, o, 0);
				
			if _instanceInHandRepeat == 0
				continue;
				
			if ds_list_find_index(_squadObjectID.squad, _instanceInHandRepeat) == -1
			{
				var _pos = ds_list_find_index(_instanceInHand.squadObjectID.squad, _instanceInHand);
				ds_list_delete(_instanceInHand.squadObjectID.squad, _pos);
				ds_list_add(_newSquadList, _instanceInHand);
				continue;
			}
					
			var _squadTrueSize = 0;
			for(var p = 0; p < ds_list_size(_squadObjectID.squad); p++)
				if ds_list_find_value(_squadObjectID.squad, p) != 0
					_squadTrueSize++;
						
			if _squadTrueSize != _handTrueSize
			{
				var _pos = ds_list_find_index(_instanceInHand.squadObjectID.squad, _instanceInHand);
				ds_list_delete(_instanceInHand.squadObjectID.squad, _pos);
				ds_list_add(_newSquadList, _instanceInHand);
				continue;
			}
		}
	}
	
	create_squad(_newSquadList);
	
	ds_list_destroy(_newSquadList);
}

function create_squad(_newSquadList)
{
	if(ds_list_size(_newSquadList) == 0)
		exit;

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
			
	with _squadObjInst
		event_user(0);
}

function create_zone()
{
	if zoning != 0
		exit;
		
	var _click_right_pressed	= device_mouse_check_button_pressed(0, mb_right);
	var _click_left_pressed		= device_mouse_check_button_pressed(0, mb_left);
		
	var _halfW = (buildingPlacement.sprite_width * buildingPlacement.image_xscale)/3.5;
	var _halfH = (buildingPlacement.sprite_height * buildingPlacement.image_yscale)/3.5;
	
	var _collision	= collision_rectangle(mouse_x - _halfW, mouse_y - _halfH, mouse_x + _halfW, mouse_y + _halfH, oCollision, false, true)
	var _distance	= point_distance(instRightSelected.x, instRightSelected.y, mouse_x, mouse_y);
		
	buildingIntersect = false;
		
	// Check if intersecting with walls or units
	if _collision || _distance > buildingPlacement.resRange + (_halfW + _halfH)/2
		buildingIntersect = true;

	if _click_right_pressed
	{
		reset_building()
		exit;
	}

	// Check transport for resources
	if instRightSelected.resCarry - unitResCost.HAB <= 0
	{
		reset_building()
		exit;
	}

	// check for mouse click
	if buildingIntersect
		exit;
			
	// Take away resources
	instRightSelected.resCarry -= unitResCost.HAB;
			
	var _object = asset_get_index(buildingName);
	spawn_unit(_object, mouse_x, mouse_y);
		
	reset_building()
}

function reset_building()
{
	// Delete ghost
	instance_destroy(buildingPlacement);
		
	// Reset variables
	buildingName = "";
	buildingPlacement = noone;
	buildingIntersect = false;
}

function mouse_box()
{
	// Check for mouseBox
	if mousePress != press_type.box
		exit;
	
	var _key_ctrl	= keyboard_check(vk_control);
	var _collision_list = ds_list_create();
	var _collision_object = oInfantry;
	
	if zoom < 1.5
		_collision_object = oSquad;
		
	var _collision_amount = collision_rectangle_list(mouseLeftPress_x, mouseLeftPress_y, mouse_x, mouse_y, _collision_object, false, true, _collision_list, false);
	
	if !_key_ctrl
		wipe_Hand(global.instGrid, 0);
	
	for(var i = 0; i < _collision_amount; i++)
	{
		var _inst = ds_list_find_value(_collision_list, i);
			
		if _inst.object_index == oSquad
		{
			select_squad_instances(_inst)
			continue;
		}
						
		with(_inst)
		{
			add_Inst(global.instGrid, 0, id);
			selected = true;
		}
	}
}

function select_squad_instances(squad_instance) {
	var _length = ds_list_size(squad_instance.squad);
	for(var o = 0; o < _length; o++)
	{
		var _inst_squad = ds_list_find_value(squad_instance.squad, o);
		with(_inst_squad)
		{
			add_Inst(global.instGrid, 0, id);
			selected = true;
		}
	}
}






















