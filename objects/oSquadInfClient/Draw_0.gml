if global.debugMenu
{
	//draw_circle(x, y, range, true);
	draw_path(path, x, y, true);
	
	draw_text(x, y+32, state);
	draw_text(x, y+48, moveState);
}

// Draw Shadow
draw_sprite_ext(sprite_index, image_index, x + 7, y - 5, image_xscale, image_yscale, image_angle, c_dkgray, 0.2);

draw_self();