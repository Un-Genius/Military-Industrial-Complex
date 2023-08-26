/// @description camera

// Get current view position
var camX = camera_get_view_x(view);
var camY = camera_get_view_y(view);
var camW = camera_get_view_width(view);
var camH = camera_get_view_height(view);

// Calculate current center of the camera
var oldCenterX = camX + camW / 2;
var oldCenterY = camY + camH / 2;

// Zooming
var wheel = mouse_wheel_down() - mouse_wheel_up();
if (wheel != 0)
{
    wheel *= 0.5;

    // Update target zoom based on wheel direction
    if wheel == -0.5 && target_zoom > 0.5
        target_zoom -= 0.5;

    if wheel == 0.5 && target_zoom < 10
        target_zoom += 0.5;
}

// Smoothly transition zoom level
zoom = lerp(zoom, target_zoom, zoom_smooth);  // zoom_smooth is a value between 0 and 1

// Update camW and camH based on the new zoom
camW = global.RES_W / zoom;
camH = global.RES_H / zoom;

// Recalculate the camera position based on the old center
camX = oldCenterX - camW / 2;
camY = oldCenterY - camH / 2;

// Set camera_target view position
var camera_targetX = x - camW / 2;
var camera_targetY = y - camH / 2;

// Smoothly move the view to the camera_target position
camX = lerp(camX, camera_targetX, cam_smooth);
camY = lerp(camY, camera_targetY, cam_smooth);

// Apply view position and size
camera_set_view_pos(view, camX, camY);
camera_set_view_size(view, camW, camH);
