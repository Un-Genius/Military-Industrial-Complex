// Right Click
var _click_right_pressed	= device_mouse_check_button_pressed(0, mb_right);

// Add context menu buttons
if _click_right_pressed
{
	// Update position
	mp_gui_x	= device_mouse_x_to_gui(0);
	mp_gui_y	= device_mouse_y_to_gui(0);
}