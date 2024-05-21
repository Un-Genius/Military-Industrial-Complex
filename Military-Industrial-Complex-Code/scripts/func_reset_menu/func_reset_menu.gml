
function func_reset_menu(){
	with(obj_dialogueSystem)
	{
		// Destroy all buttons
		for(var i = 0; i < array_length(menu_elements); i++)
		{
			instance_destroy(menu_elements[i]);
		}
		
		// Reset array
		menu_elements = [];
	}
}