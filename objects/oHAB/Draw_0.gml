// Draw Shadow
draw_sprite_ext(sprite_index, image_index, x + 7, y - 5, image_xscale, image_yscale, image_angle, c_dkgray, 0.2);

// Display selected
if selected
{
	draw_set_color(hashColor);
		draw_circle(x, y, 200, true);
		draw_rectangle(x - 15 - (sprite_width/2), y - 15 - (sprite_width/2), x + (sprite_width/2) + 15, y + (sprite_width/2) + 15, true);
	draw_set_color(-1);
}

image_blend = hashColor;

draw_self();