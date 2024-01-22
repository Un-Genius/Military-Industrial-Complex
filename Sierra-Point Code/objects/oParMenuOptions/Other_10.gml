/// @description --PUT YOUR COMMANDS ON THIS EVENT--

/* 
put them on your inherited buttons and 
call this parent event with event_inherited();
to get the sounds and other behaviors
*/


#region SOUND

var snd = audio_play_sound(soundClick, 10, false);
audio_sound_pitch(snd, random_range(0.9, 1.1));

#endregion

// EXECUTE

///CREATE BUTTONS & PANEL
var _hh = display_get_height();

var _offset = 20;
var _btn_width = 250;
var _btn_height = 100;
var _btn_offset = 5;

var _wx = (_offset*3 + (_offset*2))*4;
var _wy = _offset*3 + (_offset*2);

var _inst = instance_create(_wx, _offset*3, objGUIPanel)
_inst.width = (_offset*4) + _btn_width;
_inst.height = _hh - (_offset*3*6)
ds_list_add(button_instances, _inst)

_wx += (_offset*2);
_inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Audio");
ds_list_add(button_instances, _inst)

_wy += _btn_height + _btn_offset;
_inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Controls");
ds_list_add(button_instances, _inst)

_wy += _btn_height + _btn_offset;
_inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Graphics");
ds_list_add(button_instances, _inst)

_inst = gui_create_button(_wx, _hh - (_offset*3*2) - (_offset*16), _btn_width, _btn_height, "Back", func_event_user, id, 2);
ds_list_add(button_instances, _inst)