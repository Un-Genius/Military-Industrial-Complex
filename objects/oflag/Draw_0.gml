// Change 0-600 to 0-100
var _capture_progress = ((capture_progress * 100) / 600);

// Creates shadow
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1.5, 345, c_dkgray, 0.2);

// Draw capture progress
if capture_progress >= 10 * room_speed
{
	// Draw flag
	draw_sprite_ext(sflagA, -1, x, y, image_xscale, image_yscale, direction, flag_color, 1);
}
else
{
	if capture_progress > 0
	{
		// Draw shadow Capture Progress
		draw_set_alpha(0.25);
			draw_healthbar(x - 27, y - 53, x + 23, y - 48, _capture_progress, c_black, c_black, c_black, 0, false, true);
		draw_set_alpha(1);

		// Draw Capture Progress
		draw_healthbar(x - 25, y - 55, x + 25, y - 50, _capture_progress, c_white, c_white, flag_color, 0, false, true);
	}
	
	// Draw white flag
	draw_sprite_ext(sflagA, -1, x, y, image_xscale, image_yscale, direction, c_white, 1);
}
// Creates a visible radius for the flag capture zone
draw_circle(x, y, 45, true);