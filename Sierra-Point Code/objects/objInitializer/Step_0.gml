if (keyboard_check_pressed(vk_f1))
{
	var _windowType = window_set_fullscreen(!window_get_fullscreen());
	
	// Resolution
	global.RES_W = display_get_width();
	global.RES_H = display_get_height();

	if !_windowType
	{
		// Resolution
		global.RES_W *= 0.5;
		global.RES_H *= 0.5;
	}
	
	room_restart();
}

if(keyboard_check_pressed(vk_f2)){
	global.debug = !global.debug;
}