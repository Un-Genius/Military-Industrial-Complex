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
mp_gui_x	= mouse_x;
mp_gui_y	= mouse_y;

click_left_pressed	= false;
click_right_pressed = false;
click_shift = false;

grid_height = 0;
padding = 5;
outside_padding = 300;
slot_height = 0;
hovering = false;
hovering_proximity = false
cm_background_height = 0;
height_level = 0;

draw_set_font(ftContextMenu);
width	= string_width("M");
height	= string_height("M");
scale = 1-oPlayer.zoom;

folder_timer = -1;

// Set heirarchy
level = 0;

var _max = instance_number(oContextMenu);

if _max <= 1
	exit;

var _inst = instance_find(oContextMenu, _max-2);
mp_gui_x = _inst.mp_gui_x + _inst.width + 2;