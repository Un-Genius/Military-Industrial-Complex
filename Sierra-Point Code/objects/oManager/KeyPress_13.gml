/// @description Chat

if active == false
{
	// Turn chat on
	active = !active;

	// Clear chat text
	keyboard_string = "";
	chat_text = "";
}
else
{
	// Turn chat off
	active = !active;
	
	if chat_text != ""
	{
		var _userName = ds_map_find_value(names, steamUserName);
			
		chat_add(_userName, chat_text, $bdbdbd);
		chat_send(chat_text, color.white);
		
		chat_text = "";
	}
}