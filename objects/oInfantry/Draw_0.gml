if selected
	draw_circle_color(x, y, 2, c_yellow, c_yellow, true)

draw_self();

if(global.debugMenu)
{
	draw_set_font(ftSmall);
		draw_text(x+4, y, "Move State: " + string(m_sm.state_name));
		draw_text(x+4, y+6, "Act State: " + string(a_sm.state_name));
		draw_text(x+4, y+12, "Behave State: " + string(b_sm.state_name));
	draw_set_font(ftDefault);
	
	draw_circle(x, y, weapon_range, true);
}