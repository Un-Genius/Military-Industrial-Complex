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
		return;

	var _prev_zoning = zoning;

	switch(keyboard_lastkey)
	{
	    case ord("E"):
	        zoning = (zoning == OBJ_NAME.SITE_PRO_SUPPLIES) ? -1 : OBJ_NAME.SITE_PRO_SUPPLIES;
	        break;

	    case ord("T"):
	        zoning = (zoning == OBJ_NAME.SITE_PRO_WEAPONS) ? -1 : OBJ_NAME.SITE_PRO_WEAPONS;
	        break;

	    case ord("R"):
	        zoning = (zoning == OBJ_NAME.SITE_CAP_SUPPLIES) ? -1 : OBJ_NAME.SITE_CAP_SUPPLIES;
	        break;

	    case ord("Y"):
	        zoning = (zoning == OBJ_NAME.SITE_PRO_INF) ? -1 : OBJ_NAME.SITE_PRO_INF;
	        break;

	    case ord("Q"):
	        zoning = (zoning == infantry) ? -1 : infantry;
	        break;

	    default: break;
	}

	if(_prev_zoning == zoning)
		return;

	if zoning == -1
	{
		if instance_exists(buildingToolReference)
			instance_destroy(buildingToolReference);

		buildingToolReference = noone;
		return;
	}

	_prev_zoning = zoning;

	with(buildingToolReference)
	{
		buildingType = _prev_zoning;
		event_user(0);
	}
}

function zoning_display()
{
	// Zoning functionality
	if zoning == -1
		return;

	if global.mouse_on_ui
		return;

	//var _cost = oFaction.obj_info[zoning];;

	if buildingToolReference != noone
		return;

	buildingToolReference = instance_create_layer(mouse_x, mouse_x, layer, oBuildingTool)

	var _zoning = zoning;
	with buildingToolReference
	{
		buildingType = _zoning;
		event_user(0);
	}
}

function select_instance()
{
	if buildingPlacement != noone
		return;

	if zoning != -1
		return;

	if contextMenu
		return;

	var _click_left_hold = device_mouse_check_button(0, mb_left)
	var _key_ctrl	= keyboard_check(vk_control);
	var _selectx2 = false;

	if _click_left_hold
	{
		var _dragging = 3 < point_distance(mouse_x, mouse_y, mouseLeftPress_x, mouseLeftPress_y);

		if _dragging
		{
			if instance_selected == noone
				left_mouse_state = mouse_type.box;
			else
				left_mouse_state = mouse_type.dragging;
		}
	}

	if left_mouse_state != mouse_type.pressed
		return;

	if instance_exists(oSquad) && zoom < 1.5
		instance_selected = find_top_Inst(mouse_x, mouse_y, oSquad);

	if instance_selected == noone && instance_exists(oInfantryNew)
		instance_selected = find_top_Inst(mouse_x, mouse_y, oInfantryNew);

	if instance_selected == noone && instance_exists(oParSiteLocal)
		instance_selected = find_top_Inst(mouse_x, mouse_y, oParSiteLocal);

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

	if right_mouse_state == mouse_type.released || right_mouse_state == mouse_type.released_twice
	{ }
	else
		return;

	if !_key_shft
	{
		var _movement_type = "m_move";
		switch(right_mouse_state) // or its this switch(right_press_type)
		{
			case mouse_type.released_twice:
				_movement_type = "m_haste";
			case mouse_type.released:
				scr_context_move(_movement_type);
				break;
		}
		return;
	}

	if buildingPlacement != noone
		return;

	if zoning != -1
		return;

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
		instRightSelected = find_top_Inst(mouseRightPress_x, mouseRightPress_y, oParSiteLocal);

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
		return;

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
		add_context("break",				on_click,						false);
		add_context("Spawn AI",				scr_create_squad,				false, [mouse_x, mouse_y, oInfantryAI, 3]);
		add_context("break",				on_click,						false);
	}
}
function context_menu_unit_actions(_instSel)
{
	if(!instance_exists(_instSel))
		return;

	with(_instSel)
	{
		goal_x = x;
		goal_y = y;
		moveState = action.idle;

		var _objectIndex = object_index;
		var _x = x;
		var _y = y;
	}

	with(instance_find(oContextMenu, 0)) {
		switch(_objectIndex)
		{
			case oInfantry:
				add_context("Change Behavior", scr_context_folder_behavior, true)
			case oSiteProduceInfantry:
				// Spawn units
				//add_context("Train Infantry", scr_context_spawn_object, false, [objectType.oInfantry, 7]);
				add_context("Train Infantry Squad", scr_create_squad, false, [x, y, oInfantry, 7]);
				break;

			case oSiteHQ:
				// Spawn units
				add_context("Spawn Units", scr_context_folder_HQspawn, true);
				break;
		}
		
		add_context("Destroy", scr_instance_destroy, false, [_objectIndex])
	}
}
function context_menu_debug()
{
	if(!global.debug)
		return;
	with(instance_find(oContextMenu, 0)) {
		//add_context("break", on_click, false);
		//add_context("Spawn AI",	scr_context_spawn_object, false, [oInfantryAI, 3]);
		//add_context("Spawn AI Spawner",	scr_context_spawn_ai_spawner, false);
	}
}

// Function to check if an instance is a child of a specific parent object
function is_child_of(_instance, _parent) {
    var _current = _instance;
    while (_current != noone) {
        if (_current == _parent) return true;
		if (_current == -100) return false;
        _current = object_get_parent(_current);
    }
    return false;
}

function mouse_box_close()
{
	if buildingPlacement != noone
		return;

	if zoning != -1
		return;

	var _click_left_released	= device_mouse_check_button_released(0, mb_left);

	if !_click_left_released
		return;

	if contextMenu
		return;

	left_mouse_state = false;
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
		if (_instanceInHand == 0 || !instance_exists(_instanceInHand) || (is_child_of(_instanceInHand.object_index, oParSite))) continue;

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
		return;
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
		return;

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
		return;

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
		return;
	}

	// check for mouse click
	if buildingIntersect
		return;

	spawn_unit(buildingPlacement, mouse_x, mouse_y);

	reset_building()
}

function reset_building()
{
	// Delete ghost
	instance_destroy(buildingPlacement);

	// Reset variables
	buildingPlacement = noone;
	buildingIntersect = false;
}

function mouse_box()
{
	// Check for mouseBox
	if left_mouse_state != mouse_type.box
		return;

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
	
function get_hot_key() {
    for (var i = 0; i <= 9; i++) {
        var key = ord(string(i));
        if (keyboard_check_released(key))
            return i;
    }
    return -1;
}

function store_hand() {
	var _hot_key = get_hot_key()
	var _key_shift	= keyboard_check(vk_shift);
	//keyboard_lastchar = "";

	if (_hot_key == -1)
		exit;
		
	if !_key_shift
		exit;
	
	var _ds_grid = global.instGrid;
	wipe_Hand(_ds_grid, _hot_key)
	
	var _width	= ds_grid_width(_ds_grid);
	for(var i = 0; i < _width; i++)
	{
		var _hand = ds_grid_get(_ds_grid, i, 0);
		
		if !instance_exists(_hand)
			continue
		
		add_Inst(_ds_grid, _hot_key, _hand)
	}
}

function retrieve_hand() {
	
	var _hot_key = get_hot_key()
	var _key_shift	= keyboard_check(vk_shift);
	//keyboard_lastchar = "";

	if (_hot_key == -1)
		exit;
		
	if _key_shift
		exit;
	
	var _ds_grid = global.instGrid;
	var _width	= ds_grid_width(_ds_grid);
	
	wipe_Hand(_ds_grid, 0)
	
	for(var i = 0; i < _width; i++)
	{
		var _hand = ds_grid_get(_ds_grid, i, _hot_key);
		if !instance_exists(_hand)
			continue
		
		_hand.selected = true;
		add_Inst(_ds_grid, 0, _hand)
	}
}