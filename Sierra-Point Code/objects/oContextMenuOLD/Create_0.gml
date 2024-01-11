// Create grid for data slots
/*
0 - "Name"
1 - Script
2 - Boolean
3 - Script Argument array
*/
cm_grid = ds_grid_create(4, 1);

// Update position
mp_gui_x	= device_mouse_x_to_gui(0);
mp_gui_y	= device_mouse_y_to_gui(0);

folder_timer = -1;

// Set heirarchy
level = 0;

width = 0;

event_user(0);