event_inherited();

button_instances = ds_list_create();

///CREATE BUTTONS & PANEL
var _ww = display_get_width();
var _hh = display_get_height();

//surface_get_width(application_surface);

var _offset = 20;
var _btn_width = 250;
var _btn_height = 100;
var _btn_offset = 5;

x = _offset*3;
y = _offset*3;

var _wx = x + (_offset*2);
var _wy = y + (_offset*2);

var _inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Resume", instance_destroy, id);
ds_list_add(button_instances, _inst)

_wy += _btn_height + _btn_offset;
var _inst = instance_create(_wx, _wy, oParMenuOptions)
_inst.width = _btn_width;
_inst.height = _btn_height;
ds_list_add(button_instances, _inst)

var _inst = gui_create_button(_wx, _hh - (_offset*3*2) - (_offset*4), _btn_width, _btn_height, "Quit to Menu", func_room_goto, roomMenuMain);
ds_list_add(button_instances, _inst)

width = (_offset*4) + _btn_width;
height = _hh - (_offset*3*2)