event_inherited();

///CREATE BUTTONS & PANEL
var _ww = global.RES_W;
var _hh = global.RES_H;

//surface_get_width(application_surface);

var _offset = 20;
var _btn_width = 250;
var _btn_height = 100;
var _btn_offset = 5;

x = _offset*3;
y = _offset*3;

var _wx = x + (_offset*2);
var _wy = y + (_offset*2);

gui_create_button(_wx, _wy, _btn_width, _btn_height, "Join Match\nWIP", func_room_goto, roomMenuJoin);

_wy += _btn_height + _btn_offset;
gui_create_button(_wx, _wy, _btn_width, _btn_height, "Host Match\nWIP", func_room_goto, roomMenuHost);

_wy += _btn_height + _btn_offset;
gui_create_button(_wx, _wy, _btn_width, _btn_height, "Campaign\nWIP", func_room_goto, roomMenuCampaign);

_wy += _btn_height + _btn_offset;
gui_create_button(_wx, _wy, _btn_width, _btn_height, "Options\nWIP", func_room_goto, roomMenuOptions);

gui_create_button(_wx, _hh - (_offset*3*2) - (_offset*4), _btn_width, _btn_height, "Quit", func_game_end);

width = (_offset*4) + _btn_width;
height = _hh - (_offset*3*2)