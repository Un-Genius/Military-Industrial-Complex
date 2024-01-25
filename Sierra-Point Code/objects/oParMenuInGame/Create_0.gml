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


spawn_unit(OBJ_NAME.UNIT_PLAYER, _map_x, _map_y);
spawn_unit(OBJ_NAME.SITE_HQ, _map_x, _map_y);

escape_menu = false;
soundClick = sndClick;

button_instances = ds_list_create();

///CREATE BUTTONS & PANEL
var _ww = display_get_width();
var _hh = display_get_height();

//surface_get_width(application_surface);

var _offset = 20;
var _btn_width = 175;
var _btn_height = 75;
var _btn_offset = 5;

var _wx = (_ww/2) - ((_btn_width + _btn_offset)*2);
var _wy = _hh - _btn_height - (_offset*2);

var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.text = "E: Camp";
_inst.icon = sZoneCamp;
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

_wx += _btn_width + _btn_offset;
var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.text = "R: Supplies";
_inst.icon = sZoneSupplies;
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

_wx += _btn_width + _btn_offset;
var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.text = "T: Money";
_inst.icon = sZoneMoney;
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

_wx += _btn_width + _btn_offset;
var _inst = instance_create(_wx, _wy, oInGameButton)
_inst.text = "Y: Boot\n   Camp";
_inst.icon = sZoneBootCamp;
with(_inst) event_user(3)
ds_list_add(button_instances, _inst)

//width = (_offset*4) + _btn_width;
//height = _hh - (_offset*3*2)