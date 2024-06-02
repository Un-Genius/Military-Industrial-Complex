if oNetwork.lobby_is_owner
{
	// Find player 1 spawn location
	var _map_x = ds_grid_get(oMap.spawnPointGrid, 0, 0);
	var _map_y = ds_grid_get(oMap.spawnPointGrid, 1, 0);
}
else
{
	// Find player 2 spawn location
	var _map_x = ds_grid_get(oMap.spawnPointGrid, 0, 1);
	var _map_y = ds_grid_get(oMap.spawnPointGrid, 1, 1);
}


spawn_unit(oPlayer, _map_x, _map_y);
spawn_unit(oSiteHQ, _map_x, _map_y);

instance_create(0, 0, oResourceDisplay)

escape_menu = false;
soundClick = sndClick;

button_instances = ds_list_create();

///CREATE BUTTONS & PANEL
var _ww = global.RES_W;
var _hh = global.RES_H;

//surface_get_width(application_surface);

var _offset = 20;
var _btn_width = 195;
var _btn_height = 75;
var _btn_offset = 5;

var _wx = (_ww/2) - ((_btn_width + _btn_offset)*2);
var _wy = _hh - _btn_height - _offset;

var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.site_type = oSiteProduceEnergy
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

_wx += _btn_width + _btn_offset;
var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.site_type = oSiteCapacityOil
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

_wx += _btn_width + _btn_offset;
var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.site_type = oSiteCapacityLightSupplies
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

_wx += _btn_width + _btn_offset;
var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.site_type = oSiteCapacityHeavySupplies
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

_wx += _btn_width + _btn_offset;
var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.site_type = oSiteCapacityAdvancedSupplies
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

// ------------------------------------------ SECOND LINE 
_wy -= _btn_height + (_offset);
_wx = (_ww/2) - ((_btn_width + _btn_offset)*2);

var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.site_type = oSiteProduceInfantry
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

_wx += _btn_width + _btn_offset;
var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.site_type = oSiteProduceOil
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

_wx += _btn_width + _btn_offset;
var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.site_type = oSiteProduceLightSupplies
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

_wx += _btn_width + _btn_offset;
var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.site_type = oSiteProduceHeavySupplies
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

_wx += _btn_width + _btn_offset;
var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.site_type = oSiteProduceAdvancedSupplies
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

//width = (_offset*4) + _btn_width;
//height = _hh - (_offset*3*2)