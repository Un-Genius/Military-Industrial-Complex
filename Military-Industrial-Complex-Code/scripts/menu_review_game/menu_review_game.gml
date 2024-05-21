// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function menu_review_game(){
	with(obj_dialogueSystem)
	{
		// Change the menu
		global.in_game_menu = 2;
		func_reset_menu();
		
		///SETUP & CREATE BUTTONS & OTHER PANEL
		var elementWidth = 250;
		var elementHeight = 100;
		var elementOffset = 8;
		var offset = 20;
		var inst;

		var wx = offset;
		var wy = offset;
		
		for(var i = 0; i < instance_number(oDoor); i++)
		{
			var _inst = instance_find(oDoor, i).einwohner;
			if !instance_exists(_inst)
				continue;
				
			var _name = _inst.myName;
			
			inst = gui_create_button(wx, wy, elementWidth, elementHeight, _name, menu_review_character, _inst);
			array_push(menu_elements, inst);
			wy += elementHeight + offset;
		}
		
		inst = gui_create_button(wx, wy, elementWidth, elementHeight, "Back", func_in_game_menu);
		array_push(menu_elements, inst);



		//wy += elementHeight + elementOffset;
		//inst = instance_create(wx, wy, objGUICheckbox);
		
		
		/*
		///CREATE BUTTONS & PANEL
		var _ww = display_get_width();

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
		var i = 0;
		
		// Loop through characters that exist and offer each character as a button
		/*
		var inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Resume", func_resume_game);
		in_game_menu_array[i] = inst; i++;
		
		_wy += _btn_height + _btn_offset;
		inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Review", func_review_game);
		in_game_menu_array[i] = inst; i++;
		
		_wy += _btn_height + _btn_offset;
		inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Main Menu", func_room_goto, roomMainFramework);
		in_game_menu_array[i] = inst; i++;

		_wy += _btn_height + _btn_offset;
		inst = gui_create_button(_wx, _wy, _btn_width, _btn_height, "Back", func_game_end);
		in_game_menu_array[i] = inst; i++;
		*/
	}
}