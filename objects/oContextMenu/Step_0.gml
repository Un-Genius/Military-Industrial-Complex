// Right Click
var _click_right_pressed	= device_mouse_check_button_pressed(0, mb_right);

// Add context menu buttons
if _click_right_pressed
{
	// Update position
	mousePressGui_x	= device_mouse_x_to_gui(0);
	mousePressGui_y	= device_mouse_y_to_gui(0);
}