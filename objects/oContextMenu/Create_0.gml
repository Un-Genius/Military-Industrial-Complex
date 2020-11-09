// Create grid for data slots
/*
0 - "Name"
1 - Script
2 - Boolean
*/
contextGrid = ds_grid_create(3, 1);

// Update position
mousePressGui_x	= device_mouse_x_to_gui(0);
mousePressGui_y	= device_mouse_y_to_gui(0);

openMenu = -1;

// Set heirarchy
level = 0;

event_user(0);