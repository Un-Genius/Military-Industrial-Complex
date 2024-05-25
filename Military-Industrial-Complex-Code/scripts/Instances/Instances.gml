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


/// @function enum_to_obj(number);
/// @param {number} Enumerator_Number to exchange to object
function enum_to_obj(_num)
{
	var _obj = noone;
	
	switch (_num)
	{
		case OBJ_NAME.UNIT_PLAYER:		_obj = oPlayer;				break;
		case OBJ_NAME.UNIT_INF:			_obj = oInfantry;			break;
		case OBJ_NAME.UNIT_ENEMY_INF:	_obj = oInfantryAI;			break;
		case OBJ_NAME.UNIT_WORKER:		_obj = oWorker;				break;
		case OBJ_NAME.SITE_HQ:			_obj = oSiteHQ;				break;
		case OBJ_NAME.SITE_PRO_SUPPLIES:_obj = oSiteProduceSupplies;	break;
		case OBJ_NAME.SITE_PRO_WORKERS:	_obj = oSiteProduceWorkers;	break;
		case OBJ_NAME.SITE_PRO_INF:		_obj = oSiteProduceWorkers;break;
		case OBJ_NAME.SITE_PRO_WEAPONS:	_obj = oSiteProduceWeapons;	break;
		case OBJ_NAME.SITE_PRO_FOOD:	_obj = oSiteProduceFood;	break;
		case OBJ_NAME.SITE_PRO_CM:		_obj = oSiteProduceCM;		break;
		case OBJ_NAME.SITE_PRO_RT:		_obj = oSiteProduceRT;		break;
		case OBJ_NAME.SITE_CAP_SUPPLIES:_obj = oSiteCapacitySupplies;break;
		case OBJ_NAME.SITE_CAP_INF:		_obj = oSiteCapacityInfantry;break;
		case OBJ_NAME.SITE_CAP_WORKERS:	_obj = oSiteCapacityWorkers;break;
	}
	
	return _obj;
}

/// @function obj_to_enum(object);
/// @param {_obj} Object to exchange to enum
function obj_to_enum(_obj)
{
	var _num = -1;
	
	switch (_obj)
	{
		case oPlayer:				_num = OBJ_NAME.UNIT_PLAYER;			break;
		case oInfantry:				_num = OBJ_NAME.UNIT_INF;				break;
		case oInfantryAI:			_num = OBJ_NAME.UNIT_ENEMY_INF;			break;
		case oWorker:				_num = OBJ_NAME.UNIT_WORKER;			break;
		case oSiteHQ:				_num = OBJ_NAME.SITE_HQ;				break;
		case oSiteProduceSupplies:	_num = OBJ_NAME.SITE_PRO_SUPPLIES;		break;
		case oSiteProduceWorkers:	_num = OBJ_NAME.SITE_PRO_WORKERS;		break;
		case oSiteProduceInfantry:	_num = OBJ_NAME.SITE_PRO_INF;			break;
		case oSiteProduceWeapons:	_num = OBJ_NAME.SITE_PRO_WEAPONS;		break;
		case oSiteProduceFood:		_num = OBJ_NAME.SITE_PRO_FOOD;			break;
		case oSiteProduceCM:		_num = OBJ_NAME.SITE_PRO_CM;			break;
		case oSiteProduceRT:		_num = OBJ_NAME.SITE_PRO_RT;			break;
		case oSiteCapacitySupplies:	_num = OBJ_NAME.SITE_CAP_SUPPLIES;		break;
		case oSiteCapacityInfantry:	_num = OBJ_NAME.SITE_CAP_INF;			break;
		case oSiteCapacityWorkers:	_num = OBJ_NAME.SITE_CAP_WORKERS;		break;
	}
	
	return _num;
}

function localObj_to_netObj(_localObj)
{
	var _netObj = noone;
			
	switch(_localObj)
	{
		case oPlayer:		_netObj = oPlayerClient;	break;
		case oParSiteLocal:	_netObj = oParZoneNet;		break;
		case oSiteHQ:		_netObj = oZoneNetHQ;		break;
		case oSiteCapacityInfantry:		_netObj = oZoneNetCamp;		break;
		case oSiteProduceInfantry:	_netObj = oZoneNetBootCamp;	break;
		case oSiteProduceSupplies:	_netObj = oZoneNetMoney;	break;
		case oSiteCapacitySupplies:	_netObj = oZoneNetSupplies;	break;
		case oInfantry:		_netObj = oInfantryClient;	break;
		case oTransport:	_netObj = oTransportClient;	break;
		default:
			show_debug_message("Error in Function localObj_to_netObj. Net object not found");
	}
	
	return _netObj;
}

/// @function enum_to_spr(number);
/// @param {number} Enumerator_Number to exchange to sprite
function enum_to_sprite(_num)
{
	var _spr = noone;
	
	switch (_num)
	{
		case OBJ_NAME.UNIT_PLAYER:			_spr = sPlayer;			break;
		case OBJ_NAME.UNIT_INF:				_spr = sZoneInfantry;		break;
		case OBJ_NAME.UNIT_ENEMY_INF:		_spr = sInfantry;	break;
		case OBJ_NAME.UNIT_WORKER:			_spr = sInfantry;			break;
		case OBJ_NAME.SITE_HQ:				_spr = sZoneHQ;				break;
		case OBJ_NAME.SITE_PRO_SUPPLIES:	_spr = sZoneMoney;	break;
		case OBJ_NAME.SITE_PRO_WORKERS:		_spr = sZoneBootCamp;	break;
		case OBJ_NAME.SITE_PRO_INF:			_spr = sZoneBootCamp;	break;
		case OBJ_NAME.SITE_PRO_WEAPONS:		_spr = sZoneMoney;	break;
		case OBJ_NAME.SITE_PRO_FOOD:		_spr = sZoneMoney;	break;
		case OBJ_NAME.SITE_PRO_CM:			_spr = sZoneMoney;		break;
		case OBJ_NAME.SITE_PRO_RT:			_spr = sZoneMoney;		break;
		case OBJ_NAME.SITE_CAP_SUPPLIES:	_spr = sZoneSupplies;	break;
		case OBJ_NAME.SITE_CAP_INF:			_spr = sZoneCamp;	break;
		case OBJ_NAME.SITE_CAP_WORKERS:		_spr = sZoneCamp;	break;
	}
	
	return _spr;
}

/// @function object_to_sprite(object);
/// @param {object} Object to exchange to sprite
function object_to_sprite(_obj)
{
	var _spr = noone;
	
	switch (_obj)
	{
		case oPlayer:				_spr = sPlayer;			break;
		case oInfantry:				_spr = sZoneInfantry;	break;
		case oInfantryAI:			_spr = sInfantry;		break;
		case oWorker:				_spr = sInfantry;		break;
		case oSiteHQ:				_spr = sHQ;			break;
		case oSiteProduceSupplies:	_spr = sFactory;		break;
		case oSiteProduceWorkers:	_spr = sHAB;	break;
		case oSiteProduceInfantry:	_spr = sHAB;	break;
		case oSiteProduceWeapons:	_spr = sFactory;		break;
		case oSiteProduceFood:		_spr = sFactory;		break;
		case oSiteProduceCM:		_spr = sFactory;		break;
		case oSiteProduceRT:		_spr = sFactory;		break;
		case oSiteCapacitySupplies:	_spr = sWarehouse;	break;
		case oSiteCapacityInfantry:	_spr = sHousing;		break;
		case oSiteCapacityWorkers:	_spr = sHousing;		break;
	}
	
	return _spr;
}