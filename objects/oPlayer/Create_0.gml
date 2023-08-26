// Move speed
movementSpeed = 1;

numColor = oManager.numColor;

hashColor = oManager.hashColor;

// Create and clear list
contextInstList = ds_list_create();
ds_list_clear(contextInstList);

squadObjectList = ds_list_create();

contextMenu = false;

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

#region Mouse actions

// 0 = nothing
// 1 = mouseBox
// 2 = mouseDrag
mousePress = false;

// Mouse starting position
mouseRightPress_x = device_mouse_x(0);
mouseRightPress_y = device_mouse_y(0);

instRightSelected = noone;

mouseLeftPress_x = device_mouse_x(0);
mouseLeftPress_y = device_mouse_y(0);

mouseLeftReleased_x = device_mouse_x(0);
mouseLeftReleased_y = device_mouse_y(0);

// Mouse starting position to GUI
mouseRightPressGui_x	= device_mouse_x_to_gui(0);
mouseRightPressGui_y	= device_mouse_y_to_gui(0);

#endregion