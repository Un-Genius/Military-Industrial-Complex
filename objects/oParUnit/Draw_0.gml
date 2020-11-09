if global.debugMenu
{
	draw_circle(x, y, range, true);
}

// Draw Shadow
draw_sprite_ext(sprite_index, image_index, x + 7, y - 5, image_xscale, image_yscale, image_angle, c_dkgray, 0.2);

// Display selected
if selected
{
	draw_set_color(hashColor);
		draw_circle(x, y, 16, true);
	draw_set_color(-1);
}

draw_self();


debug_event(state);