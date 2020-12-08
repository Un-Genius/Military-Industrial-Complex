/// @description Double Right Click

// Check if holding down
if device_mouse_check_button(0, mb_right)
	doublePress = 3
else
{
	if doublePress == 1
	{
		var _inst = ds_grid_get(global.instGrid, 0, 0);
	
		// Move instance
		if instance_exists(_inst) && _inst.moveSpd != 0
			scr_context_move();
	}

	// Reset
	doublePress = false;
}