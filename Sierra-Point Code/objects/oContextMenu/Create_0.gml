// Create grid for data slots
/*
0 - "Name"
1 - Script
2 - Boolean
3 - Script Argument array

Width for button data
Height for levels of buttons
*/
cm_grid = ds_grid_create(10, 1);

// Update position
mp_gui_x	= device_mouse_x_to_gui(0);
mp_gui_y	= device_mouse_y_to_gui(0);

click_left_pressed	= false;
grid_height = 0;
padding = 5;
outside_padding = 300;
slot_height = 0;
hovering = false;
hovering_proximity = false
cm_background_height = 0;
height_level = 0;

draw_set_font(ftContextMenu);
	width	= string_width("M");;
	height	= string_height("M");
draw_set_font(ftDefault);

folder_timer = -1;

// Set heirarchy
level = 0;

event_user(0);