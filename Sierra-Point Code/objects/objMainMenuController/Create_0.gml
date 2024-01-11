event_inherited();

///CREATE BUTTONS & PANEL
var _ww = display_get_width();

//surface_get_width(application_surface);

var _offset = 20;
var _btn_width = 250;
var _btn_height = 100;
var _btn_offset = 5;

width = (_offset*2) + _btn_width;
height = (_offset*2) + _btn_height + ((_btn_height+_btn_offset) * 3);

x = (_ww div 2) //middle of the screen
    -(width div 2);

y = 150;

var _wx = x + _offset;
var _wy = y + _offset;

gui_create_button(_wx, _wy, _btn_width, _btn_height, "Play", func_room_goto, roomPlayMenu);

_wy += _btn_height + _btn_offset;
gui_create_button(_wx, _wy, _btn_width, _btn_height, "Options", func_room_goto, roomOptions);

_wy += _btn_height + _btn_offset;
gui_create_button(_wx, _wy, _btn_width, _btn_height, "Language", func_room_goto, roomLanguage);

//_wy += _btn_height + _btn_offset;
//gui_create_button(_wx, _wy, _btn_width, _btn_height, "Rebind Keys", func_room_goto, roomRebindKeys);

_wy += _btn_height + _btn_offset;
gui_create_button(_wx, _wy, _btn_width, _btn_height, "Quit", func_game_end);



