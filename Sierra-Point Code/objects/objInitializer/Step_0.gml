if (keyboard_check_pressed(vk_f1))
	window_set_fullscreen(!window_get_fullscreen());

if(keyboard_check_pressed(vk_f2)){
	global.debug = !global.debug;
}