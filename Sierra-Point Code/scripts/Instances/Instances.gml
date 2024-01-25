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

/// @function display_money(resources);
/// @param {resources} resources of money to display
function display_money(_x, _y, _resources)
{
	var _inst = instance_create_layer(_x, _y, "UI", oResourceSign);
	_inst.suppliesAmount = _resources;
}

/// @function add_resource(x, y, resources, display_money);
/// @param {resources} resources of money to add
/// @param {display_money} Display_Money_bool
function add_resource(_x, _y, _resources, _display=false)
{
	if(global.resources >= global.resources_max)
		exit;
		
	// Add supplies
	global.resources.supplies	+= min(global.resources_max.supplies,	_resources.supplies);
	global.resources.food		+= min(global.resources_max.food,		_resources.food);
	global.resources.weapons	+= min(global.resources_max.weapons,	_resources.weapons);
	global.resources.people		+= min(global.resources_max.people,		_resources.people);
	global.resources.cm			+= min(global.resources_max.cm,			_resources.cm);
	global.resources.rt			+= min(global.resources_max.rt,			_resources.rt);
	
	if _display
		display_money(_x, _y, _resources);
}

/// @function enum_to_obj(number);
/// @param {number} Enumerator_Number to exchange to object
function enum_to_obj(_num)
{
	var _obj = noone;
	
	switch _num
	{
		case OBJ_NAME.UNIT_PLAYER:			_obj	= oPlayer;				break;
		case OBJ_NAME.SITE_HQ:				_obj	= oSiteHQ;				break;
		case OBJ_NAME.SITE_PRO_SUPPLIES:	_obj	= oSiteCapacityPeople;	break;
		case OBJ_NAME.SITE_PRO_WEAPONS:		_obj	= oSiteProduceSupplies;	break;
		case OBJ_NAME.SITE_CAP_SUPPLIES:	_obj	= oSiteCapacitySupplies;break;
		case OBJ_NAME.SITE_PRO_INF:			_obj	= oSiteProducePeople;	break;
		case OBJ_NAME.UNIT_INF:				_obj	= oInfantry;			break;
		case OBJ_NAME.oTransport:			_obj	= OBJ_NAME.oTransport;	break;
		case OBJ_NAME.oDummy:				_obj	= oDummy;				break;
		case OBJ_NAME.oDummyStronk:			_obj	= oDummyStronk;			break;
		case OBJ_NAME.UNIT_ENEMY_INF:		_obj	= oInfantryAI;			break;
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
		case oPlayer:				_num	= OBJ_NAME.UNIT_PLAYER;			break;
		case oSiteHQ:				_num	= OBJ_NAME.SITE_HQ;				break;
		case oSiteCapacityPeople:	_num	= OBJ_NAME.SITE_PRO_SUPPLIES;	break;
		case oSiteProduceSupplies:	_num	= OBJ_NAME.SITE_PRO_WEAPONS;	break;
		case oSiteCapacitySupplies: _num	= OBJ_NAME.SITE_CAP_SUPPLIES;	break;
		case oSiteProducePeople:	_num	= OBJ_NAME.SITE_PRO_INF;		break;
		case oInfantry:				_num	= OBJ_NAME.UNIT_INF;			break;
		case oDummy:				_num	= OBJ_NAME.oDummy;				break;
		case oDummyStronk:			_num	= OBJ_NAME.oDummyStronk;		break;
		case oInfantryAI:			_num	= OBJ_NAME.UNIT_ENEMY_INF;		break;
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
		case oSiteCapacityPeople:		_netObj = oZoneNetCamp;		break;
		case oSiteProducePeople:	_netObj = oZoneNetBootCamp;	break;
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
function enum_to_spr(_num)
{
	var _spr = noone;
	
	switch _num
	{
		case OBJ_NAME.SITE_HQ:				_spr = sZoneHQ;			break;
		case OBJ_NAME.UNIT_INF:				_spr = sZoneInfantry;	break;
		case OBJ_NAME.SITE_PRO_SUPPLIES:	_spr = sZoneCamp;		break;
		case OBJ_NAME.SITE_PRO_WEAPONS:		_spr = sZoneMoney;		break;
		case OBJ_NAME.SITE_CAP_SUPPLIES:	_spr = sZoneSupplies;	break;
		case OBJ_NAME.SITE_PRO_INF:			_spr = sZoneBootCamp;	break;
		
	}
	
	return _spr;
}