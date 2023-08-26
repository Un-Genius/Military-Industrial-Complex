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

/// @function display_money(amount);
/// @param {amount} amount of money to display
function display_money(_x, _y, _amount)
{
	var _inst = instance_create_layer(_x, _y, "UI", oMoney);
	_inst.suppliesAmount = _amount;
}

/// @function add_money(x, y, amount, display_money);
/// @param {amount} amount of money to add
/// @param {display_money} Display_Money_bool
function add_money(_x, _y, _amount, _display)
{
	if(global.supplies < global.maxSupplies)
	{
		// Add supplies
		global.supplies += _amount;
	
		// Cap the supplies
		if(global.maxSupplies < global.supplies)
		{
			_amount = global.supplies - global.maxSupplies;
			global.supplies = global.maxSupplies;
			
			if _display
				display_money(_x, _y, _amount);
		}
		else
		{
			if _display
				display_money(_x, _y, _amount);
		}
	}
}

/// @function enum_to_obj(number);
/// @param {number} Enumerator_Number to exchange to object
function enum_to_obj(_num)
{
	var _obj = noone;
	
	switch _num
	{
		case objectType.oPlayer:		_obj	= oPlayer;			break;
		case objectType.oZoneHQ:		_obj	= oZoneHQ;			break;
		case objectType.oZoneCamp:		_obj	= oZoneCamp;		break;
		case objectType.oZoneMoney:		_obj	= oZoneMoney;		break;
		case objectType.oZoneSupplies:	_obj	= oZoneSupplies;	break;
		case objectType.oZoneBootCamp:	_obj	= oZoneBootCamp;	break;
		case objectType.oInfantry:		_obj	= oInfantry;		break;
		case objectType.oTransport:		_obj	= oTransport;		break;
		case objectType.oDummy:			_obj	= oDummy;			break;
		case objectType.oDummyStronk:	_obj	= oDummyStronk;		break;
	}
	
	return _obj;
}

/// @function obj_to_enum(object);
/// @param {_obj} Object to exchange to enum
function obj_to_enum(_obj)
{
	var _num = -1;
	
	switch _obj
	{
		case oPlayer:		_num	= objectType.oPlayer;		break;
		case oZoneHQ:		_num	= objectType.oZoneHQ;		break;
		case oZoneCamp:		_num	= objectType.oZoneCamp;		break;
		case oZoneMoney:	_num	= objectType.oZoneMoney;	break;
		case oZoneSupplies: _num	= objectType.oZoneSupplies;	break;
		case oZoneBootCamp: _num	= objectType.oZoneBootCamp;	break;
		case oInfantry:		_num	= objectType.oInfantry;		break;
		case oTransport:	_num	= objectType.oTransport;	break;
		case oDummy:		_num	= objectType.oDummy;		break;
		case oDummyStronk:	_num	= objectType.oDummyStronk;	break;
	}
	
	return _num;
}

function localObj_to_netObj(_localObj)
{
	var _netObj = noone;
			
	switch(_localObj)
	{
		case oPlayer:		_netObj = oPlayerClient;	break;
		case oParZoneLocal:	_netObj = oParZoneNet;		break;
		case oZoneHQ:		_netObj = oZoneNetHQ;		break;
		case oZoneCamp:		_netObj = oZoneNetCamp;		break;
		case oZoneBootCamp:	_netObj = oZoneNetBootCamp;	break;
		case oZoneMoney:	_netObj = oZoneNetMoney;	break;
		case oZoneSupplies:	_netObj = oZoneNetSupplies;	break;
		case oInfantry:		_netObj = oInfantryClient;	break;
		case oTransport:	_netObj = oTransportClient;	break;
		default:
			show_debug_message("Error in Function localObj_to_netObj. Net object not found");
	}
	
	return _netObj;
}

/// @function enum_to_spr(number);
/// @param {number} Enumerator_Number to exchange to sprite
function enum_to_spr(_num)
{
	var _spr = noone;
	
	switch _num
	{
		case objectType.oZoneHQ:		_spr = sZoneHQ;			break;
		case objectType.oInfantry:		_spr = sZoneInfantry;	break;
		case objectType.oZoneCamp:		_spr = sZoneCamp;		break;
		case objectType.oZoneMoney:		_spr = sZoneMoney;		break;
		case objectType.oZoneSupplies:	_spr = sZoneSupplies;	break;
		case objectType.oZoneBootCamp:	_spr = sZoneBootCamp;	break;
		
	}
	
	return _spr;
}