/// @description Set view

view_enabled	= true;
view_visible[0] = true;

var camW = global.RES_W / zoom;
var camH = global.RES_H / zoom;
	
camera_set_view_size(view, camW, camH);