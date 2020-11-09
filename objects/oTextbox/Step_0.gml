#region Get input

var _key_enter_pressed	= keyboard_check_pressed(vk_enter);
var _mouse_left_pressed	= mouse_check_button_pressed(mb_left)

var _x2 = x + width;
var _y2 = y + height;

var _hover = get_hover(x, y, _x2, _y2);

#endregion

#region Activate textbox

if _mouse_left_pressed
{
	if _hover
	{
		active = true;
		if message != ""
			keyboard_string = message;
		else
			keyboard_string = "";
	}
	else
		active = false;
}

if _key_enter_pressed
	active = false;
	
#endregion

if active
{
	if (string_width(keyboard_string) < (sprite_width - 32))
	{
		if limit > 0
		{
			if (string_length(keyboard_string) < limit)
				message = keyboard_string;
			else
				keyboard_string = message;
		}
		else
			message = keyboard_string;
	}
	else
		keyboard_string = message;
}