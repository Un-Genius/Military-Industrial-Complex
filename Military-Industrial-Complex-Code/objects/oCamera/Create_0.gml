// Resolution
global.RES_W = display_get_width();
global.RES_H = display_get_height();

#macro view view_camera[0]

// Set full screen
var _fullscreen = ds_grid_get(global.savedSettings, 1, setting.fullscreen);

window_set_fullscreen(_fullscreen);

if !_fullscreen
{
	// Resolution
	global.RES_W *= 0.5;
	global.RES_H *= 0.5;
}

// Find aspect_ration
aspect_ratio = global.RES_W / global.RES_H;

// Modify width resolution to fit aspect_ratio
global.RES_W = round(global.RES_H * aspect_ratio);

// Check for odd numbers
if(global.RES_W & 1)
	global.RES_W++;

// Resize window
window_set_size(global.RES_W, global.RES_H);

// Delay recenter
alarm[2] = 1;

surface_resize(application_surface, global.RES_W, global.RES_H);
display_set_gui_size(global.RES_W, global.RES_H);