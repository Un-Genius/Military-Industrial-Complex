function func_add_character(_object){	
	ds_list_add(global.character_list, _object);
	show_debug_message(_object);
}