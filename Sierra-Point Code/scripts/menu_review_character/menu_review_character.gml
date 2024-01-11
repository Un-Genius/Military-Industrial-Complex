
function menu_review_character(_inst){
	with(obj_dialogueSystem)
	{
		// Remake all buttons
		menu_review_game();
	
		///SETUP & CREATE BUTTONS & OTHER PANEL
		var elementButtonWidth = 325;
		var elementButtonHeight = 100;
		var elementTextWidth = 550;
		var elementTextHeight = 400;
		var elementOffset = 8;
		var offset = 20;
		var inst;

		var wx = elementButtonWidth + offset;
		var wy = offset;
	
		var _text		= "";
		var _textArr	= _inst.chatHistory;
		
		for(var o = 0; o < array_length(_textArr); o++)
		{
			_text += string_replace_all(string(_textArr[o]), "\n", "") + "\n";
		}
		
		//string_replace_all(string(oDoor.einwohner.chatHistory), ",", "\n");

		inst = instance_create(wx, wy, objGUIContentPanelText);
		inst.text = _text;
		inst.width = elementTextWidth;
		inst.height = elementTextHeight;
		inst.depth = layer_get_depth("Buttons");
		inst.alarm[0] = 1;
		array_push(menu_elements, inst);
		show_debug_message(inst);
	
		wx += elementTextWidth + offset;
		inst = gui_create_button(wx, wy, elementButtonWidth, elementButtonHeight, "Review Language", func_review_language, _inst);
		array_push(menu_elements, inst);
	
		wy += elementButtonHeight + offset;
		inst = gui_create_button(wx, wy, elementButtonWidth, elementButtonHeight, "Review Theory", func_review_theory, _inst);
		array_push(menu_elements, inst);
	
		wy += elementButtonHeight + offset;
		inst = gui_create_button(wx, wy, elementButtonWidth, elementButtonHeight, "Review Questions", func_review_questions, _inst);
		array_push(menu_elements, inst);
		
		wx += elementButtonWidth + offset; wy = offset;
		inst = instance_create(wx, wy, objGUIContentPanelText);
		inst.text = review_text;
		inst.width = elementTextWidth;
		inst.height = elementTextHeight;
		inst.depth = layer_get_depth("Buttons");
		inst.alarm[0] = 1;
		array_push(menu_elements, inst);
	}
}