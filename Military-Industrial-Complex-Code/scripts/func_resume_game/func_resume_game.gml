// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function func_resume_game(){
	with(obj_dialogueSystem)
	{
		// Turn off the menu
		global.in_game_menu = 0;
		
		// Destroy all buttons
		for(var i = 0; i < array_length(menu_elements); i++)
		{
			instance_destroy(menu_elements[i]);
		}
		
		// Reset array
		menu_elements = [];
	}
}