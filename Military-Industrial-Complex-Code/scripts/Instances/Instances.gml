/// @function remove_select(_list, _id);
/// @param {_list} ds_list to modify
/// @param {_id} Instance to remove
function remove_select(_list, _id)
{
	var _pos = ds_list_find_index(_list, _id);
	
	if(_pos != -1)
		ds_list_delete(_list, _pos);
}

/// @function add_select(_list, _id);
/// @param {_list} ds_list to modify
/// @param {_id} Instance to add
function add_select(_list, _id)
{
	// Check if already in list
	var _pos = ds_list_find_index(_list, _id);
	
	if(_pos == -1)
	{
		ds_list_add(_list, _id);
		return true;
	}
	else
		return false;
}

/// @function ctrl_select(_list, _id);
/// @param {_list} ds_list to modify
/// @param {_id} Instance to add
function ctrl_select(_list, _id)
{
	// Check if already in list
	var _pos = ds_list_find_index(_list, _id);
	
	if(_pos == -1) // Add to list if not in list
		add_select(_list, _id);
	else // Deselect instance if in list
		remove_select(_list, _id);
}

/// @function nearby_select(_list, x, y, object);
/// @param {_list} ds_list to modify
/// @param {_x} x position to look at
/// @param {_y} y position to look at
/// @param {_obj} object to look for
function nearby_select(_list, _x, _y, _obj)
{
	var _currentInst = collision_point(_x, _y, _obj, false, true);
	
	// Check current location
	if(_currentInst)
	{
		if add_select(global.instances_selected, _currentInst)
		{
			// Check all touching zones
			for(var xx = -1; xx < 2; xx += 2)
			{
				nearby_select(_list, _x + (xx * _obj.sprite_width), _y, _obj)
			}
		
			for(var yy = -1; yy < 2; yy += 2)
			{
				nearby_select(_list, _x, _y + (yy * _obj.sprite_width), _obj)
			}
		}
	}
}


/// @function display_resource(object, resources);
function display_resource(_display_coord, _resource_struct)
{
	var _inst = instance_create_layer(_display_coord[0], _display_coord[1], "UI", oResourceSign);
	_inst.resources = variable_clone(_resource_struct);
}


function add_resource(_target_struct, _value_struct, _max_stuct=-1, _min_value=-1, _display_coord=[0,0]){
	var _value_names = struct_get_names(_value_struct);
	var _target_names = struct_get_names(_value_struct);
	
	if array_length(_target_names) != array_length(_value_names)
		show_message("Error comparing struct lengths. Values can't align.");
	
	for(var i = 0; i < array_length(_target_names); i++)
	{
		var _name = _value_names[i];
		var _value = struct_get(_value_struct, _name);
		
		if _value == 0
			continue
			
		var _target_amount = struct_get(_target_struct, _name) + _value;
		
		if _value_names[i] == "electricity" || _value_names[i] == "purchase_power"
		{
			struct_set(_target_struct, _name, _target_amount);
			continue;
		}
		
		if _max_stuct != -1
		{
			var _max = struct_get(_max_stuct, _name);
			struct_set(_target_struct, _name, min(_target_amount, _max))
		}
		else if _min_value != -1
			struct_set(_target_struct, _name, max(_target_amount, _min_value))
		else
			struct_set(_target_struct, _name, _target_amount)
	}
	
	if _display_coord[0] > 0 || _display_coord[1] > 0
		display_resource(_display_coord, _value_struct);
}

function compare_resources(base_resource, cost) {
    // Get the list of keys in the cost struct
    var _key_list = variable_struct_get_names(cost);
    
    // Iterate through each key in the list
    for (var i = 0; i < array_length(_key_list); i++) {
        var key = _key_list[i];
        
        // Check if the base resources have enough of each key
        if (base_resource[$ key] < cost[$ key]*-1) {
            return false; // Not enough resources
        }
    }
    return true; // Enough resources
}


// Function implementations
function enum_to_obj(_num) {
	with(oFaction)
	{
	    if (_num >= 0 && _num < array_length(enum_to_obj_map)) {
	        return enum_to_obj_map[_num];
	    } else {
	        show_debug_message("Error in Function enum_to_obj. Object not found");
	        return noone;
	    }
	}
}

function obj_to_enum(_obj) {
	with(oFaction)
	{
	    if (ds_map_exists(obj_to_enum_map, _obj)) {
	        return ds_map_find_value(obj_to_enum_map, _obj);
	    } else {
	        show_debug_message("Error in Function obj_to_enum. Object not found");
	        return -1;
	    }
	}
}

function localObj_to_netObj(_localObj) {
	with(oFaction)
	{
	    if (ds_map_exists(local_to_net_map, _localObj)) {
	        return ds_map_find_value(local_to_net_map, _localObj);
	    } else {
	        show_debug_message("Error in Function localObj_to_netObj. Net object not found");
	        return noone;
	    }
	}
}

function enum_to_sprite(_num) {
	with(oFaction)
	{
	    if (_num >= 0 && _num < array_length(enum_to_sprite_map)) {
	        return enum_to_sprite_map[_num];
	    } else {
	        show_debug_message("Error in Function enum_to_sprite. Sprite not found");
	        return noone;
	    }
	}
}

function object_to_sprite(_obj) {
	with(oFaction)
	{
	    if (ds_map_exists(obj_to_sprite_map, _obj)) {
	        return ds_map_find_value(obj_to_sprite_map, _obj);
	    } else {
	        show_debug_message("Error in Function object_to_sprite. Sprite not found");
	        return noone;
	    }
	}
}