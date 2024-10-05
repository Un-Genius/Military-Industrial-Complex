draw_sprite_ext(sflagA, -1, x, y, image_xscale, image_yscale, direction, flag_info.color, 1);

if capture_progress >= 0 && capture_progress < capture_time
{
	// Change 0-600 to 0-100
	var _capture_progress = ((capture_progress * 100) / 600);
	
	// Draw shadow Capture Progress
	draw_set_alpha(0.25);
		draw_healthbar(x - 27, y - 73, x + 23, y - 68, _capture_progress, c_black, c_black, c_black, 0, false, true);
	draw_set_alpha(1);
	
	// Draw Capture Progress
	draw_healthbar(x - 25, y - 75, x + 25, y - 70, _capture_progress, c_white, flag_info.color, flag_info_temp.color, 0, false, true);
}