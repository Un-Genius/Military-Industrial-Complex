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
	mp_gui_x	= mouse_x;
	mp_gui_y	= mouse_y;
}

grid_height = ds_grid_height(cm_grid);

/*
scale = 1-oPlayer.zoom;

draw_set_font(ftContextMenu);
width	= string_width("M")*scale;
height	= string_height("M")*scale;
*/

cm_close_distance()
cm_update_position();
cm_close();