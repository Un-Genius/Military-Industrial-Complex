if room == rm_menu || !instance_exists(camera_target)
	exit;
	
/// @description camera
#macro view view_camera[0]

/// @description 
// Get current view position
var camX = camera_get_view_x(view);
var camY = camera_get_view_y(view);
var camW = camera_get_view_width(view);
var camH = camera_get_view_height(view);
		
// Set camera_target view position
var camera_targetX = camera_target.x - camW/2;
var camera_targetY = camera_target.y - camH/2;

// Clamp the camera_target to room bounds
//camera_targetX = clamp(camera_targetX, 0, room_width - camW);
//camera_targetY = clamp(camera_targetY, 0, room_height - camH);

// Smoothly move the view to the camera_target position
camX = lerp(camX, camera_targetX, cam_smooth);
camY = lerp(camY, camera_targetY, cam_smooth);

// Zooming
var wheel = mouse_wheel_down() - mouse_wheel_up();

if (wheel != 0)
{
	wheel *= 0.5
	
	// Decrease zoom
	if wheel == -0.5 && zoom > 0.5
		zoom -= 0.5;
	
	// Increase zoom
	if wheel == 0.5 && zoom < 3
		zoom += 0.5;
	
	camW = global.RES_W / zoom;
	camH = global.RES_H / zoom;
	
	// Position
	camX = camera_target.x - camW/2;
	camY = camera_target.y - camH/2;
		
	// Clamp the camera_target to room bounds
	//camX = clamp(camX, 0, room_width - camW);
	//camY = clamp(camY, 0, room_height - camH);
}

// Apply view position
camera_set_view_pos(view, camX, camY);
camera_set_view_size(view, camW, camH);