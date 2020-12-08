// Move speed
moveSpd = 1;

numColor = oManager.numColor;

hashColor = oManager.hashColor;

// Create and clear list
contextInstList = ds_list_create();
ds_list_clear(contextInstList);

contextMenu = false;

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