// Move speed
moveSpd = 1;

numColor = oManager.numColor;

hashColor = oManager.hashColor;

// Create and clear list
contextInstList = ds_list_create();
ds_list_clear(contextInstList);

contextMenu = false;

// Double click
doublePress = false;

#region Mouse actions

// 0 = nothing
// 1 = mouseBox
// 2 = mouseDrag
mousePress = false;

// Mouse starting position
mouseRightPress_x = device_mouse_x(0);
mouseRightPress_y = device_mouse_y(0);

mouseLeftPress_x = device_mouse_x(0);
mouseLeftPress_y = device_mouse_y(0);

mouseLeftReleased_x = device_mouse_x(0);
mouseLeftReleased_y = device_mouse_y(0);

// Mouse starting position to GUI
mouseRightPressGui_x	= device_mouse_x_to_gui(0);
mouseRightPressGui_y	= device_mouse_y_to_gui(0);

#endregion

#region ID of Units

unit	= unitType.air; // Type of unit for health
armor	= 1;

maxHp	= 2;		// How much health points they can have
hp		= maxHp;	// How much health points they have

gun		= noone;	// Type of gun

#endregion