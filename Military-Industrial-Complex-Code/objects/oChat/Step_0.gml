// Get size of chat
var _chatWidth	= sprite_get_width(spr_chat);
var _chatHeight = sprite_get_height(spr_chat);

// Check for press
if device_mouse_check_button_pressed(0, mb_left)
{
	// Check if hovering over chat
	if get_hover(chatX - padding, chatY - (fntSize*chatSize) - (5*chatSize) - padding, chatX + _chatWidth - padding, chatY - (fntSize*chatSize) - (5*chatSize) - padding + _chatHeight)
		{
			active = true;
			
			// Reset chat
			chat_text = "";
			keyboard_string = "";
		}
	else
		active = false;
}

if active
{
	var _lines = 0;
	var _limit = 5;
	var qPos = 1;
	
	// Add buffer
	var baseString = string_insert(" ", chat_text, 0)
	
	while(qPos != 0)
	{
	    baseString = string_delete(baseString, 1, qPos);
	    qPos = string_pos("\n", baseString);
		_lines++;
	}
	
	var add_text = keyboard_string;
	
	// Add new character to text
	if _lines < _limit
		chat_text += add_text;
	
	var _length = string_length(chat_text);
	
	// Delete most recent charactert
	if keyboard_check_pressed(vk_backspace)
		chat_text = string_delete(chat_text, _length, 1);
	
	// Get current line width
	var _width = currentLineWidth(chat_text);
	
	// Check if long enough to break line
	if _width > 420
	{
		_lines++;
		
		if _lines < _limit
			chat_text = string_insert("\n", chat_text, nextSpace);
		else
		{
			chat_text = string_insert("\n", chat_text, _length);
			chat_text = string_delete(chat_text, _length, 10);
		}
	}
	
	// Find next space
	if _lines < _limit
		if string_pos_ext(" ", chat_text, _length - 1)
			nextSpace = _length;
	
	// Reset keyboard
	keyboard_string = "";
}