// Move speed
movementSpeed = 1;

numColor = oManager.numColor;

hash_color = oManager.hash_color;

// Create and clear list
contextInstList = ds_list_create();
ds_list_clear(contextInstList);

squadObjectList = ds_list_create();

contextMenu = false;

maxTroopsInf = 0;

// Duds
pathGoalX = 0;
pathGoalY = 0;

// Zoning
zoning = -1;

// Zoom
zoom = 1;
target_zoom = zoom;
cam_smooth	= 0.1;
zoom_smooth	= 0.1;

// Follow target
camera_target = oPlayer;

buildingPlaceholder = noone;

// Double click
// 0 = false
// 1 = pressed once
// 2 = pressed twice
// 3 = Holding down

doublePress = false;

buildingName = "";
buildingPlacement = noone;
buildingIntersect = false;

instance_selected = noone;
instances_selected_list = ds_grid_width(global.instGrid);

#region Mouse actions

// 0 = nothing
// 1 = mouseBox
// 2 = mouseDrag
mousePress = false;

// Mouse starting position
mouseRightPress_x = device_mouse_x(0);
mouseRightPress_y = device_mouse_y(0);

instRightSelected = noone;

mouseLeftPress_x = mouse_x;
mouseLeftPress_y = mouse_y;

mouseLeftReleased_x = device_mouse_x(0);
mouseLeftReleased_y = device_mouse_y(0);

// Mouse starting position to GUI
mouseRightPressGui_x	= device_mouse_x_to_gui(0);
mouseRightPressGui_y	= device_mouse_y_to_gui(0);

#endregion

// Create Particles
global.Wind_Direction = 270;
//global.P_System = part_system_create_layer("Particles", false);
global.Clouds_System = part_system_create_layer("Clouds", false);

// Create Clouds
repeat(8)
{
	var _cloud = instance_create_layer(0, 0, "Clouds", oCloud);
	_cloud.y = irandom(room_height)-500;
}