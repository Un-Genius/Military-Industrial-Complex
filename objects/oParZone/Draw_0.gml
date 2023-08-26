// If Selected
if(find_Inst(global.instGrid, 0, id) > -1)
{
	// Draw highlight
	draw_sprite_ext(sZone, 0, x, y, sprite_width / 32, sprite_height / 32, image_angle, c_teal, image_alpha);
}

draw_self();