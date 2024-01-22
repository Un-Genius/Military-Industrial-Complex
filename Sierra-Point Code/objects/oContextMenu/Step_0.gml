// Right Click
var _click_right_pressed	= device_mouse_check_button_pressed(0, mb_right);
click_left_pressed	= device_mouse_check_button_pressed(0, mb_left);

slot_height = 0;

var _x1 = mp_gui_x;
var _x2 = mp_gui_x + width;
var _y1 = mp_gui_y;
var _y2 = mp_gui_y + (height*grid_height)

hovering = get_hover(_x1, _y1,_x2, _y2)

// Add context menu buttons
if _click_right_pressed
{
	// Update position
	mp_gui_x	= device_mouse_x_to_gui(0);
	mp_gui_y	= device_mouse_y_to_gui(0);
}

grid_height = ds_grid_height(cm_grid);

cm_close_distance()
cm_update_position();
cm_close();