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
		case zoneType.HQ: 
			_obj	= oZoneHQ;
		break;
		
		case zoneType.camp: 
			_obj	= oZoneCamp;
		break;
		
		case zoneType.money:
			_obj	= oZoneMoney;
		break;
		
		case zoneType.supplies:
			_obj	= oZoneSupplies;
		break;
		
		case zoneType.bootCamp:
			_obj	= oZoneBootCamp;
		break;
		
		case zoneType.infantry:
			_obj	= oZoneInfantry;
		break;
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
		case oZoneHQ: 
			_num	= zoneType.HQ;
		break;
		
		case oZoneCamp: 
			_num	= zoneType.camp;
		break;
		
		case oZoneMoney:
			_num	= zoneType.money;
		break;
		
		case oZoneSupplies:
			_num	= zoneType.supplies;
		break;
		
		case oZoneBootCamp:
			_num	= zoneType.bootCamp;
		break;
		
		case oZoneInfantry: 
			_num	= zoneType.infantry;
		break;
	}
	
	return _num;
}

function localObj_to_netObj(_localObj)
{
	var _netObj = noone;
			
	switch(_localObj)
	{
		case oParZoneLocal:
			_netObj = oParZoneNet;
		break;
		
		case oZoneCamp:
			_netObj = oZoneNetCamp;
		break;
		
		case oZoneBootCamp:
			_netObj = oZoneNetBootCamp;
		break;
		
		case oZoneMoney:
			_netObj = oZoneNetMoney;
		break;
		
		case oZoneSupplies:
			_netObj = oZoneNetSupplies;
		break;
		
		case oZoneInfantry:
			_netObj = oZoneNetInfantry;
		break;
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
		case zoneType.HQ:		_spr = sZoneHQ; break;
		case zoneType.infantry:		_spr = sZoneInfantry; break;
		case zoneType.camp:		_spr = sZoneCamp; break;
		case zoneType.money:	_spr = sZoneMoney; break;
		case zoneType.supplies: _spr = sZoneSupplies; break;
		case zoneType.bootCamp: _spr = sZoneBootCamp; break;
		
	}
	
	return _spr;
}