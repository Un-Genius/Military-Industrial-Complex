// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function func_in_game_menu(){
	with(obj_dialogueSystem)
	{
		// Reset menu
		func_reset_menu();
		
		///CREATE BUTTONS & PANEL
		var _ww = global.RES_W;

		//surface_get_width(application_surface);

		var _offset = 20;
		var _btn_width = 250;
		var _btn_height = 100;
		var _btn_offset = 5;

		var width = (_offset*2) + _btn_width;
		//var height = (_offset*2) + _btn_height + ((_btn_height+_btn_offset) * 4);

		x = (_ww div 2) //middle of the screen
			-(width div 2);

		y = 100;

		var _wx = x + _offset;
		var _wy = y + _offset;
		
		var inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Resume", func_resume_game);
		array_push(menu_elements, inst);
		
		_wy += _btn_height + _btn_offset;
		inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Review", menu_review_game);
		array_push(menu_elements, inst);
		
		_wy += _btn_height + _btn_offset;
		inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Main Menu", func_room_goto, roomMenuMain);
		array_push(menu_elements, inst);

		_wy += _btn_height + _btn_offset;
		inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Quit", func_game_end);
		array_push(menu_elements, inst);
	}
}