if selected
	draw_circle_color(x, y, 2, c_yellow, c_yellow, true)

if(global.debugMenu)
{
	draw_set_font(ftSmall);
		draw_text(x+4, y, "Move State: " + string(m_sm.state_name));
		draw_text(x+4, y+6, "Act State: " + string(a_sm.state_name));
		draw_text(x+4, y+12, "Behave State: " + string(b_sm.state_name));
	draw_set_font(ftDefault);
	
	draw_circle(x, y, weapon_range, true);
	draw_path(path, x, y, true);
	draw_arrow(x, y, goal_x, goal_y, 15)
}

// Draw Shadow
draw_sprite_ext(sprite_index, image_index, x + 1, y - 2, image_xscale, image_yscale, image_angle+5, c_dkgray, 0.2);
draw_self();